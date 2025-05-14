import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  static const _keyName = 'user_name';

  String _name = '';

  UserProvider() {
    _load();
  }

  Future<void> _load() async {
    _name = await _storage.read(key: _keyName) ?? '';
    notifyListeners();
  }

  String get name => _name;

  set name(String v) {
    _name = v;
    _storage.write(key: _keyName, value: v);
    notifyListeners();
  }
}
