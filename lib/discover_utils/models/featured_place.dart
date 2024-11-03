
class TravelmateDB {
  String id;
  String name;
  String description;
  String image_url;

  TravelmateDB({
    required this.id,
    required this.name,
    required this.description,
    required this.image_url,});// Initialize to empty if null

  factory TravelmateDB.fromJson(Map<String, dynamic> json) {
  return TravelmateDB(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    image_url: json['image_url'],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': image_url,
    };
  }
}
