import 'package:json_annotation/json_annotation.dart';

part 'ErpUser.g.dart';

@JsonSerializable()
class ErpUser {
  /// The generated code assumes these values exist in JSON.
  final String user_name;
  final String email;
  final String password;

  final String? name;
  final String? address;
  final String? avatar;



  ErpUser( {this.name, this.address, this.avatar, required this.user_name, required this.email, required this.password});

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory ErpUser.fromJson(Map<String, dynamic> json) => _$ErpUserFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ErpUserToJson(this);
}