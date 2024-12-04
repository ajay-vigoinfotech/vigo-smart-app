class SiteReportingImageAssetModel {
  String? assetImage;
  String? userImage;

  SiteReportingImageAssetModel({
    required this.assetImage,
    required this.userImage,
  });

  factory SiteReportingImageAssetModel.fromJson(Map<String, dynamic> json) {
    return SiteReportingImageAssetModel(
      assetImage: json['assetImage']?.toString() ?? '',
      userImage: json['userImage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "assetImage": assetImage,
      "userImage": userImage,
    };
  }
}

class SiteReportingImageAssetResponse {
  List<SiteReportingImageAssetModel> table;

  SiteReportingImageAssetResponse({
    required this.table,
  });

  factory SiteReportingImageAssetResponse.fromJson(Map<String, dynamic> json) {
    return SiteReportingImageAssetResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => SiteReportingImageAssetModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
    };
  }
}
