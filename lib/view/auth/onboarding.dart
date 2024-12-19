

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/myfonts.dart';


class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  OnBoardingState createState() => OnBoardingState();
}

class OnBoardingState extends State<OnBoarding> {
  PageController? pageViewController;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,

        title: Text(
          'Welcome',
                  style:getText(context).headlineLarge?.copyWith(fontSize:50 ),

        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top: Get.height*0.10),
                            child: Image.asset(

                              'assets/onboard.jpg',
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.0,horizontal: 6.0),
                            child: Text(
                              'NATIONAL UNION OF TRANSPORT EQUIPMENT AND ALLIED INDUSTRIES WORKERS',
                              textAlign: TextAlign.center,
                              style:getText(context).titleMedium?.copyWith(fontWeight: FontWeight.bold)
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                              horizontal: Get.height*0.03

                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    'ALONE WE CAN DO SO LITTLE; TOGETHER WE CAN DO SO MUCH',
                                    textAlign: TextAlign.center,
                                      style:getText(context).titleSmall
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0,
                      horizontal: Get.height*0.03),
                  child: ElevatedButton(
                    onPressed: (){

                      // Get.to(()=>NricCheck());


                    },
                    child: SizedBox(
                        width:Get.width*0.30 ,
                        child: Center(child: Text('NEXT'))),
                  )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
