class Vehicle {
  String ownerName;
  String ownerMobileNo;
  String licensePlateNo;
  String role;
  String model;
  String color;
  String expires;
  String profileImage;
  bool isInCampus;

  Vehicle(
      {required this.ownerName,
      required this.ownerMobileNo,
      required this.licensePlateNo,
      required this.role,
      required this.model,
      required this.color,
      required this.expires,
      required this.profileImage,
      required this.isInCampus});

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName,
      'ownerMobileNo': ownerMobileNo,
      'licensePlateNo': licensePlateNo,
      'role': role,
      'model': model,
      'color': color,
      'expires': expires,
      'profileImage': profileImage,
      'isInCampus': isInCampus,
    };
  }

  factory Vehicle.fromMap(Map<dynamic, dynamic> data) {
    return Vehicle(
      ownerName: data["ownerName"],
      ownerMobileNo: data["ownerMobileNo"],
      licensePlateNo: data["licensePlateNo"],
      role: data["role"],
      model: data["model"],
      color: data["color"],
      expires: data["expires"],
      profileImage: data["profileImage"],
      isInCampus: data["isInCampus"],
    );
  }
}
