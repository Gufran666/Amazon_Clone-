import 'package:amazon_clone/presentation/screens/activation_screen.dart';
import 'package:amazon_clone/presentation/screens/authentication_screen.dart';
import 'package:amazon_clone/presentation/screens/checkout_review_screen.dart';
import 'package:amazon_clone/presentation/screens/home_screen.dart';
import 'package:amazon_clone/presentation/screens/no_internet_screen.dart';
import 'package:amazon_clone/presentation/screens/order_confirmation_screen.dart';
import 'package:amazon_clone/presentation/screens/order_history_screen.dart';
import 'package:amazon_clone/presentation/screens/order_tracking_map_screen.dart';
import 'package:amazon_clone/presentation/screens/password_recovery_screen.dart';
import 'package:amazon_clone/presentation/screens/payment_method_screen.dart';
import 'package:amazon_clone/presentation/screens/profile_overview_screen.dart';
import 'package:amazon_clone/presentation/screens/search_screen.dart';
import 'package:amazon_clone/presentation/screens/server_error_screen.dart';
import 'package:amazon_clone/presentation/screens/shipping_address_screen.dart';
import 'package:amazon_clone/presentation/screens/shopping_cart_screen.dart';
import 'package:amazon_clone/presentation/screens/splash_screen.dart';
import 'package:amazon_clone/presentation/screens/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:amazon_clone/presentation/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  // Initialize Supabase
  await supabase.Supabase.initialize(
    url: 'SUPABASE_URL',
    anonKey: 'SUPABASE_ANON_KEY',
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    ProviderScope(
      child: const AmazonCloneApp(),
    ),
  );
}

class AmazonCloneApp extends StatelessWidget {
  const AmazonCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/home': (context) => const HomeScreen(),
        '/authentication': (context) => const AuthenticationScreen(isSignUp: true),
        '/search': (context) => const SearchScreen(),
        '/cart': (context) => const ShoppingCartScreen(),
        '/orders': (context) => const OrderHistoryScreen(),
        '/profile': (context) => const ProfileOverviewScreen(),
        '/checkout': (context) => const CheckoutReviewScreen(),
        '/payment': (context) => const PaymentMethodScreen(),
        '/order/confirmation': (context) => const OrderConfirmationScreen(),
        '/order/tracking': (context) => const OrderTrackingMapScreen(),
        '/shipping': (context) => const ShippingAddressScreen(),
        '/wishlist': (context) => const WishListScreen(),
        '/no-internet': (context) => const NoInternetScreen(),
        '/server-error': (context) => const ServerErrorScreen(),
        '/password-recovery': (context) => const PasswordRecoveryScreen(),
        '/activation': (context) => const AccountActivationScreen(),
      },
    );
  }
}

// Add this provider for authentication state
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});