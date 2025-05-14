import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _token = '';
  String _userId = '';
  String _username = '';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool get isAuthenticated => _isAuthenticated;
  String get userId => _userId;
  String get username => _username;
  String get token => _token;

  AuthProvider() {
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final userId = await _storage.read(key: 'user_id');
      final username = await _storage.read(key: 'username');

      if (token != null && userId != null) {
        _token = token;
        _userId = userId;
        _username = username ?? '';
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading auth data: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // TODO: Replace with actual API call
      // For now, we'll simulate a successful login
      await Future.delayed(const Duration(seconds: 1));

      if (email == 'demo@example.com' && password == 'password') {
        _token = 'demo_token';
        _userId = 'user_123';
        _username = 'Demo User';
        _isAuthenticated = true;

        // Save auth data
        await _storage.write(key: 'auth_token', value: _token);
        await _storage.write(key: 'user_id', value: _userId);
        await _storage.write(key: 'username', value: _username);

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      // TODO: Replace with actual API call
      // For now, we'll simulate a successful signup
      await Future.delayed(const Duration(seconds: 1));

      _token = 'new_user_token';
      _userId = 'new_user_${DateTime.now().millisecondsSinceEpoch}';
      _username = name;
      _isAuthenticated = true;

      // Save auth data
      await _storage.write(key: 'auth_token', value: _token);
      await _storage.write(key: 'user_id', value: _userId);
      await _storage.write(key: 'username', value: _username);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Signup error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _username = '';
    _isAuthenticated = false;

    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'username');

    notifyListeners();
  }
}
