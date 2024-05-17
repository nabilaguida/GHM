
class MyUser {
  String uid;
  String fullName;
  String address;
  String phoneNumber;
  String role ;
  // String email;



  MyUser({
    required this.uid,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    required this.role
  });

  factory MyUser.fromMap(Map<String, dynamic> responseData) {
    return MyUser(
      uid: responseData['uid'] ?? '',
      fullName: responseData['fullName'] ?? '',
      address: responseData['address'] ?? '',
      phoneNumber: responseData['phoneNumber'] ?? '',
      role: responseData['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['phoneNumber'] =  this.phoneNumber;
    data['role'] = this.role ;
    return data;
  }

}
