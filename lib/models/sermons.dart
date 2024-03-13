import 'package:cloud_firestore/cloud_firestore.dart';

class Sermon {
  final String id;
  final String by;
  final String title;
  final String category;
  final String videoLink;
  final String audioLink;
  final String imageUrl;
  final String serviceType;
  final bool isDownloaded;
  final List<dynamic> sermonText;
  final String scripturalReference;
  final Timestamp timestamp;

  const Sermon({
    required this.id,
    required this.by,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.videoLink,
    required this.audioLink,
    required this.sermonText,
    required this.serviceType,
    required this.isDownloaded,
    required this.timestamp,
    required this.scripturalReference,
  });

  factory Sermon.fromJson({required Map<String, dynamic> json}) {
    return Sermon(
      id: json['id'] as String,
      by: json['by'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      videoLink: json['videoLink'] as String,
      audioLink: json['audioLink'] as String,
      sermonText: json['sermonText'] as List<dynamic>,
      serviceType: json['serviceType'] as String,
      isDownloaded: json['isDownloaded'] as bool,
      timestamp: json['timestamp'] as Timestamp,
      scripturalReference: json['reference'] as String,
    );
  }

  factory Sermon.nullSermon() {
    return Sermon(
      id: '',
      by: '',
      imageUrl: '',
      title: '',
      category: '',
      videoLink: '',
      audioLink: '',
      sermonText: [],
      serviceType: '',
      isDownloaded: false,
      timestamp: Timestamp.now(),
      scripturalReference: '',
    );
  }

  Map<String, dynamic> toJSon() {
    return {
      'id': id,
      'by': by,
      'imageUrl': imageUrl,
      'title': title,
      'categoryl': category,
      'videoLink': videoLink,
      'audioLink': audioLink,
      'sermonText': sermonText,
      'serviceType': serviceType,
      'isDownloaded': isDownloaded,
      'timestamp': timestamp,
      'reference': scripturalReference,
    };
  }
}
