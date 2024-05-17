import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/providers/AuthProvider.dart';
import 'package:greenhousemaintenance/utils/styles.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNb;
  const OtpScreen(
      {super.key, required this.verificationId, required this.phoneNb});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    context.read<Auth_Provider>().pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  String pin = "";
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
              height: height * 0.1,
            ),
            Container(
                width: width * 0.85,
                child: Center(
                    child: Text(
                  "${S.of(context).NextStep}",
                  style: MYText().mytextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Palette.primary
                  )
                ))),
            Container(
                width: width * 0.85,
                child: Center(
                    child: Text(
                      textDirection: TextDirection.ltr,
                  "${S.of(context).EnterOTPSentTo}\n ${widget.phoneNb}",
                  textAlign: TextAlign.center,
                  style: MYText().mytextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400
                  )
                ))),
            SizedBox(
              height: height * 0.08,
            ),
            Container(
              width: width * 0.85,
              height: height * 0.07,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  onChanged: (value) {
                    setState(() {
                      pin = value;
                    });
                    print(pin.length);
                  },
                  length: 6,
                  controller: context.read<Auth_Provider>().pinController,
                  focusNode: focusNode,
                  defaultPinTheme: PinTheme(
                      decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.green.shade600.withOpacity(0.05),
                        spreadRadius: 8,
                        blurRadius: 12)
                  ])),
                  androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                  listenForMultipleSmsOnAndroid: true,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${S.of(context).HavenTReceivedCode}\n",
                    style: MYText().mytextStyle(
                        color: Colors.black, fontSize: 14
                    )
                  ),
                  TextSpan(
                    text: '${S.of(context).ResendCode}',
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
              height: height * 0.18,
            ),
            Visibility(
              visible: !isLoading,
              child: GestureDetector(
                onTap: ()async {
                  if (pin.length == 6) {
                    setState(() {
                      isLoading = true;
                    });
                    print(
                        '****************isLoading ** $isLoading ******************');
                    await context
                        .read<Auth_Provider>()
                        .verifyotp(context, widget.verificationId, pin);
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
                  child:  Center(
                    child: Text(
                      "${S.of(context).Verify}",
                      style: MYText().mytextStyle(
                          fontSize: 18, color: Colors.white
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: pin.length == 6 ? Palette.primary : Colors.grey.shade400),
                ),
              ),
            ),
            Visibility(
              visible: isLoading
              ,child: Center(
                child: CircularProgressIndicator(color: Palette.primary,)
            ), ),
            SizedBox(
              height: height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
