import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/screens/auth/phonelogin.dart';
import 'package:greenhousemaintenance/utils/styles.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:intl/intl.dart';
import '../../generated/l10n.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool arabicLocal() {
    return Intl.getCurrentLocale() == 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/backgroundfinal.jpg"),
                  fit: BoxFit.fill)),
        ),
        Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Container(
                height: height * 0.12,
                width: width * 0.6,
                child: Center(
                  child: Image.asset("assets/logo white-8.png"),
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Text('${S.of(context).hello}',
                  style: MYText().mytextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              Container(
                  width: width * 0.5,
                  child: Divider(
                    color: Colors.white.withOpacity(0.4),
                    thickness: 5,
                    height: height * 0.08,
                  )),
              Text('${S.of(context).welcome}',
                  style: MYText().mytextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white)),
              Text('${S.of(context).signup_message}',
                  style: MYText().mytextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      color: Colors.white70)),
              Spacer(
                flex: 2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PhoneLogin()));
                },
                child: Container(
                  height: height * 0.08,
                  width: width * 0.9,
                  child: Center(
                    child: Text("${S.of(context).get_started}",
                        style: MYText().mytextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: Palette.primary800)),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.white),
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
