class Appointment {
  final int id;
  final int doctorId;
  final String doctorName;
  final String specialty;
  final String date;
  final int duration;
  final String status;
  final String? reason;
  final String? notesPatient;

  // Computed properties
  DateTime get dateTime => DateTime.parse(date);

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.duration,
    required this.status,
    this.reason,
    this.notesPatient,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorId: json['doctor'],
      doctorName: json['doctor_name'] ?? 'Inconnu',
      specialty: json['specialty'] ?? 'Général',
      date: json['date'],
      duration: json['duration'] ?? 30,
      status: json['status'],
      reason: json['reason'],
      notesPatient: json['notes_patient'],
    );
  }
}
