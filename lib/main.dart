import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/patient_auth_view_model.dart';
import 'view_models/doctor_auth_view_model.dart';
import 'views/auth/combined_login_screen.dart';
import 'view_models/auth_view_model.dart';
import 'repositories/auth_repository.dart';
import 'services/auth_service.dart';
import 'services/api_auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = ApiAuthService();
    final AuthRepository authRepository = AuthRepository(authService);

    // Legacy support if needed
    final AuthViewModel authViewModel = AuthViewModel(authRepository);

    // New ViewModels
    final PatientAuthViewModel patientAuthViewModel = PatientAuthViewModel(
      authRepository,
    );
    final DoctorAuthViewModel doctorAuthViewModel = DoctorAuthViewModel(
      authRepository,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authViewModel),
        ChangeNotifierProvider(create: (_) => patientAuthViewModel),
        ChangeNotifierProvider(create: (_) => doctorAuthViewModel),
      ],
      child: MaterialApp(
        title: 'MedConnect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // Add custom color palette if needed to match strictly
        ),
        home: const CombinedLoginScreen(),
      ),
    );
  }
}
