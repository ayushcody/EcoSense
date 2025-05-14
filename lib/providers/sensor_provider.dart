import 'package:flutter/foundation.dart';
import '../models/sensor_model.dart';
import '../models/sensor_data.dart';

class SensorProvider with ChangeNotifier {
  final List<SensorModel> _sensors = [];
  List<SensorModel> get sensors => List.unmodifiable(_sensors);

  void addSensor(SensorModel sensor) {
    _sensors.add(sensor);
    notifyListeners();
  }

  void updateSensor(SensorModel sensor) {
    final index = _sensors.indexWhere((s) => s.id == sensor.id);
    if (index != -1) {
      _sensors[index] = sensor;
      notifyListeners();
    }
  }

  void setThreshold(String sensorId, double threshold) {
    final index = _sensors.indexWhere((s) => s.id == sensorId);
    if (index != -1) {
      _sensors[index] = _sensors[index].copyWith(threshold: threshold);
      notifyListeners();
    }
  }

  void removeSensor(String id) {
    _sensors.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  SensorModel? getSensor(String id) {
    try {
      return _sensors.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateSensors(List<SensorData> dataList) {
    for (var data in dataList) {
      final index = _sensors.indexWhere((s) => s.id == data.id);
      if (index != -1) {
        // Update existing sensor
        _sensors[index].value = data.value;
        _sensors[index].history.add(data);
      } else {
        // Add new sensor
        _sensors.add(SensorModel(
          id: data.id,
          name: data.name,
          unit: data.unit,
          icon: data.icon,
          value: data.value,
          history: [data],
        ));
      }
    }
    notifyListeners();
  }
}
