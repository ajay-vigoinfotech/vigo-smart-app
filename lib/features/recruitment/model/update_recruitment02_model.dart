class UpdateRecruitment02Model{
  String? userId;
  String? currentAddress;
  String? CPin;
  String? CState;
  String? CCity;
  String? CPoliceStation;
  String? CPostOffice;
  String? PermanentAddress;
  String? PPIN;
  String? PState;
  String? Pcity;
  String? PPoliceStation;
  String? PPostOffice;
  String? bankId;
  String? bank_name;
  String? accountHolderName;
  String? account_no;
  String? IFSC_code;
  String? bankProofImage;
  String? responsible_email1;
  String? responsible_person1;
  String? responsible_add1;
  String? responsible_Reference1;

  UpdateRecruitment02Model({
    required this.userId,
    required this.currentAddress,
    required this.CPin,
    required this.CState,
    required this.CCity,
    required this.CPoliceStation,
    required this.CPostOffice,
    required this.PermanentAddress,
    required this.PPIN,
    required this.PState,
    required this.Pcity,
    required this.PPoliceStation,
    required this.PPostOffice,
    required this.bankId,
    required this.bank_name,
    required this.accountHolderName,
    required this.account_no,
    required this.IFSC_code,
    required this.bankProofImage,
    required this.responsible_email1,
    required this.responsible_person1,
    required this.responsible_add1,
    required this.responsible_Reference1,
});

  factory UpdateRecruitment02Model.fromJson(Map<String, dynamic> json) {
    return UpdateRecruitment02Model(
        userId: json['userId']?.toString() ?? '',
        currentAddress: json['currentAddress']?.toString() ?? '',
        CPin: json['CPin']?.toString() ?? '',
        CState: json['CState']?.toString() ?? '',
        CCity: json['CCity']?.toString() ?? '',
        CPoliceStation: json['CPoliceStation']?.toString() ?? '',
        CPostOffice: json['CPostOffice']?.toString() ?? '',
        PermanentAddress: json['PermanentAddress']?.toString() ?? '',
        PPIN: json['PPIN']?.toString() ?? '',
        PState: json['PState']?.toString() ?? '',
        Pcity: json['Pcity']?.toString() ?? '',
        PPoliceStation: json['PPoliceStation']?.toString() ?? '',
        PPostOffice: json['PPostOffice']?.toString() ?? '',
        bankId: json['bankId']?.toString() ?? '',
        bank_name: json['bank_name']?.toString() ?? '',
        accountHolderName: json['accountHolderName']?.toString() ?? '',
        account_no: json['account_no']?.toString() ?? '',
        IFSC_code: json['IFSC_code']?.toString() ?? '',
        bankProofImage: json['bankProofImage']?.toString() ?? '',
        responsible_email1: json['responsible_email1']?.toString() ?? '',
        responsible_person1: json['responsible_person1']?.toString() ?? '',
        responsible_add1: json['responsible_add1']?.toString() ?? '',
        responsible_Reference1: json['responsible_Reference1']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId' : userId,
      'currentAddress' : currentAddress,
      'CPin' : CPin,
      'CState' : CState,
      'CCity' : CCity,
      'CPoliceStation' : CPoliceStation,
      'CPostOffice' : CPostOffice,
      'PermanentAddress' : PermanentAddress,
      'PPIN' : PPIN,
      'PState' : PState,
      'Pcity' : Pcity,
      'PPoliceStation' : PPoliceStation,
      'PPostOffice' : PPostOffice,
      'bankId' : bankId,
      'bank_name' : bank_name,
      'accountHolderName' : accountHolderName,
      'account_no' : account_no,
      'IFSC_code' : IFSC_code,
      'bankProofImage' : bankProofImage,
      'responsible_email1' : responsible_email1,
      'responsible_person1' : responsible_person1,
      'responsible_add1' : responsible_add1,
      'responsible_Reference1' : responsible_Reference1,
    };
  }
}