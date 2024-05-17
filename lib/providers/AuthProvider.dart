import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenhousemaintenance/models/User.dart';
import 'package:greenhousemaintenance/screens/home_screen.dart';
import 'package:greenhousemaintenance/utils/Cards.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated/l10n.dart';
import '../screens/adminSide/adminHomeScreen.dart';
import '../screens/auth/otpScreen.dart';
import '../screens/auth/signupScreen.dart';

//**************************************************************************
enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut,
  ERROR
}

class Auth_Provider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String role = "user";
  bool isEdditing = false;
  final pinController = TextEditingController();


  setEdit() {
    isEdditing = !isEdditing;
    notifyListeners();
  }

  setrole(myrole) {
    role = myrole;
    notifyListeners();
  }

  setloading() {
    isLoading = true;
    notifyListeners();
  }

  String? userId;
  User? user;

  signInWithPhoneNumber(BuildContext context, String phoneNb) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNb,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
                pinController.setText(phoneAuthCredential.smsCode.toString());
                await firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            print('**********************************');
            print(error.message);
            print('***********************************');
            Cards().showSnackBar(context, 'Please enter a valid phone number',
                isError: true);
            isLoading = false;
            notifyListeners();
          },
          codeSent: (verificationId, forceResendingToken) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        verificationId: verificationId,
                        phoneNb: phoneNb,
                      ))),
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e.message}')));
    }
  }

  verifyotp(BuildContext context, String verificationId, String pin) async {
    try {
      isLoading = true;
      notifyListeners();
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: pin);
      user = (await firebaseAuth.signInWithCredential(creds)).user;
      if (user != null) {
        print('****************');
        print(user!.uid);
        userId = user!.uid;
        print('****************');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user!.uid);
        bool exists = await checkUserExists();
        isLoading = false;
        notifyListeners();
        if (exists) {
          DocumentSnapshot snapshot = await firebaseFirestore
              .collection("admins")
              .doc(user!.phoneNumber)
              .get();
          if (snapshot.exists) {
            await prefs.setString('role', 'admin');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdminHomeScreen()));
          } else {
            await prefs.setString('role', 'user');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignupScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      Cards().showSnackBar(context, '${S.of(context).Please_enter_a_valid_OTP}', isError: true);
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection("users").doc(userId).get();
    if (snapshot.exists) {
      print('user exists');
      return true;
    } else {
      print('user do not exist');
      return false;
    }
  }

  Future<String> signup(String fullname, String adress) async {
    final prefs = await SharedPreferences.getInstance();
    late String userrole;
    isLoading = true;
    notifyListeners();
    late MyUser myUser;
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection("admins")
        .doc(user!.phoneNumber)
        .get();
    if (snapshot.exists) {
      myUser = MyUser(
          uid: user!.uid,
          role: "admin",
          fullName: fullname,
          address: adress,
          phoneNumber: user!.phoneNumber ?? "");
      userrole = "admin";
      await prefs.setString('role', 'admin');
    } else {
      await prefs.setString('role', 'user');
      myUser = MyUser(
          uid: user!.uid,
          role: "user",
          fullName: fullname,
          address: adress,
          phoneNumber: user!.phoneNumber ?? "");
      userrole = "user";
    }
    try {
      await firebaseFirestore
          .collection("users")
          .doc(myUser.uid)
          .set(myUser.toJson());
      print('data Saved');
      await user!.updateDisplayName(fullname);
      isLoading = false;
      notifyListeners();
      return userrole;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }

  logout(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await firebaseAuth.signOut();
      userId = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', ''); // Clear stored UID
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e.message}')));
    }
  }

  Future<MyUser> getUser() async {
    try {
      final querysnapshot = await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      MyUser myUser = MyUser.fromMap(querysnapshot.data()!);
      return myUser;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  updateProfile(BuildContext context, String adress) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'address': adress});
    } on FirebaseException catch (e) {
      Cards().showSnackBar(context, "${S.of(context).Oops_Something_Went_Wrong}", isError: true);
    }
  }
}
