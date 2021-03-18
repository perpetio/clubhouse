import 'package:clubhouse/core/data.dart';
import 'package:clubhouse/utils/app_color.dart';
import 'package:clubhouse/widgets/rounded_button.dart';
import 'package:clubhouse/widgets/rounded_image.dart';
import 'package:flutter/material.dart';

/// Open when the user wants to create a new room.

class HomeBottomSheet extends StatefulWidget {
  final Function onButtonTap;

  const HomeBottomSheet({Key key, this.onButtonTap}) : super(key: key);

  @override
  _HomeBottomSheetState createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  var selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 20),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // List of 3 rooms: Open, Social, and Closed
              for (var i = 0, len = 3; i < len; i++) roomCard(i),
            ],
          ),
          Divider(thickness: 1, height: 60, indent: 20, endIndent: 20),
          Text(
            bottomSheetData[selectedButtonIndex]['selectedMessage'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          letsGoButton()
        ],
      ),
    );
  }

  Widget roomCard(int i) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        setState(() {
          selectedButtonIndex = i;
        });
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: i == selectedButtonIndex
              ? AppColor.SelectedItemGrey
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: i == selectedButtonIndex
                ? AppColor.SelectedItemBorderGrey
                : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: RoundedImage(
                width: 70,
                height: 70,
                borderRadius: 20,
                path: bottomSheetData[i]['image'],
              ),
            ),
            Text(
              bottomSheetData[i]['text'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget letsGoButton() {
    return RoundedButton(
        color: AppColor.AccentGreen,
        onPressed: widget.onButtonTap,
        text: '🎉 Let\'s go');
  }
}
