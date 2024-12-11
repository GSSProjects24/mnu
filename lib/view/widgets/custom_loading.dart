
import 'package:flutter/material.dart';

import 'custom_progress_indicator.dart';

Future<void> showLoading(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return CustomProgressIndicator();
    },
  );
}