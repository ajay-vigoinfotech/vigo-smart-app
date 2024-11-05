class SupportContact {
  final String ivr;
  final String whatsapp;

  SupportContact({required this.ivr, required this.whatsapp});

  factory SupportContact.fromJson(Map<String, dynamic> json) {
    return SupportContact(
      ivr: json['ivr'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
    );
  }
}