import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/myfonts.dart';

class StatementPage extends StatefulWidget {
  const StatementPage({Key? key}) : super(key: key);

  @override
  State<StatementPage> createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Generated code for this Column Widget...
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 20, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: Get.width * 0.40,
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Member Name',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Member Number',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'NRIC number',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Gender',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Marital Status',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Date of birth',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Date off Joining',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Address',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Personal Email',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Company Name',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Cost Centre',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Telephone Number',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Entrance Fee',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Monthly fee',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Text(
                                          'Welfare Fund',
                                          style: getText(context)
                                              .bodySmall
                                              ?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      'Rajesh',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '003326',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '124265242566422',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      'Male',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      'Not married',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '13.13.2022',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '12.12.2022',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      'Kulampur ',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '123@gail.com',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      'Techin Sight',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      'kuala lampur',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '052426667290',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '300',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '10',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 12),
                                    child: Text(
                                      '100',
                                      textAlign: TextAlign.start,
                                      style:
                                          getText(context).bodySmall?.copyWith(
                                                fontFamily: 'Outfit',
                                                color: Color(0xFF0F1113),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
