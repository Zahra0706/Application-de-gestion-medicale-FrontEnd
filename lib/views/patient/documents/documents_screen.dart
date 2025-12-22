import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../view_models/patient/medical_document_view_model.dart';
import '../../../models/medical_document_model.dart';

import '../../../view_models/patient_auth_view_model.dart';
import '../../common/document_viewer_screen.dart';
import 'widgets/document_widgets.dart';
import 'widgets/upload_document_dialog.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDocuments();
    });
  }

  Future<void> _loadDocuments() async {
    final authViewModel = Provider.of<PatientAuthViewModel>(
      context,
      listen: false,
    );
    final token = authViewModel.authResponse?.token;

    if (token != null) {
      await Provider.of<MedicalDocumentViewModel>(
        context,
        listen: false,
      ).fetchDocuments(token);
    }
  }

  Future<void> _showUploadDialog() async {
    final authViewModel = Provider.of<PatientAuthViewModel>(
      context,
      listen: false,
    );
    final token = authViewModel.authResponse?.token;
    if (token == null) return;

    showDialog(
      context: context,
      builder: (context) => UploadDocumentDialog(
        onUpload: (file, title, type, description) async {
          try {
            await Provider.of<MedicalDocumentViewModel>(
              this.context,
              listen: false,
            ).uploadDocument(
              token: token,
              file: file,
              title: title,
              documentType: type,
              description: description,
            );
            if (mounted) {
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(
                  content: Text('Document uploadé avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Text('Erreur lors de l\'upload: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _viewDocument(MedicalDocument doc) {
    if (doc.fileUrl == null || doc.fileUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL du document non disponible')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerScreen(
          url: doc.fileUrl!,
          title: doc.title,
          documentType: doc.documentType,
        ),
      ),
    );
  }

  Future<void> _downloadDocument(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL du document non disponible')),
      );
      return;
    }

    final uri = Uri.parse(url);

    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible d\'ouvrir le lien de téléchargement'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        title: Consumer<MedicalDocumentViewModel>(
          builder: (context, viewModel, child) {
            return Row(
              children: [
                const Text(
                  'Mes Documents',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 8),
                if (viewModel.documents.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${viewModel.documents.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
              ],
            );
          },
        ),
        backgroundColor: const Color(0xFF567991),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Consumer<MedicalDocumentViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading && viewModel.documents.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.error != null && viewModel.documents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Erreur: ${viewModel.error}'),
                        ElevatedButton(
                          onPressed: _loadDocuments,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.documents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun document trouvé',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        if (viewModel.currentFilter != 'Tous')
                          TextButton(
                            onPressed: () => viewModel.setFilter('Tous'),
                            child: const Text('Voir tous les documents'),
                          ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadDocuments,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.documents.length,
                    itemBuilder: (context, index) {
                      final doc = viewModel.documents[index];
                      return DocumentCard(
                        document: doc,
                        onView: () => _viewDocument(doc),
                        onDownload: () => _downloadDocument(doc.fileUrl),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadDialog,
        backgroundColor: const Color(0xFF567991),
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<MedicalDocumentViewModel>(
          builder: (context, viewModel, child) {
            return Row(
              children: [
                _buildFilterChip(viewModel, 'Tous'),
                const SizedBox(width: 8),
                _buildFilterChip(viewModel, 'Ordonnances'),
                const SizedBox(width: 8),
                _buildFilterChip(viewModel, 'Analyses'),
                const SizedBox(width: 8),
                _buildFilterChip(viewModel, 'Autres'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(MedicalDocumentViewModel viewModel, String label) {
    final isSelected = viewModel.currentFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          viewModel.setFilter(label);
        }
      },
      selectedColor: const Color(0xFF567991).withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF567991) : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
