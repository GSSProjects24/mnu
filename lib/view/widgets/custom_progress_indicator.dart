import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Get.height * 0.12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SpinKitWaveSpinner(
              color: Color.fromARGB(
                  255, 76, 64, 132), // Color of the spinning circles
              size: 150.0,
              // Adjust the size of the spinner as needed
            ),
            Image.asset(
              'assets/MNU-Logo.png', // Replace with the path to your image
              width: 70.0, // Adjust the width of the image as needed
              height: 70.0, // Adjust the height of the image as needed
            ),
          ],
        ),
      ),
    );
  }
}
