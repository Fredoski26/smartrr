class Organization {
  String id;
  String name;
  String type;
  String telephone;
  String orgEmail;
  String password;
  String language;
  String? ward;
  String? site;
  String? lga;
  String? startDate;
  String? endDate;
  List<dynamic> servicesAvailable;
  String? startTime;
  String? closeTime;
  String? focalName;
  String? focalEmail;
  String? focalPhone;
  String? focalDesignation;
  String? how;
  String? criteria;
  String? comments;
  String locationId;
  int status;
  String location;

  Organization({
    required this.id,
    required this.name,
    required this.type,
    required this.telephone,
    required this.orgEmail,
    required this.password,
    required this.language,
    this.ward,
    this.site,
    this.lga,
    this.startDate,
    this.endDate,
    required this.servicesAvailable,
    this.startTime,
    this.closeTime,
    this.focalName,
    this.focalEmail,
    this.focalPhone,
    this.focalDesignation,
    this.how,
    this.criteria,
    this.comments,
    required this.locationId,
    required this.status,
    required this.location,
  });
}
