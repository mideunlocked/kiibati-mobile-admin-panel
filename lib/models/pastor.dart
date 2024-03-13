class Pastor {
  final String id;
  final String imageUrl;
  final String fullName;
  final String position;
  final String title;
  final List<dynamic> sermons;

  const Pastor({
    required this.id,
    required this.title,
    required this.position,
    required this.fullName,
    required this.imageUrl,
    required this.sermons,
  });

  factory Pastor.fromJson({required Map<String, dynamic> json}) {
    return Pastor(
      id: json['id'] as String,
      title: json['title'] as String,
      position: json['position'] as String,
      fullName: json['fullName'] as String,
      imageUrl: json['imageUrl'] as String,
      sermons: json['sermons'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'sermons': sermons,
    };
  }

  factory Pastor.pastor() {
    return const Pastor(
      id: '',
      title: '',
      position: '',
      fullName: '',
      imageUrl: '',
      sermons: [],
    );
  }

  String pastorAddress() {
    String addressedAs = "$title $fullName";

    return addressedAs;
  }
}
