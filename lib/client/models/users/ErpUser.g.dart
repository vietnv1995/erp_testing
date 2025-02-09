// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ErpUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErpUser _$ErpUserFromJson(Map<String, dynamic> json) => ErpUser(
      name: json['name'] as String?,
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
      user_name: json['user_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$ErpUserToJson(ErpUser instance) => <String, dynamic>{
      'user_name': instance.user_name,
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'address': instance.address,
      'avatar': instance.avatar,
    };
