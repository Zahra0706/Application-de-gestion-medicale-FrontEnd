import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/patient.dart';
import '../../models/utilisateur.dart';
import '../../view_models/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _cinController = TextEditingController();
  final _telephoneController = TextEditingController();

  String? _selectedSexe;

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
                // Champ Nom
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                // Champ Prénom
                TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre prénom';
                    }
                    return null;
                  },
                ),
                // Champ Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                // Champ Mot de passe
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                // Champ CIN
                TextFormField(
                  controller: _cinController,
                  decoration: const InputDecoration(labelText: 'CIN (Optionnel)'),
                ),
                // Champ Téléphone
                TextFormField(
                  controller: _telephoneController,
                  decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
                  keyboardType: TextInputType.phone,
                ),
                // Liste déroulante pour le sexe
                DropdownButtonFormField<String>(
                  value: _selectedSexe,
                  decoration: const InputDecoration(labelText: 'Sexe'),
                  items: ['Homme', 'Femme']
                      .map((sexe) => DropdownMenuItem(
                    value: sexe,
                    child: Text(sexe),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSexe = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner votre sexe';
                    }
                    return null;
                  },
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
                      // 1. Créer l'objet Utilisateur
                      final utilisateur = Utilisateur(
                        id: 0, // 0 car pas encore créé en base
                        nom: _nomController.text,
                        prenom: _prenomController.text,
                        email: _emailController.text,
                        CIN: _cinController.text.isEmpty ? null : _cinController.text,
                        password: _passwordController.text,
                        numeroTel: _telephoneController.text.isEmpty ? null : _telephoneController.text,
                        dateNaissance: null, // Ajouter un sélecteur de date plus tard
                        createdAt: DateTime.now(),
                        isActif: true,
                      );

                      // 2. Créer l'objet Patient
                      final patient = Patient(
                        idPatient: 0, // 0 car pas encore créé en base
                        sexe: _selectedSexe!,
                        groupeSanguin: null, // À ajouter dans le formulaire si besoin
                        adresse: null, // À ajouter dans le formulaire si besoin
                        ville: null, // À ajouter dans le formulaire si besoin
                        poids: null, // À ajouter dans le formulaire si besoin
                        taille: null, // À ajouter dans le formulaire si besoin
                        utilisateur: utilisateur,
                      );

                      // 3. Appeler le ViewModel pour l'inscription
                      authViewModel.registerPatient(patient, _passwordController.text);
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