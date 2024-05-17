import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhousemaintenance/models/User.dart';
import 'package:greenhousemaintenance/providers/AuthProvider.dart';
import 'package:greenhousemaintenance/providers/localProvider.dart';
import 'package:greenhousemaintenance/screens/auth/onboardingscreen.dart';
import 'package:greenhousemaintenance/utils/styles.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../../generated/l10n.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController adresscntrlr = TextEditingController();
  bool fetched = false;
  late MyUser myuser;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }
 late String _selectedLanguage ;

  getUser() async {
    setState(() {
      fetched = false;
    });
    myuser = await context.read<Auth_Provider>().getUser();
    setState(() {
      fetched = true;
    });
    _selectedLanguage = arabicLocal() ? 'Arabic':'English' ;
  }
  bool arabicLocal() {
    return intl.Intl.getCurrentLocale() == 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: fetched
            ? Scaffold(
                appBar: AppBar(
                  title: Text(
                    '${S.of(context).Settings}',
                    style: MYText().mytextStyle(fontWeight: FontWeight.w600),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back)),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          color: Palette.primary,
                        ))
                  ],
                ),
                body: Consumer<Auth_Provider>(builder: (context, auth, child) {
                  return ListView(
                    children: [
                      Center(
                        child: Container(
                          width: width * 0.9,
                          child: Row(
                            children: [
                              Text('${S.of(context).Profile}',
                                  style: MYText().mytextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  auth.setEdit();
                                  if (adresscntrlr.text.isNotEmpty) {
                                    await auth.updateProfile(
                                        context, adresscntrlr.text);
                                    await getUser();
                                    // setState(() {});
                                  }
                                },
                                child: Container(
                                  height: height * 0.045,
                                  width: width * 0.3,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(
                                          color: Palette.primary, width: 2)),
                                  child: Center(
                                    child: Text(
                                        auth.isEdditing
                                            ? '${S.of(context).Save_Changes}'
                                            : "${S.of(context).Edit_Profile}",
                                        style: MYText().mytextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          child: Text('${myuser.fullName[0]}',
                              style: MYText().mytextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.primary)),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Center(
                        child: Text(
                          '${myuser.fullName}',
                          style: MYText().mytextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          width: width * 0.85,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.green.shade600.withOpacity(0.05),
                                    spreadRadius: 8,
                                    blurRadius: 12)
                              ]),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${S.of(context).phone_Number}',
                                      style: MYText().mytextStyle(),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.phone,
                                      color: Palette.primary,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.008,
                                ),
                                Text('${myuser.phoneNumber}',
                                    textDirection: TextDirection.ltr,
                                    style: MYText().mytextStyle(
                                        color: Palette.primary,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          width: width * 0.85,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.green.shade600.withOpacity(0.05),
                                    spreadRadius: 8,
                                    blurRadius: 12)
                              ]),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${S.of(context).address}',
                                      style: MYText().mytextStyle(),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.pin_drop,
                                      color: Palette.primary,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.008,
                                ),
                                auth.isEdditing
                                    ? TextField(
                                        controller: adresscntrlr,
                                        decoration: InputDecoration(
                                            hintStyle: MYText().mytextStyle(
                                                color: Colors.black38),
                                            hintText: '${myuser.address}'),
                                      )
                                    : Text('${myuser.address}',
                                        style: MYText().mytextStyle(
                                            color: Palette.primary,
                                            fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Center(
                        child: Container(
                          width: width * 0.9,
                          child: Row(
                            children: [
                              Text('${S.of(context).Account_Settings}',
                                  style: MYText().mytextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Spacer(),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          width: width * 0.85,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.green.shade600.withOpacity(0.05),
                                    spreadRadius: 8,
                                    blurRadius: 12)
                              ]),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  '${S.of(context).Language}',
                                  style: MYText().mytextStyle(),
                                ),
                                Spacer(),
                                DropdownButton<String>(
                                  value: _selectedLanguage,
                                  items: languages,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedLanguage = value!;
                                    });
                                    context.read<LocalProvider>().setLocal(_selectedLanguage == "English" ? 'en' :'ar');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            await context.read<Auth_Provider>().logout(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OnboardingScreen()));
                          },
                          child: Container(
                            height: height * 0.06,
                            width: width * 0.7,
                            child: Center(
                              child: Text("${S.of(context).LogOut}",
                                  style: MYText().mytextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                    ],
                  );
                }),
              )
            : Scaffold(
                body: Center(
                    child: Center(
                  child: Container(
                    width: width * 0.3,
                    child: LinearProgressIndicator(
                      color: Colors.green.shade900,
                    ),
                  ),
                )),
              ));
  }
  List<DropdownMenuItem<String>> languages = [
    DropdownMenuItem(
      value: 'English',
      child: Text(
        'English',
        style: GoogleFonts.ibmPlexSans(color:Palette.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Arabic',
      child: Text(
        'العربية', // Assuming you have the Arabic translation
        style:GoogleFonts.cairo(color:Palette.primary),
      ),
    ),
  ];
}
