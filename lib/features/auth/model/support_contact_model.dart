class SupportContact {
  final String ivr;
  final String whatsapp;

  SupportContact({required this.ivr, required this.whatsapp});

  // Factory constructor to create a SupportContact from a JSON response
  factory SupportContact.fromJson(Map<String, dynamic> json) {
    return SupportContact(
      ivr: json['ivr'] ?? '', // Using empty strings for null fields
      whatsapp: json['whatsapp'] ?? '',
    );
  }
}
