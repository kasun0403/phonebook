class PhoneModel {
  String id;
  String name;
  String phoneNumber;
  String? image;
  PhoneModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.image,
  });
  factory PhoneModel.fromJson(Map<String, dynamic> json) => PhoneModel(
        id: json['id'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'image': image ?? "",
    };
  }
}
