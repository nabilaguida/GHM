import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenhousemaintenance/models/category.dart' as cat;
import 'package:greenhousemaintenance/utils/Cards.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';


class CategoriesProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  List<cat.Category> categories = [];
  List<String> subcategories = [];
  List<String> subcategoriesAr = [];
  String selectedImagePath = '';
  bool isLoading = false ;
  bool visible = false;


  setLoading(){
    isLoading = true;
    notifyListeners();
  }
  setVisible(bool value){
    visible = value ;
    notifyListeners();
  }

  addSubCategory(value) {
    if (!subcategories.contains(value)) {
      subcategories.add(value);
      notifyListeners();
    }
  }
  addSubCategoryAr(value) {
    if (!subcategories.contains(value)) {
      subcategoriesAr.add(value);
      notifyListeners();
    }
  }


  removeSubCategory(value) {
    if (subcategories.contains(value)) {
      subcategories.remove(value);
      notifyListeners();
    }
  }
  removeSubCategoryAr(String value) {
    if (subcategoriesAr.contains(value)) {
      subcategoriesAr.remove(value);
      notifyListeners();
    }
  }

  resetVars(){
    subcategories.clear();
    notifyListeners();
  }
  final supabase = Supabase.instance.client;

  Future<String> uploadImagesSupabaseCategory(String image) async {
    try {
      final  mypath = await supabase.storage.from('categories').upload(
        'public/${path.basename(image)}',
        File(image),
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      final publicUrlPath = await mypath.replaceAll('/categories', '');

      print('*********================== ${publicUrlPath} ==============');
      final publicUrl = await supabase.storage.from('categories').getPublicUrl("public/${path.basename(image)}");
      print('************** $publicUrl ******************');
      return publicUrl;
    } catch (e, stackTrace) {
      isLoading = false ;
      notifyListeners();
      throw Exception(e.toString());
    }
  }

  // Future<String> uploadImagesAppriteCategory(String image) async {
  //   client
  //       .setEndpoint('https://cloud.appwrite.io/v1')
  //       .setProject('663bc6cf000e036de2e5')
  //       .setSelfSigned(status: true);
  //   mystorage = await Storage(client);
  //   try {
  //       final response = await mystorage.createFile(
  //         bucketId: AppwriteConstants.imagesBucketId,
  //         fileId: ID.unique(),
  //         file: InputFile.fromPath(path: image),
  //       );
  //       AppwriteConstants.imagerUrl(response.$id);
  //
  //     return AppwriteConstants.imagerUrl(response.$id);
  //   } on AppwriteException catch (e, stackTrace) {
  //     isLoading = false ;
  //     notifyListeners();
  //     throw Exception(e.message ?? 'Some unexpected error occurred');
  //   } catch (e, stackTrace) {
  //     isLoading = false ;
  //     notifyListeners();
  //     throw Exception(e.toString());
  //   }
  // }

  // Future<String> uploadImage(String imagePath) async {
  //   final storageRef = storage.ref();
  //   final String fileName = path.basename(imagePath); // Extract filename
  //   final imageRef = storageRef.child('categories/$fileName');
  //   final uploadTask = imageRef.putFile(File(imagePath));
  //   final snapshot = await uploadTask.whenComplete(() => null);
  //   final url = await snapshot.ref.getDownloadURL();
  //   return url;
  // }


  Future<void> InsertCategory(BuildContext context, cat.Category category,
      String selectedImagePath) async {
    try {
      final ordersRef = firebaseFirestore.collection('categories');
      final uploadedImageUrl = await uploadImagesSupabaseCategory(selectedImagePath);
      category.image = uploadedImageUrl;
      final docRef = await ordersRef.add(category.toJson());
      print('Category added with ID: ${docRef.id}');
      Cards().showSnackBar(context, 'category created Successfully',
          isError: false);
      selectedImagePath = '';
      subcategories.clear();
      isLoading = false ;
      notifyListeners();
    } on FirebaseException catch (e) {
      selectedImagePath = '';
      subcategories.clear();
      isLoading = false ;
      notifyListeners();
      Cards().showSnackBar(context, 'Failed to create category', isError: true);
    }
  }
  deleteCategory(BuildContext context, String? categoryId)async {
    try {
      await firebaseFirestore.collection('categories').doc(categoryId).delete();
      Navigator.pop(context);
      Cards().showSnackBar(context, 'category deleted Successfully',
          isError: false);
      selectedImagePath = '';
      subcategories.clear();
      isLoading = false ;
      notifyListeners();
    } on FirebaseException catch (e) {
      selectedImagePath = '';
      subcategories.clear();
      notifyListeners();
      Cards().showSnackBar(context, 'Failed to delete category', isError: true);
    }
  }

  UpdateCategory(BuildContext context,catId)async {
    try {
      final ordersRef = firebaseFirestore.collection('categories').doc(catId);
      final docRef = await ordersRef.update(
        {
          'subcategories' : subcategories,
          'visible': visible
        }
      );
      Navigator.pop(context);
      Cards().showSnackBar(context, 'category updated Successfully',
          isError: false);
      selectedImagePath = '';
      subcategories.clear();
      isLoading = false ;
      notifyListeners();
    } on FirebaseException catch (e) {
      selectedImagePath = '';
      subcategories.clear();
      notifyListeners();
      Cards().showSnackBar(context, 'Failed to update category', isError: true);
    }
  }

  Future<List<cat.Category>> getCategories() async {
    categories.clear();
    List<cat.Category> categoriesList = [] ;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (userId != null) {
      try {
        final querySnapshot =
            await FirebaseFirestore.instance.collection('categories').get();

        for (var doc in querySnapshot.docs) {
          categoriesList.add(cat.Category.fromMap(
              doc.data(), doc.id)); // Assuming you have an Order class
        }
        // Sort the list based on visibility (descending) and weight (descending)
        categoriesList.sort((a, b) {
          if (a.visible != b.visible) {
            return a.visible ? -1 : 1; // Visible categories come first
          } else {
            return b.weight.compareTo(a.weight); // Higher weight comes first
          }
        });
        categories.addAll(categoriesList);
        notifyListeners();
        return categories;
      } on FirebaseException catch (e) {
        print('Error getting orders: $e');
        return []; // Return empty list on error
      }
    } else {
      print('User ID not found');
      return []; // Return empty list if no user ID
    }
  }

  setImage(String selectedImage) {
    selectedImagePath = selectedImage;
    notifyListeners();
  }

  setSubCategoriesForEdit(List<String> subs) {
    subcategories = subs ;
    selectedImagePath = '';
    notifyListeners();
  }





}
