import 'package:cloud_firestore/cloud_firestore.dart';

import 'category.dart';

class MyOrder {
  String? orderId ;
  DocumentReference userId;
  String title;
  bool urgent ;
  int status; // MyOrder status (e.g., 0: pending, 1: active, 2: completed)
  String phonenb;
  String adress;
  String description;
  List<String>? images ;
  String subcategory;
  DateTime date;
  String category;

  MyOrder({
    this.orderId,
    required this.userId,
    required this.title,
    required this.date,
    this.urgent = false,
    this.images,
    this.status = 0,
    this.phonenb = '',
    this.adress = '',
    this.description = '',
    this.subcategory = '',
    required this.category ,
  });

  factory MyOrder.fromMap(Map<String, dynamic> responseData,orderId) {
    final images = responseData['images'] as List<dynamic>?;
    final userIdRef = FirebaseFirestore.instance.collection('users').doc(responseData['userId']);
    DateTime? retrievedDate;
    if (responseData['date'] != null) {
      try {
        retrievedDate = responseData['date'] is Timestamp
            ? (responseData['date'] as Timestamp).toDate()
            : DateTime.parse(responseData['date'] as String);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    return MyOrder(
      orderId: orderId ?? '',
      userId: userIdRef,
      title: responseData['title'] ?? '',
      status: responseData['status'] ?? 0,
      phonenb: responseData['phonenb'] ?? '',
      urgent: responseData['urgent'],
      adress: responseData['adress'] ?? '',
      images: images?.map((image) => image as String).toList() ?? [],
      date: retrievedDate ?? DateTime.now(),
      description: responseData['description'] ?? '',
      subcategory: responseData['subcategory'] ?? '',
      category: responseData['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['phonenb'] = this.phonenb;
    data['images'] = this.images ;
    data['adress'] = this.adress;
    data['urgent'] = this.urgent ;
    data['date'] = this.date;
    data['description'] = this.description;
    data['subcategory'] = this.subcategory;
    data['category'] = this.category;

    return data;
  }
}