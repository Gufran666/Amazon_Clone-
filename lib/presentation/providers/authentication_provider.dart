import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;
import 'package:shared_preferences/shared_preferences.dart';

// Firebase Auth Provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Google Sign In Provider
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

// Authentication State Provider
final authenticationProvider = StateNotifierProvider<AuthenticationNotifier, AuthState>((ref) {
  return AuthenticationNotifier(ref);
});

// Enum to Handle Authentication States
enum AuthState { initial, loading, error, success }

class AuthenticationNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  late final SharedPreferences _prefs;

  AuthenticationNotifier(this.ref) : super(AuthState.initial) {
    initAuthStatus();
  }

  // Initialize Authentication Status
  Future<void> initAuthStatus() async {
    _prefs = await SharedPreferences.getInstance();
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      _prefs.setBool('isAuthenticated', true);
      state = AuthState.success;
    } else {
      _prefs.setBool('isAuthenticated', false);
      state = AuthState.error;
    }
  }

  // --- Email/Password Methods ---
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = AuthState.loading;
    try {
      await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = ref.read(firebaseAuthProvider).currentUser;
      if (user != null) {
        _prefs.setBool('isAuthenticated', true);
        state = AuthState.success;
      }
    } on FirebaseAuthException catch (_) {
      state = AuthState.error;
      rethrow;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = AuthState.loading;
    try {
      await ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = ref.read(firebaseAuthProvider).currentUser;
      await user?.sendEmailVerification();
      _prefs.setBool('isAuthenticated', false);
      state = AuthState.success;
    } on FirebaseAuthException catch (_) {
      state = AuthState.error;
      rethrow;
    }
  }

  // --- Google Sign-In ---
  Future<void> signInWithGoogle() async {
    state = AuthState.loading;
    try {
      final GoogleSignInAccount? googleUser = await ref.read(googleSignInProvider).signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await ref.read(firebaseAuthProvider).signInWithCredential(credential);
      _prefs.setBool('isAuthenticated', true);
      state = AuthState.success;
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }

  // --- Facebook Login ---
  Future<void> signInWithFacebook() async {
    state = AuthState.loading;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);
        await ref.read(firebaseAuthProvider).signInWithCredential(facebookAuthCredential);
        _prefs.setBool('isAuthenticated', true);
        state = AuthState.success;
      } else {
        state = AuthState.error;
      }
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }


  Future<void> signInWithApple() async {
    state = AuthState.loading;
    try {
      final credential = await apple.SignInWithApple.getAppleIDCredential(
        scopes: [
          apple.AppleIDAuthorizationScopes.email,
          apple.AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await ref.read(firebaseAuthProvider).signInWithCredential(oauthCredential);
      _prefs.setBool('isAuthenticated', true);
      state = AuthState.success;
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }


  // --- Sign Out ---
  Future<void> signOut() async {
    try {
      await ref.read(firebaseAuthProvider).signOut();
      await ref.read(googleSignInProvider).disconnect();
      _prefs.setBool('isAuthenticated', false);
      state = AuthState.success;
    } catch (e) {
      state = AuthState.error;
    }
  }
  Future<void> activateAccount() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null && user.emailVerified) {
      _prefs.setBool('isAuthenticated', true);
      state = AuthState.success;
    } else {
      state = AuthState.error;
    }
  }

}