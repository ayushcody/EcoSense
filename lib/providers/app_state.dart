import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../services/api_service.dart';
import '../providers/sensor_provider.dart';

class AppState extends ChangeNotifier {
  late ApiService _apiService;
  Timer? _timer;
  final SensorProvider _sensorProvider;
  final SettingsProvider _settingsProvider;

  AppState(
      {required SensorProvider sensorProvider,
      required SettingsProvider settingsProvider})
      : _sensorProvider = sensorProvider,
        _settingsProvider = settingsProvider {
    _initApiService();
    _startDataFetching();
  }

  void _initApiService() {
    _apiService = ApiService(
      endpoint: _settingsProvider.apiEndpoint,
      apiKey: _settingsProvider.apiKey,
    );
  }

  void _startDataFetching() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final data = await _apiService.fetchLatest();
        _sensorProvider.updateSensors(data);
      } catch (e) {
        debugPrint('Error fetching sensor data: $e');
      }
    });
  }

  void updateDependencies(
      SettingsProvider settings, SensorProvider sensorProv) {
    _timer?.cancel();
    _apiService = ApiService(
      endpoint: settings.apiEndpoint,
      apiKey: settings.apiKey,
    );
    _startDataFetching();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
