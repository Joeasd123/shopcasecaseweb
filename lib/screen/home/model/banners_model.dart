import 'package:equatable/equatable.dart';

class BannersModel extends Equatable {
  const BannersModel({
    this.id,
    this.bannersurl,
    this.title,
    this.description,
  });
  final int? id;
  final List<String>? bannersurl;
  final String? title;
  final String? description;

  factory BannersModel.fromJson(Map<String, dynamic> json) {
    return BannersModel(
      id: json["id"],
      bannersurl: json['bannersurl'] != null
          ? List<String>.from(json['bannersurl'])
          : null,
      title: json["title"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "bannersurl": bannersurl,
        "title": title,
        "description": description,
      };

  @override
  String toString() {
    return "$id, $bannersurl,$title,$description, ";
  }

  @override
  List<Object?> get props => [
        id,
        bannersurl,
        title,
        description,
      ];
}
