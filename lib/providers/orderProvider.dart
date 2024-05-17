import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenhousemaintenance/models/User.dart';
import 'package:greenhousemaintenance/utils/Cards.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../generated/l10n.dart';
import '../models/order.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

import '../screens/home_screen.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  List<MyOrder> orders = [];
  List<MyOrder> allorders = [];
  List<MyUser> clients = [];
  bool isLoadibg = false;

  void openWhatsAppChat(String Message, String phonenb) async {
    final url =
        'whatsapp://send?phone=+$phonenb&text=${Uri.encodeComponent(Message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle scenario where WhatsApp is not installed
      print('WhatsApp not installed');
    }
  }

  setLoding() {
    isLoadibg = true;
    notifyListeners();
  }
//******************************


  // final client = Client()-
  //     .setEndpoint('${AppwriteConstants.endPoint}') // Replace with your Appwrite endpoint
  //     .setProject('${AppwriteConstants.projectId}'); // Replace with your project ID
  final supabase = Supabase.instance.client;


  Future<List<String>> uploadImagesSuppabase(List<File> images) async {
    try {
      final List<String> imageUrls = [];
      for (final image in images) {
        final imagepath = '${path.basename(image.path)}_${UniqueKey}' ;
        final  mypath = await supabase.storage.from('orders').upload(
          'public/${imagepath}',
          image,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
        final publicUrl = await supabase.storage.from('orders').getPublicUrl("public/${imagepath}");
        imageUrls.add(publicUrl);
      }
      return imageUrls;
    } catch (e, stackTrace) {
      throw Exception(e.toString());
    }
  }
  //************************************
  // /// Uploads images to Firebase Storage and returns the download URLs
  // Future<List<String>> uploadStorageImages(List<File> images) async {
  //   try {
  //     final List<String> imageUrls = [];
  //     for (final image in images) {
  //       final String fileName = path.basename(image.path); // Extract filename
  //       Reference ref =
  //           FirebaseStorage.instance.ref().child('orders/$fileName');
  //       // UploadTask task = ref.putFile(image);
  //       // TaskSnapshot snapshot = await task;
  //       // String downloadUrl = await snapshot.ref.getDownloadURL();
  //       Uint8List bytes = image.readAsBytesSync(); //THIS LINE
  //       var snapshot = await ref.putData(bytes); //THIS LINE
  //       final uri = await snapshot.ref.getDownloadURL();
  //       imageUrls.add(uri);
  //     }
  //     return imageUrls;
  //   } on FirebaseException catch (e, stackTrace) {
  //     throw Exception(e.message ?? 'Some unexpected error occurred');
  //   } catch (e, stackTrace) {
  //     throw Exception(e.toString());
  //   }
  // }

  // Future<List<String>> uploadImages(List<String> imagePaths) async {
  //   final storageRef = FirebaseStorage.instance.ref();
  //   final List<String> uploadedImageUrls = [];
  //
  //   for (String imagePath in imagePaths) {
  //     final String fileName = path.basename(imagePath); // Extract filename
  //     final imageRef = storageRef.child('orders/$fileName');
  //     try {
  //       print('start upload image ${DateTime.now()}');
  //       UploadTask uploadTask = imageRef.putFile(File(imagePath));
  //       TaskSnapshot tasksnapshot = await uploadTask;
  //       print('uploadd image ${DateTime.now()}');
  //       String url = await tasksnapshot.ref.getDownloadURL();
  //       print('getUrl image $url ***** ${DateTime.now()}');
  //       uploadedImageUrls.add(url);
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  //
  //   return uploadedImageUrls;
  // }

  Future<void> insertOrder(BuildContext context, MyOrder order,
      List<File> selectedImages) async {
    try {
      final ordersRef = firebaseFirestore.collection('orders');
      final uploadedImageUrls = await uploadImagesSuppabase(selectedImages);
      order.images = uploadedImageUrls;

      final docRef = await ordersRef.add(order.toJson());
      print('Order added with ID: ${docRef.id}');
      isLoadibg = false;
      notifyListeners();
      Cards()
          .showSnackBar(context, "${S.of(context).Order_created_successfully}", isError: false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      isLoadibg = false;
      notifyListeners();
      Cards().showSnackBar(context, "${S.of(context).Oops_Something_Went_Wrong}", isError: true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));

      print(e); // Log the error for debugging
    }
  }

  Future<List<MyOrder>> getOrdersByUser() async {
    orders.clear();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (userId != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .get();

        for (var doc in querySnapshot.docs) {
          orders.add(MyOrder.fromMap(
              doc.data(), doc.id)); // Assuming you have an Order class
        }
        notifyListeners();
        return orders;
      } on FirebaseException catch (e) {
        print('Error getting orders: $e');
        return []; // Return empty list on error
      }
    } else {
      print('User ID not found');
      return []; // Return empty list if no user ID
    }
  }

  Future<List<MyOrder>> getOrders() async {
    allorders.clear();
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      for (var doc in querySnapshot.docs) {
        allorders.add(MyOrder.fromMap(
            doc.data(), doc.id)); // Assuming you have an Order class
      }
      notifyListeners();
      print(
          '*********************************** ${allorders.length} *****************************');
      return allorders;
    } on FirebaseException catch (e) {
      print('Error getting orders: $e');
      return []; // Return empty list on error
    }
  }

  //***************************** clients *****************************************
  Future<List<MyUser>> getClients() async {
    clients.clear();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (userId != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'user')
            .get();

        for (var doc in querySnapshot.docs) {
          clients.add(
              MyUser.fromMap(doc.data())); // Assuming you have an Order class
        }
        notifyListeners();
        return clients;
      } on FirebaseException catch (e) {
        print('Error getting orders: $e');
        return []; // Return empty list on error
      }
    } else {
      print('User ID not found');
      return []; // Return empty list if no user ID
    }
  }

  //************************* get Home ***************************************
  getAdminHome() async {
    getOrders();
    getClients();
  }

//********************** update status  **********************************
  updateOrder(BuildContext context, int status, orderId) async {
    isLoadibg = true;
    notifyListeners();
    if (status != -1) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc('${orderId}')
            .update({'status': status});
        isLoadibg = false;
        notifyListeners();
        Cards()
            .showSnackBar(context, "Order updated Succesfully", isError: false);
      } on FirebaseException catch (e) {
        isLoadibg = false;
        notifyListeners();
        Cards().showSnackBar(context, "Error updating order", isError: true);
        print('Error getting orders: $e');
      }
    } else {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc('${orderId}')
            .delete();
        isLoadibg = false;
        notifyListeners();
        Cards()
            .showSnackBar(context, "Order deleted Succesfully", isError: false);
      } on FirebaseException catch (e) {
        isLoadibg = false;
        notifyListeners();
        Cards().showSnackBar(context, "Error deleting order", isError: true);
        print('Error getting orders: $e');
      }
    }
  }
}
