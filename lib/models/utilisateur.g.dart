// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateur.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Utilisateur _$UtilisateurFromJson(Map<String, dynamic> json) => Utilisateur(
  id: (json['id'] as num).toInt(),
  nom: json['nom'] as String,
  prenom: json['prenom'] as String,
  email: json['email'] as String,
  CIN: json['CIN'] as String?,
  password: json['password'] as String,
  numeroTel: json['numeroTel'] as String?,
  dateNaissance: json['dateNaissance'] == null
      ? null
      : DateTime.parse(json['dateNaissance'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isActif: json['isActif'] as bool,
);

Map<String, dynamic> _$UtilisateurToJson(Utilisateur instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'email': instance.email,
      'CIN': instance.CIN,
      'password': instance.password,
      'numeroTel': instance.numeroTel,
      'dateNaissance': instance.dateNaissance?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'isActif': instance.isActif,
    };
