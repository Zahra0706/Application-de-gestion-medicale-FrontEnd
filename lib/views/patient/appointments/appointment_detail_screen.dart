import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/appointment.dart';
import '../../../view_models/patient_auth_view_model.dart';
import '../../../view_models/patient/appointment_view_model.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({Key? key, required this.appointment})
    : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    // Re-find appointment in list to get updated status if changed
    final viewModel = Provider.of<AppointmentViewModel>(context);
    final currentAppointment = viewModel.appointments.firstWhere(
      (a) => a.id == widget.appointment.id,
      orElse: () => widget.appointment,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du Rendez-vous"),
        backgroundColor: const Color(0xFF567991),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard(currentAppointment),
            const SizedBox(height: 16),
            _buildDetailsCard(currentAppointment),
            const SizedBox(height: 24),
            if (currentAppointment.status == 'PENDING' ||
                currentAppointment.status == 'CONFIRMED')
              _buildCancelButton(context, currentAppointment),
            if (currentAppointment.status == 'COMPLETED')
              const SizedBox.shrink(), // Placeholder for prescription button
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(Appointment appointment) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF567991),
              child: Text(
                appointment.doctorName.isNotEmpty
                    ? appointment.doctorName[0]
                    : 'D',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              appointment.doctorName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              appointment.specialty,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _buildStatusChip(appointment.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(Appointment appointment) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(
              Icons.calendar_today,
              "Date",
              appointment.dateTime.toIso8601String().split('T')[0],
            ),
            const Divider(),
            _buildDetailRow(
              Icons.access_time,
              "Heure",
              "${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}",
            ),
            const Divider(),
            _buildDetailRow(
              Icons.timer,
              "Durée",
              "${appointment.duration} minutes",
            ),
            if (appointment.reason != null &&
                appointment.reason!.isNotEmpty) ...[
              const Divider(),
              _buildDetailRow(Icons.notes, "Motif", appointment.reason!),
            ],
            if (appointment.notesPatient != null &&
                appointment.notesPatient!.isNotEmpty) ...[
              const Divider(),
              _buildDetailRow(
                Icons.info_outline,
                "Notes",
                appointment.notesPatient!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF567991), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'CONFIRMED':
        color = Colors.green;
        label = 'Confirmé';
        break;
      case 'PENDING':
        color = Colors.orange;
        label = 'En attente';
        break;
      case 'CANCELLED':
        color = Colors.red;
        label = 'Annulé';
        break;
      case 'COMPLETED':
        color = Colors.blue;
        label = 'Terminé';
        break;
      case 'REJECTED':
        color = Colors.red;
        label = 'Refusé';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  Widget _buildCancelButton(BuildContext context, Appointment appointment) {
    if (_isCancelling) {
      return const Center(child: CircularProgressIndicator());
    }

    return ElevatedButton.icon(
      onPressed: () => _showCancelDialog(context, appointment),
      icon: const Icon(Icons.cancel),
      label: const Text("Annuler le rendez-vous"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[50], // Very light red
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Appointment appointment) {
    // Check 24h rule locally first for immediate feedback
    final now = DateTime.now();
    final diff = appointment.dateTime.difference(now);

    if (diff.inHours < 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Impossible d'annuler moins de 24h à l'avance. Contactez le secrétariat.",
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Annuler le rendez-vous ?"),
        content: const Text(
          "Cette action est irréversible. Le créneau sera libéré.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Retour"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cancelAppointment(appointment.id);
            },
            child: const Text(
              "Confirmer l'annulation",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAppointment(int id) async {
    setState(() => _isCancelling = true);
    try {
      final authViewModel = Provider.of<PatientAuthViewModel>(
        context,
        listen: false,
      );
      final viewModel = Provider.of<AppointmentViewModel>(
        context,
        listen: false,
      );

      final token = authViewModel.authResponse?.token;
      if (token == null) return;

      final success = await viewModel.cancelAppointment(token, id);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rendez-vous annulé avec succès.")),
        );
        Navigator.pop(context); // Return to list
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erreur: ${viewModel.error}")));
      }
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }
}
