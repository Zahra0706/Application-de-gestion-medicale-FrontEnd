import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/patient_auth_view_model.dart';
import 'view_models/doctor_auth_view_model.dart';
import 'view_models/patient/patient_dashboard_view_model.dart';
import 'view_models/patient/appointment_view_model.dart';
import 'view_models/patient/patient_profile_view_model.dart';
import 'view_models/patient/medical_document_view_model.dart';
import 'view_models/patient/medical_record_view_model.dart';
import 'view_models/auth_view_model.dart';
import 'views/auth/combined_login_screen.dart';
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
    final PatientDashboardViewModel patientDashboardViewModel =
        PatientDashboardViewModel();
    final AppointmentViewModel appointmentViewModel = AppointmentViewModel();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authViewModel),
        ChangeNotifierProvider(create: (_) => patientAuthViewModel),
        ChangeNotifierProvider(create: (_) => doctorAuthViewModel),
        ChangeNotifierProvider(create: (_) => patientDashboardViewModel),
        ChangeNotifierProvider(create: (_) => appointmentViewModel),
        ChangeNotifierProvider(create: (_) => PatientProfileViewModel()),
        ChangeNotifierProvider(create: (_) => MedicalDocumentViewModel()),
        ChangeNotifierProvider(create: (_) => MedicalRecordViewModel()),
      ],
      child: MaterialApp(
        title: 'MedConnect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F9FC),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(
                primary: const Color(0xFF567991),
                secondary: const Color(0xFF86B7D7),
              ),
        ),
        home: const CombinedLoginScreen(),
      ),
    );
  }
}
