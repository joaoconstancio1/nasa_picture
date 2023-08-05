import '../../domain/entities/nasa_picture_entity.dart';

class NasaPictureDto implements NasaPictureEntity {
  @override
  String? date;
  @override
  String? explanation;
  @override
  String? hdurl;
  @override
  String? mediaType;
  @override
  String? serviceVersion;
  @override
  String? title;
  @override
  String? url;

  NasaPictureDto(
      {this.date,
      this.explanation,
      this.hdurl,
      this.mediaType,
      this.serviceVersion,
      this.title,
      this.url});

  NasaPictureDto.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    explanation = json['explanation'];
    hdurl = json['hdurl'];
    mediaType = json['media_type'];
    serviceVersion = json['service_version'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['explanation'] = explanation;
    data['hdurl'] = hdurl;
    data['media_type'] = mediaType;
    data['service_version'] = serviceVersion;
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}
