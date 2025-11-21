import '../models/patient.dart';

abstract class AuthService {
  // Pour l'inscription, on envoie les données du Patient ET de l'Utilisateur
  Future<Patient> registerPatient(Patient patient, String password);
  Future<String> login(String email, String password); // Retourne un token JWT
  Future<void> logout();
}