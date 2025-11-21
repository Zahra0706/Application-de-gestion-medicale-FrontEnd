// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  idPatient: (json['idPatient'] as num).toInt(),
  sexe: json['sexe'] as String,
  groupeSanguin: json['groupeSanguin'] as String?,
  adresse: json['adresse'] as String?,
  ville: json['ville'] as String?,
  poids: (json['poids'] as num?)?.toDouble(),
  taille: (json['taille'] as num?)?.toDouble(),
  utilisateur: Utilisateur.fromJson(
    json['utilisateur'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  'idPatient': instance.idPatient,
  'sexe': instance.sexe,
  'groupeSanguin': instance.groupeSanguin,
  'adresse': instance.adresse,
  'ville': instance.ville,
  'poids': instance.poids,
  'taille': instance.taille,
  'utilisateur': instance.utilisateur,
};
