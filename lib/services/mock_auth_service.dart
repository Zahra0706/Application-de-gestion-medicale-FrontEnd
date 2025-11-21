import 'auth_service.dart';
import '../models/patient.dart';
import '../models/utilisateur.dart';

class MockAuthService implements AuthService {
  // Simule un délai réseau
  Future<void> _simulateDelay() => Future.delayed(Duration(seconds: 2));

  @override
  Future<Patient> registerPatient(Patient patient, String password) async {
    await _simulateDelay();

    // Simule une erreur si l'email existe déjà
    if (patient.utilisateur.email == 'existe@test.com') {
      throw Exception('Email déjà utilisé');
    }

    // Simule une réponse réussie du serveur
    // Le serveur aurait créé l'Utilisateur et le Patient, et renvoie le Patient complet avec son ID
    final Patient registeredPatient = Patient(
      idPatient: 1, // ID simulé
      sexe: patient.sexe,
      groupeSanguin: patient.groupeSanguin,
      adresse: patient.adresse,
      ville: patient.ville,
      poids: patient.poids,
      taille: patient.taille,
      utilisateur: Utilisateur(
        id: 1, // ID simulé
        nom: patient.utilisateur.nom,
        prenom: patient.utilisateur.prenom,
        email: patient.utilisateur.email,
        CIN: patient.utilisateur.CIN,
        password: 'hidden', // Le vrai mot de passe n'est jamais renvoyé
        numeroTel: patient.utilisateur.numeroTel,
        dateNaissance: patient.utilisateur.dateNaissance,
        createdAt: DateTime.now(),
        isActif: true,
      ),
    );

    return registeredPatient;
  }

  @override
  Future<String> login(String email, String password) async {
    await _simulateDelay();

    if (email == 'patient@test.com' && password == 'password') {
      return "mock_jwt_token_12345"; // Simule un token JWT
    } else {
      throw Exception('Identifiants incorrects');
    }
  }

  @override
  Future<void> logout() async {
    await _simulateDelay();
    print("Déconnexion simulée");
  }
}