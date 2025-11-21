import 'package:json_annotation/json_annotation.dart';

part 'utilisateur.g.dart';

@JsonSerializable()
class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String? CIN; // Peut être null
  final String password; // À cacher côté front après le dev
  final String? numeroTel;
  final DateTime? dateNaissance;
  final DateTime createdAt;
  final bool isActif;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.CIN,
    required this.password,
    this.numeroTel,
    this.dateNaissance,
    required this.createdAt,
    required this.isActif,
  });

  // Méthodes pour la sérialisation JSON (générées par build_runner)
  factory Utilisateur.fromJson(Map<String, dynamic> json) =>
      _$UtilisateurFromJson(json);
  Map<String, dynamic> toJson() => _$UtilisateurToJson(this);
}