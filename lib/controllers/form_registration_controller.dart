import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'sessioncontroller.dart';

class FormRegistrationController extends GetxController {
  bool showTerms = false;

  // String nric_no = "";

  TextEditingController nric_no = TextEditingController();
  TextEditingController member_name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController member_no = TextEditingController();
  TextEditingController race_name = TextEditingController();
  TextEditingController gender_name = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController doj = TextEditingController();
  TextEditingController doe = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController postal_code = TextEditingController();
  TextEditingController company_name = TextEditingController();
  // TextEditingController other_company_name = TextEditingController();
  TextEditingController position = TextEditingController();
  TextEditingController employee_no = TextEditingController();
  TextEditingController telephone_no = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController entrance_fee = TextEditingController();
  TextEditingController monthly_fee = TextEditingController();
  TextEditingController starting_salary = TextEditingController();
  TextEditingController age_no = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController pf_no = TextEditingController();
  TextEditingController marital_status = TextEditingController();

  String signature_img = "";
  List<String> upload_doc = [];

  Future<Map<String, dynamic>> newregister(BuildContext context) async {
    var body = {
      "nric_no": nric_no.text,
      "member_name": member_name.text,
      "username": username.text,
      "member_no": '',
      "race_name": race_name.text,
      "gender_name": gender_name.text,
      "dob": dob.text,
      "doj": doj.text,
      "doe": doe.text,
      "address": address.text,
      "postal_code": postal_code.text,
      "company_name": company_name.text,
      // "other_company_name": other_company_name.text,
      "position": position.text,
      "employee_no": employee_no.text,
      "telephone_no": telephone_no.text,
      "email": email.text,
      "salary": salary.text,
      "starting_salary": starting_salary.text,
      "age": age_no.text,
      "department": department.text,
      "entrance_fee": entrance_fee.text,
      "monthly_fee": monthly_fee.text,
      "password": password.text,
      " pf_no": pf_no.text,
      "marital_status": marital_status.text,
      "signature_img": [signature_img],
      "upload_doc": upload_doc,
      
    };

  
    final response = await http.post(
        Uri.parse(
            'http://mnuapi.graspsoftwaresolutions.com/api_new_member_register'),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});
  
    if (response.statusCode == 200) {
    
      return jsonDecode(response.body);
    } else {
    
      

      throw Exception('Failed to load data');
    }
  }
}
