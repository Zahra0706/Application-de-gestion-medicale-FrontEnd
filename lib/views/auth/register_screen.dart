import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/register_request.dart';
import '../../view_models/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Username (obligatoire)
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Nom d\'utilisateur*'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email*'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Mot de passe
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mot de passe*'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Minimum 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Prénom
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                ),
                const SizedBox(height: 10),

                // Nom
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 10),

                // Téléphone
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                // Groupe sanguin
                TextFormField(
                  controller: _bloodTypeController,
                  decoration: const InputDecoration(labelText: 'Groupe sanguin (ex: A+)'),
                ),
                const SizedBox(height: 10),

                // Allergies
                TextFormField(
                  controller: _allergiesController,
                  decoration: const InputDecoration(labelText: 'Allergies'),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),

                // Contact d'urgence
                TextFormField(
                  controller: _emergencyContactController,
                  decoration: const InputDecoration(labelText: 'Contact d\'urgence'),
                ),
                const SizedBox(height: 10),

                // Téléphone d'urgence
                TextFormField(
                  controller: _emergencyPhoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone d\'urgence'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // Affichage des erreurs
                if (authViewModel.errorMessage != null)
                  Text(
                    authViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                // Bouton d'inscription
                authViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final request = RegisterRequest(
                        username: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        first_name: _firstNameController.text.isEmpty
                            ? null
                            : _firstNameController.text,
                        last_name: _lastNameController.text.isEmpty
                            ? null
                            : _lastNameController.text,
                        phone: _phoneController.text.isEmpty
                            ? null
                            : _phoneController.text,
                        role: "PATIENT",
                        blood_type: _bloodTypeController.text.isEmpty
                            ? null
                            : _bloodTypeController.text,
                        allergies: _allergiesController.text.isEmpty
                            ? null
                            : _allergiesController.text,
                        emergency_contact: _emergencyContactController.text.isEmpty
                            ? null
                            : _emergencyContactController.text,
                        emergency_phone: _emergencyPhoneController.text.isEmpty
                            ? null
                            : _emergencyPhoneController.text,
                      );

                      authViewModel.registerPatient(request);
                    }
                  },
                  child: const Text("S'inscrire"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}