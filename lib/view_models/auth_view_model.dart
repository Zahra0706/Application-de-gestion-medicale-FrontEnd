import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;
  Patient? _currentPatient;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Patient? get currentPatient => _currentPatient;

  // Actions
  Future<void> registerPatient(Patient patient, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentPatient = await _authRepository.registerPatient(patient, password);
      // Succès ! Vous pouvez naviguer vers l'écran d'accueil ici.
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String token = await _authRepository.login(email, password);
      // Succès ! Sauvegardez le token (avec shared_preferences) et naviguez.
      print("Token reçu: $token");
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}