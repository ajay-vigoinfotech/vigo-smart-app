class UpdateRecruitment04Model {
  String? userId;
  String? Height;
  String? Weight;
  String? physical_waist;
  String? physical_chest;
  String? physical_shoe;
  String? physical_blood;
  String? DocumentsList;

  UpdateRecruitment04Model({
    required this.userId,
    required this.Height,
    required this.Weight,
    required this.physical_waist,
    required this.physical_chest,
    required this.physical_shoe,
    required this.physical_blood,
    required this.DocumentsList,
  });

  factory UpdateRecruitment04Model.fromJson(Map<String, dynamic> json) {
    return UpdateRecruitment04Model(
      userId: json['userId']?.toString() ?? '',
      Height: json['Height']?.toString() ?? '',
      Weight: json['Weight']?.toString() ?? '',
      physical_waist: json['physical_waist']?.toString() ?? '',
      physical_chest: json['physical_chest']?.toString() ?? '',
      physical_shoe: json['physical_shoe']?.toString() ?? '',
      physical_blood: json['physical_blood']?.toString() ?? '',
      DocumentsList: json['DocumentsList']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'Height': Height,
      'Weight': Weight,
      'physical_waist': physical_waist,
      'physical_chest': physical_chest,
      'physical_shoe': physical_shoe,
      'physical_blood': physical_blood,
      'DocumentsList': DocumentsList,
    };
  }
}
