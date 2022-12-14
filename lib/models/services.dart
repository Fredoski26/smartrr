class Services {
  String title;
  List<SubService> subTitles;

  Services(this.title, this.subTitles);
}

class SubService {
  String title;
  bool value;

  SubService({required this.title, required this.value});
}
