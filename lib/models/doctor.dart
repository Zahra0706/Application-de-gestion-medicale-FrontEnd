class Doctor {
  final int id;
  final String firstName;
  final String lastName;
  final String speciality;
  final double consultationFee;
  final bool isAvailable;
  final bool isActive;
  final String? bio;
  final String phone;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.speciality,
    required this.consultationFee,
    required this.isAvailable,
    required this.isActive,
    required this.phone,
    this.bio,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      firstName: json['user']['first_name'] ?? '',
      lastName: json['user']['last_name'] ?? '',
      speciality: json['speciality_name'] ?? 'Général',
      consultationFee: json['consultation_fee'] != null
          ? double.tryParse(json['consultation_fee'].toString()) ?? 0.0
          : 0.0,
      bio: json['bio'],
      isAvailable: json['is_available'] ?? false,
      isActive: json['user']['is_active'] ?? false,
      phone: json['user']['phone'] ?? 'Non disponible',
    );
  }

  String get fullName => "Dr. $firstName $lastName";
}
