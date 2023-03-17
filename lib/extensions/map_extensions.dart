import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

extension ToJson on Map {
  String toPrettyJson() {
      forEach((key, value) {
        if (value is Timestamp) {
          this[key] = value.toDate().toString();
        }
      });

    JsonEncoder encoder = const JsonEncoder.withIndent('    ');
    String json = encoder.convert(this);
    return json;
  }
}
