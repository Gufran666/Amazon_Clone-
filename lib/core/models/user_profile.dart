import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String? profilePictureUrl;
  final String? shippingAddress;
  final String? phoneNumber;
  final List<String> wishList;
  final Map<String, dynamic> preferences;
  final String themePreference;
  final List<String> browsingHistory;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.profilePictureUrl,
    this.shippingAddress,
    this.phoneNumber,
    this.wishList = const [],
    this.preferences = const {},
    this.themePreference = 'dark',
    this.browsingHistory = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? userId,
    String? name,
    String? email,
    String? profilePictureUrl,
    String? shippingAddress,
    String? phoneNumber,
    List<String>? wishList,
    Map<String, dynamic>? preferences,
    String? themePreference,
    List<String>? browsingHistory,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      wishList: wishList ?? this.wishList,
      preferences: preferences ?? this.preferences,
      themePreference: themePreference ?? this.themePreference,
      browsingHistory: browsingHistory ?? this.browsingHistory,
    );
  }
}
