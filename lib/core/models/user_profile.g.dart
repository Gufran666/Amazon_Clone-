// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  userId: json['userId'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  shippingAddress: json['shippingAddress'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  wishList:
      (json['wishList'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
  themePreference: json['themePreference'] as String? ?? 'dark',
  browsingHistory:
      (json['browsingHistory'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'profilePictureUrl': instance.profilePictureUrl,
      'shippingAddress': instance.shippingAddress,
      'phoneNumber': instance.phoneNumber,
      'wishList': instance.wishList,
      'preferences': instance.preferences,
      'themePreference': instance.themePreference,
      'browsingHistory': instance.browsingHistory,
    };
