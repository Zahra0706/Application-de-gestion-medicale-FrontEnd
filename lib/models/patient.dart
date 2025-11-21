import 'package:json_annotation/json_annotation.dart';
import 'utilisateur.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient {
  final int idPatient;
  final String sexe; // "Homme" ou "Femme"
  final String? groupeSanguin;
  final String? adresse;
  final String? ville;
  final double? poids;
  final double? taille;
  // Ceci est crucial : un Patient EST un Utilisateur
  final Utilisateur utilisateur;

  Patient({
    required this.idPatient,
    required this.sexe,
    this.groupeSanguin,
    this.adresse,
    this.ville,
    this.poids,
    this.taille,
    required this.utilisateur,
  });

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}