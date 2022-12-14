class Video {
  String url;
  String description;
  String title;
  int plays;
  int? rating;
  String thumbnail;
  String? author;

  Video({
    required this.url,
    required this.thumbnail,
    required this.title,
    this.author,
    required this.description,
    required this.plays,
    this.rating,
  });
}
