import 'package:clubhouse/services/authenticate.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

/// The screen for input verification code
/// Made up of three main components: title, form, bottom part

class SmsScreen extends StatefulWidget {
  final String verificationId;

  const SmsScreen({Key key, this.verificationId}) : super(key: key);
  @override
  _SmsScreenState createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  final _smsController = TextEditingController();

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
    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 80.0),
      child: Text(
        'Enter the code we just texted you',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget form() {
    return Column(
      children: [
        Container(
          width: 330,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: _smsController,
              autocorrect: false,
              autofocus: false,
              decoration: InputDecoration(
                hintText: '••••',
                hintStyle: TextStyle(
                  fontSize: 20,
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Text(
          'Didnt receive it? Tap to resend.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget bottom() {
    return Column(
      children: [
        SizedBox(height: 30),
        RoundedButton(
          color: AppColor.AccentBlue,
          minimumWidth: 230,
          disabledColor: AppColor.AccentBlue.withOpacity(0.3),
          onPressed: () {
            AuthService().signInWithOTP(
                context, _smsController.text, widget.verificationId);
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
