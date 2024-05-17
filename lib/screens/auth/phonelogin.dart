  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter/widgets.dart';
  import 'package:country_picker/country_picker.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:greenhousemaintenance/providers/AuthProvider.dart';
  import 'package:greenhousemaintenance/utils/styles.dart';
  import 'package:greenhousemaintenance/utils/thems.dart';
  import 'package:provider/provider.dart';

  import '../../generated/l10n.dart';

  class PhoneLogin extends StatefulWidget {
    const PhoneLogin({super.key});

    @override
    State<PhoneLogin> createState() => _PhoneLoginState();
  }

  class _PhoneLoginState extends State<PhoneLogin> {
    bool isLoading = false;
    Country selected_country = Country(
      phoneCode: '974', // Qatar's phone code
      countryCode: 'QA', // Qatar's ISO 3166-1 alpha-2 code
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Qatar',
      example: "null",
      displayName: 'Qatar',
      displayNameNoCountryCode: 'Qatar',
      e164Key: "",
    );
    TextEditingController phonecntrlr = TextEditingController();
    @override
    Widget build(BuildContext context) {
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;
      return Consumer<Auth_Provider>(builder: (context, authProvider, child) {
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
                      "${S.of(context).glad_youre_here}",
                      style: MYText().mytextStyle(     fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF31a564))
                    ))),
                Container(
                    width: width * 0.85,
                    child: Center(
                        child: Text(
                      "${S.of(context).lets_get_you_logged_in}",
                      style: MYText().mytextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400
                      )
                    ))),
                SizedBox(
                  height: height * 0.1,
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: height * 0.01),
                    width: width * 0.8,
                    child: Text(
                      '${S.of(context).enter_your_phone_number}',
                      style: MYText().mytextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                    )),
                Center(
                  child: Container(
                    width: width * 0.85,
                    height: height * 0.07,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Palette.primary.withOpacity(0.05),
                              spreadRadius: 8,
                              blurRadius: 12)
                        ]),
                    child: Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showCountryPicker(
                                    countryListTheme: CountryListThemeData(
                                        bottomSheetHeight: height * 0.6),
                                    context: context,
                                    onSelect: (value) {
                                      setState(() {
                                        selected_country = value;
                                      });
                                    });
                              },
                              child: Text(
                                "${selected_country.flagEmoji} + ${selected_country.phoneCode}",
                                style: GoogleFonts.ibmPlexSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF31a564)),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Expanded(
                              child: TextField(
                                controller: phonecntrlr,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: MYText().mytextStyle(color: Colors.black38),
                                    hintText: "${S.of(context).phone_Number}"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.18,
                ),
                Visibility(
                  visible: context.read<Auth_Provider>().isLoading == false,
                  child: GestureDetector(
                    onTap: () async {
                      if (phonecntrlr.text.length > 6) {
                        context.read<Auth_Provider>().setloading();
                        print(
                            '****************isLoading ** $isLoading ******************');
                        // print('${selected_country.phoneCode}${phonecntrlr.text.trim()}');
                        await authProvider.signInWithPhoneNumber(context,
                            '+${selected_country.phoneCode}${phonecntrlr.text.trim()}');
                      }
                    },
                    child: Container(
                      height: height * 0.08,
                      width: width * 0.9,
                      child: Center(
                        child: Text(
                          "${S.of(context).continue_}",
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
                  visible:  context.read<Auth_Provider>().isLoading == true,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Palette.primary,
                  )),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.of(context).having_trouble}',
                        style: MYText().mytextStyle(color: Colors.black, fontSize: 14)
                      ),
                      TextSpan(
                        text: '${S.of(context).help}',
                        style: MYText().mytextStyle( color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
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
      });
    }
  }
