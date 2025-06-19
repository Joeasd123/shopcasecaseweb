import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    this.id,
    this.name,
    this.image,
  });
  final String? id;
  final String? name;
  final String? image;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };

  @override
  String toString() {
    return "$id, $name,$image,";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image,
      ];
}
