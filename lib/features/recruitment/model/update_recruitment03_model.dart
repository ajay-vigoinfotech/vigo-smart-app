class UpdateRecruitment03Model {
  String? userId;
  String? dateOfJoin;
  String? UAN;
  String? ESIC;
  String? PF;
  String? nomineename;
  String? nomineeage;
  String? nomineeRelation;
  String? company_name;
  String? Designation;
  String? experience;
  String? company_address;
  String? company_leavingDate;
  String? familyDetails;

  UpdateRecruitment03Model({
    required this.userId,
    required this.dateOfJoin,
    required this.UAN,
    required this.ESIC,
    required this.PF,
    required this.nomineename,
    required this.nomineeage,
    required this.nomineeRelation,
    required this.company_name,
    required this.Designation,
    required this.experience,
    required this.company_address,
    required this.company_leavingDate,
    required this.familyDetails,
  });

  factory UpdateRecruitment03Model.fromJson(Map<String, dynamic> json) {
    return UpdateRecruitment03Model(
      userId: json['userId']?.toString() ?? '',
      dateOfJoin: json['dateOfJoin']?.toString() ?? '',
      UAN: json['UAN']?.toString() ?? '',
      ESIC: json['ESIC']?.toString() ?? '',
      PF: json['PF']?.toString() ?? '',
      nomineename: json['nomineename']?.toString() ?? '',
      nomineeage: json['nomineeage']?.toString() ?? '',
      nomineeRelation: json['nomineeRelation']?.toString() ?? '',
      company_name: json['company_name']?.toString() ?? '',
      Designation: json['Designation']?.toString() ?? '',
      experience: json['experience']?.toString() ?? '',
      company_address: json['company_address']?.toString() ?? '',
      company_leavingDate: json['company_leavingDate']?.toString() ?? '',
      familyDetails: json['familyDetails']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dateOfJoin': dateOfJoin,
      'UAN': UAN,
      'ESIC': ESIC,
      'PF': PF,
      'nomineename': nomineename,
      'nomineeage': nomineeage,
      'nomineeRelation': nomineeRelation,
      'company_name': company_name,
      'Designation': Designation,
      'experience': experience,
      'company_address': company_address,
      'company_leavingDate': company_leavingDate,
      'familyDetails': familyDetails,
    };
  }
}
