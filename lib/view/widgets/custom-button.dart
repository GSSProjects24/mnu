import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/myfonts.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.title,
    this.onPressed,
    this.style,
  });

  final String title;
  final void Function()? onPressed;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.05,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.purple
          // gradient: LinearGradient(
          //   colors: [Color(0x8008), Color(0xFFEC0000), Color.fromRGBO(236, 0, 0, 1)],
          //   stops: [0, 0.5, 1],
          //   begin: AlignmentDirectional(-0.98, -1),
          //   end: AlignmentDirectional(0.98, 1),
          // ),
          ),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              maximumSize: MaterialStateProperty.all(
                  Size(Get.width * 0.60, Get.height * 0.06)),
              minimumSize: MaterialStateProperty.all(
                  Size(Get.width * 0.60, Get.height * 0.06)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          child: Text(
            title,
            style: style ??
                getText(context).headlineSmall?.copyWith(color: Colors.white),
          )),
    );
  }
}
