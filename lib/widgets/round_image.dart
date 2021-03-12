import 'package:flutter/material.dart';

class RoundImage extends StatelessWidget {
  final String url;
  final String path;
  final double width;
  final double height;
  final EdgeInsets margin;
  final double borderRadius;

  const RoundImage(
      {Key key,
      this.url,
      this.path = "",
      this.margin,
      this.width = 40,
      this.height = 40,
      this.borderRadius = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: DecorationImage(
          image: path.isNotEmpty ? AssetImage(path) : NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
