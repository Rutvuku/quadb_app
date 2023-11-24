

class TvShowModel {
  final double score;
  final Show show;

  TvShowModel({required this.score, required this.show});

  factory TvShowModel.fromJson(Map<String, dynamic> json) {
    return TvShowModel(
      score: json['score'],
      show: Show.fromJson(json['show']),
    );
  }
}

class Show {
  final int id;
  final String name;
  final String summary;
  final Map<String, dynamic> rating;
  final Map<String, dynamic> image;

  Show({required this.id, required this.name, required this.summary, required this.image, required this.rating});

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      image: json['image'],
      rating: json['rating'],
    );
  }
}
