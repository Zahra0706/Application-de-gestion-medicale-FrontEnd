import '../models/patient.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<Patient> registerPatient(Patient patient, String password) {
    return _authService.registerPatient(patient, password);
  }

  Future<String> login(String email, String password) {
    return _authService.login(email, password);
  }
}