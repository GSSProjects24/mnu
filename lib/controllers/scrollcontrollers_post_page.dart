

import 'package:flutter/material.dart';
import 'package:get/get.dart';




class PostPageScrollController extends GetxController{



  bool isLoading = false;
  //flag to check if all items loaded
  bool isAllLoaded = false;
  int totalreports=0;
  int actualReports=20;


  ScrollController controller= ScrollController();


  loadMore(void Function() loader ) {
    if (!isLoading && !isAllLoaded) {

        isLoading = true;
        update();

      //simulate loading more items
      Future.delayed(Duration(seconds: 2), () {
        if (actualReports <= totalreports ) {

          loader();



            isLoading = false;
          update();

        } else {

            isAllLoaded = true;
            isLoading = false;
            update();

        }




      }

      );
    }
  }














}