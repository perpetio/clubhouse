import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/services/authenticate.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/widgets/rounded_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phoneNumberController = TextEditingController();
  String verificationId;

  Future<void> verifyPhone(phoneNumber) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(context, authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;

      Navigator.of(context)
          .pushNamed(Routers.sms, arguments: this.verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 30, bottom: 60),
        child: Column(
          children: [
            title(),
            SizedBox(height: 50),
            form(),
            Spacer(),
            bottom(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Text(
      'Enter your phone #',
      style: TextStyle(fontSize: 25),
    );
  }

  Widget form() {
    return Container(
      width: 330,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CountryCodePicker(
            initialSelection: 'UA',
            showCountryOnly: false,
            alignLeft: false,
            padding: const EdgeInsets.all(8),
            textStyle: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: Form(
              child: TextFormField(
                controller: _phoneNumberController,
                autocorrect: false,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottom() {
    return Column(
      children: [
        Text(
          'By entering your number, you\'re agreeing to out\nTerms or Services and Privacy Policy. Thanks!',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 30),
        RoundedButton(
          color: AppColor.AccentBlue,
          minimumWidth: 230,
          disabledColor: AppColor.AccentBlue.withOpacity(0.3),
          onPressed: () {
            verifyPhone('+380${_phoneNumberController.text}');
          },
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Icon(Icons.arrow_right_alt, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
