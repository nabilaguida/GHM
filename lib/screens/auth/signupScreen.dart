import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/providers/AuthProvider.dart';
import 'package:greenhousemaintenance/screens/home_screen.dart';
import 'package:greenhousemaintenance/utils/styles.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../adminSide/adminHomeScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController fullnamecntrl = TextEditingController();
  TextEditingController adresscntrlr = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Center(
              child: Container(
                height: height * 0.12,
                width: width * 0.6,
                child: Center(
                  child: Image.asset(
                    "assets/logo white-8.png",
                    color: Palette.primary,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
                width: width * 0.85,
                child: Center(
                    child: Text("${S.of(context).last_step}",
                        style: MYText().mytextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Palette.primary)))),
            Container(
                width: width * 0.85,
                child: Center(
                    child: Text(
                        textAlign: TextAlign.center,
                        "${S.of(context).complete_signup}",
                        style: MYText().mytextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)))),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                width: width * 0.8,
                child: Text(
                  '${S.of(context).enter_full_name}',
                  style: MYText()
                      .mytextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.start,
                )),
            Container(
              width: width * 0.85,
              height: height * 0.07,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.green.shade600.withOpacity(0.05),
                        spreadRadius: 8,
                        blurRadius: 12)
                  ]),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: TextField(
                    controller: fullnamecntrl,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: MYText().mytextStyle(color: Colors.black38),
                        hintText: "${S.of(context).full_name}"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                width: width * 0.8,
                child: Text(
                  '${S.of(context).enter_location}',
                  style: MYText().mytextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.start,
                )),
            Container(
              width: width * 0.85,
              height: height * 0.07,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff2a824d).withOpacity(0.1),
                      spreadRadius: 6,
                      offset: Offset(0, 7.5),
                      blurRadius: 11.25)
                ],
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: TextField(
                    controller: adresscntrlr,
                    decoration: InputDecoration(
                        hintStyle: MYText().mytextStyle(color: Colors.black38),
                        border: InputBorder.none, hintText: "${S.of(context).address}"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Visibility(
              visible: !isLoading,
              child: GestureDetector(
                onTap: () async {
                  if (fullnamecntrl.text.isNotEmpty &&
                      adresscntrlr.text.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    print(
                        '****************isLoading ** $isLoading ******************');
                    String userrole = await context
                        .read<Auth_Provider>()
                        .signup(fullnamecntrl.text, adresscntrlr.text);
                    if (userrole == "user") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }
                    if (userrole == 'admin') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminHomeScreen()));
                    }
                    setState(() {
                      isLoading = false;
                    });
                    print(
                        '****************isLoading ** $isLoading ******************');
                  }
                },
                child: Container(
                  height: height * 0.08,
                  width: width * 0.9,
                  child: Center(
                    child: Text(
                      "${S.of(context).done}",
                      style: MYText().mytextStyle(
                          fontSize: 18, color: Colors.white
                      )
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Palette.primary),
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Center(
                  child: CircularProgressIndicator(
                color: Palette.primary,
              )),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${S.of(context).having_trouble} ',
                    style: MYText().mytextStyle(
                        color: Colors.black, fontSize: 14
                    )
                  ),
                  TextSpan(
                    text: '${S.of(context).help}',
                    style: MYText().mytextStyle(
                        color: Palette.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline
                    )
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
