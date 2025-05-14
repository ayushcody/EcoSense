import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  String _apiEndpoint = '';
  String _apiKey = '';

  String get apiEndpoint => _apiEndpoint;
  set apiEndpoint(String value) {
    _apiEndpoint = value;
    notifyListeners();
  }

  String get apiKey => _apiKey;
  set apiKey(String value) {
    _apiKey = value;
    notifyListeners();
  }
}
