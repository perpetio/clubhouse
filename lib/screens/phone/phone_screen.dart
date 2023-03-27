import 'package:clubhouse/utils/router.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/widgets/rounded_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/authentication.dart';

/// The screen for entering a phone number
/// Made up of three main components: title, form, bottom part

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phoneNumberController = TextEditingController();
  final _countryController = TextEditingController(text: "+976");
  String verificationId;

  Future<void> verifyPhone(phoneNumber) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(context, authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
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

        /// Make sure to prefix with your country code
        phoneNumber: phoneNumber,

        ///No duplicated SMS will be sent out upon re-entry (before timeout).
        timeout: const Duration(seconds: 30),

        /// If the SIM (with phoneNumber) is in the current device this function is called.
        /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
        /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
        verificationCompleted: verified,

        /// Called when the verification is failed
        verificationFailed: verificationfailed,

        /// This is called after the OTP is sent. Gives a `verificationId` and `code`
        codeSent: smsSent,

        /// After automatic code retrival `tmeout` this function is called
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
            onChanged: (value) => _countryController.text = value.dialCode,
            initialSelection: _countryController.text,
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
            verifyPhone(
                '${_countryController.text}${_phoneNumberController.text}');
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
        SizedBox(height: 30),
        RoundedButton(
          color: AppColor.AccentBlue,
          minimumWidth: 230,
          disabledColor: AppColor.AccentBlue.withOpacity(0.3),
          onPressed: () {
            AuthService().signInAnonymously(context);
          },
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Guest',
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
