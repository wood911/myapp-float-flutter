import 'dart:convert';

class JSON {
  static stringify(Object? object) {
    try {
      return jsonEncode(object);
    } catch (e) {
      return "";
    }
  }
  static parse(String json) {
    try {
      return jsonDecode(json);
    } catch (e) {
      return {};
    }
  }
}