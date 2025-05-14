import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/sensor_provider.dart';
import '../providers/auth_provider.dart';
import '../models/sensor_model.dart';
import '../widgets/app_background.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToSensorDetails(BuildContext context, String sensorId) {
    Navigator.pushNamed(context, '/sensor/$sensorId');
  }

  void _showAddSensorDialog(BuildContext context) {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final unitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Sensor'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Sensor Name',
                  hintText: 'e.g., Kitchen Temperature',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sensor Type',
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'temperature', child: Text('Temperature')),
                  DropdownMenuItem(value: 'humidity', child: Text('Humidity')),
                  DropdownMenuItem(value: 'air', child: Text('Air Quality')),
                  DropdownMenuItem(value: 'pH', child: Text('pH Level')),
                  DropdownMenuItem(value: 'custom', child: Text('Custom')),
                ],
                onChanged: (value) {
                  typeController.text = value ?? 'custom';

                  // Set default unit based on type
                  if (value == 'temperature') {
                    unitController.text = '°C';
                  } else if (value == 'humidity') {
                    unitController.text = '%';
                  } else if (value == 'air') {
                    unitController.text = 'AQI';
                  } else if (value == 'pH') {
                    unitController.text = 'pH';
                  } else {
                    unitController.text = '';
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  hintText: 'e.g., °C, %, AQI',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  typeController.text.isNotEmpty &&
                  unitController.text.isNotEmpty) {
                // Map type to icon
                String icon = 'device_unknown';
                if (typeController.text == 'temperature') {
                  icon = 'thermostat';
                } else if (typeController.text == 'humidity') {
                  icon = 'water_drop';
                } else if (typeController.text == 'air') {
                  icon = 'air';
                } else if (typeController.text == 'pH') {
                  icon = 'science';
                }

                // Create new sensor
                final newSensor = SensorModel(
                  id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  unit: unitController.text,
                  icon: icon,
                  value: 0.0,
                  history: [],
                );

                // Add to provider
                context.read<SensorProvider>().addSensor(newSensor);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final sensors = sensorProvider.sensors;
    final username = context.read<AuthProvider>().username;

    final currentWeather = _determineWeather(sensors);
    final conclusiveReport = _generateConclusiveReport(sensors);

    return Scaffold(
      body: AppBackground(
        scrollController: _scrollController,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => Navigator.pushNamed(context, '/alerts'),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  username.isNotEmpty
                      ? 'Welcome, ${username.split(' ')[0]}'
                      : 'EcoSense',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                background: Container(
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getWeatherIcon(currentWeather),
                              size: 36,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentWeather,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Based on sensor readings',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          'Minute-by-Minute Report',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          conclusiveReport,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Overview',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: _buildWeeklyChart(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sensors',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => _showAddSensorDialog(context),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: sensors.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Text('No sensors available'),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final sensor = sensors[index];
                          return _SensorCard(
                            sensor: sensor,
                            onTap: () =>
                                _navigateToSensorDetails(context, sensor.id),
                          );
                        },
                        childCount: sensors.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _determineWeather(List<SensorModel> sensors) {
    // Find temperature and humidity sensors if available
    SensorModel? tempSensor;
    SensorModel? humiditySensor;

    for (var sensor in sensors) {
      if (sensor.name.toLowerCase().contains('temperature') ||
          sensor.unit == '°C' ||
          sensor.unit == '°F') {
        tempSensor = sensor;
      } else if (sensor.name.toLowerCase().contains('humidity') ||
          sensor.unit == '%') {
        humiditySensor = sensor;
      }
    }

    // Determine weather based on available data
    if (tempSensor != null && humiditySensor != null) {
      final temp = tempSensor.value;
      final humidity = humiditySensor.value;

      if (temp > 30) {
        return humidity > 70 ? 'Hot & Humid' : 'Hot & Dry';
      } else if (temp > 20) {
        return humidity > 70 ? 'Warm & Humid' : 'Pleasant';
      } else if (temp > 10) {
        return humidity > 80 ? 'Cool & Rainy' : 'Cool';
      } else {
        return 'Cold';
      }
    } else if (tempSensor != null) {
      final temp = tempSensor.value;
      if (temp > 30) return 'Hot';
      if (temp > 20) return 'Warm';
      if (temp > 10) return 'Cool';
      return 'Cold';
    } else if (humiditySensor != null) {
      final humidity = humiditySensor.value;
      if (humidity > 80) return 'Rainy';
      if (humidity > 60) return 'Humid';
      return 'Dry';
    }

    return 'Normal'; // Default if no relevant sensors
  }

  IconData _getWeatherIcon(String weather) {
    switch (weather.toLowerCase()) {
      case 'hot & humid':
      case 'hot & dry':
      case 'hot':
        return Icons.wb_sunny;
      case 'warm & humid':
        return Icons.wb_cloudy;
      case 'pleasant':
        return Icons.wb_twighlight;
      case 'cool & rainy':
      case 'rainy':
        return Icons.water_drop;
      case 'cool':
        return Icons.cloud;
      case 'cold':
        return Icons.ac_unit;
      case 'humid':
        return Icons.water;
      case 'dry':
        return Icons.grain;
      default:
        return Icons.wb_cloudy;
    }
  }

  String _generateConclusiveReport(List<SensorModel> sensors) {
    if (sensors.isEmpty) {
      return 'No sensor data available to generate a report.';
    }

    final buffer = StringBuffer();
    buffer.write('Current conditions: ');

    // Add temperature data if available
    final tempSensor = sensors
        .where((s) =>
            s.name.toLowerCase().contains('temperature') ||
            s.unit.contains('°'))
        .toList();

    if (tempSensor.isNotEmpty) {
      buffer.write(
          'Temperature is ${tempSensor[0].value.toStringAsFixed(1)}${tempSensor[0].unit}');

      if (tempSensor[0].value > 30) {
        buffer.write(' (very hot). ');
      } else if (tempSensor[0].value > 25) {
        buffer.write(' (hot). ');
      } else if (tempSensor[0].value > 20) {
        buffer.write(' (warm). ');
      } else if (tempSensor[0].value > 15) {
        buffer.write(' (mild). ');
      } else if (tempSensor[0].value > 10) {
        buffer.write(' (cool). ');
      } else {
        buffer.write(' (cold). ');
      }
    }

    // Add humidity data if available
    final humiditySensor = sensors
        .where((s) =>
            s.name.toLowerCase().contains('humidity') ||
            (s.unit == '%' && !s.name.contains('Air')))
        .toList();

    if (humiditySensor.isNotEmpty) {
      buffer.write(
          'Humidity is at ${humiditySensor[0].value.toStringAsFixed(0)}%');

      if (humiditySensor[0].value > 80) {
        buffer.write(' (very humid). ');
      } else if (humiditySensor[0].value > 60) {
        buffer.write(' (humid). ');
      } else if (humiditySensor[0].value > 40) {
        buffer.write(' (comfortable). ');
      } else {
        buffer.write(' (dry). ');
      }
    }

    // Add air quality data if available
    final airSensor = sensors
        .where((s) =>
            s.name.toLowerCase().contains('air') ||
            s.unit.contains('AQI') ||
            s.unit.contains('ppm'))
        .toList();

    if (airSensor.isNotEmpty) {
      buffer.write(
          'Air quality index is ${airSensor[0].value.toStringAsFixed(0)}');

      if (airSensor[0].value > 150) {
        buffer.write(' (unhealthy). ');
      } else if (airSensor[0].value > 100) {
        buffer.write(' (moderate). ');
      } else {
        buffer.write(' (good). ');
      }
    }

    // Add pH data if available
    final phSensor = sensors
        .where(
            (s) => s.name.toLowerCase().contains('ph') || s.unit.contains('pH'))
        .toList();

    if (phSensor.isNotEmpty) {
      buffer.write('pH level is ${phSensor[0].value.toStringAsFixed(1)}');

      if (phSensor[0].value > 8.5) {
        buffer.write(' (alkaline). ');
      } else if (phSensor[0].value < 6.5) {
        buffer.write(' (acidic). ');
      } else {
        buffer.write(' (neutral). ');
      }
    }

    // Add summary
    buffer.write('\n\nOverall environment status: ');

    // Check if any sensor is above threshold
    bool anyAlert = false;
    for (var sensor in sensors) {
      if (sensor.threshold != null && sensor.value > sensor.threshold!) {
        anyAlert = true;
        break;
      }
    }

    if (anyAlert) {
      buffer.write('Requires attention - some readings exceed thresholds.');
    } else {
      buffer.write('All parameters within normal range.');
    }

    return buffer.toString();
  }

  Widget _buildWeeklyChart() {
    final sensors = context.read<SensorProvider>().sensors;
    if (sensors.isEmpty) {
      return const Center(child: Text('No sensor data available'));
    }

    // For demo, create some random weekly data
    final random = math.Random();

    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    List<SensorModel> relevantSensors = [];
    if (sensors.any((s) => s.name.toLowerCase().contains('temperature'))) {
      relevantSensors.add(sensors
          .firstWhere((s) => s.name.toLowerCase().contains('temperature')));
    }
    if (sensors.any((s) => s.name.toLowerCase().contains('humidity'))) {
      relevantSensors.add(
          sensors.firstWhere((s) => s.name.toLowerCase().contains('humidity')));
    }

    if (relevantSensors.isEmpty && sensors.isNotEmpty) {
      relevantSensors.add(sensors.first);
    }

    // Generate some dummy data for the chart
    final List<List<FlSpot>> sensorData = [];
    final List<Color> lineColors = [
      Colors.red.shade300,
      Colors.blue.shade300,
      Colors.green.shade300,
    ];

    for (int i = 0; i < relevantSensors.length; i++) {
      final data = <FlSpot>[];
      final baseValue = relevantSensors[i].value;

      for (int day = 0; day < 7; day++) {
        // Generate some random fluctuation around the current value
        final value = baseValue * (0.8 + random.nextDouble() * 0.4);
        data.add(FlSpot(day.toDouble(), value));
      }

      sensorData.add(data);
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 10,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8.0,
                  child: Text(weekDays[value.toInt() % 7]),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 100,
        lineBarsData: List.generate(
          sensorData.length,
          (i) => LineChartBarData(
            spots: sensorData[i],
            isCurved: true,
            color: lineColors[i % lineColors.length],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: lineColors[i % lineColors.length].withAlpha(51),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white.withAlpha(204),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final index = barSpot.barIndex;
                if (index < relevantSensors.length) {
                  return LineTooltipItem(
                    '${relevantSensors[index].name}: ${barSpot.y.toStringAsFixed(1)} ${relevantSensors[index].unit}',
                    TextStyle(
                      color: lineColors[index % lineColors.length],
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return null;
                }
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  final SensorModel sensor;
  final VoidCallback onTap;

  const _SensorCard({
    super.key,
    required this.sensor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_mapIcon(sensor.icon),
                      size: 24, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sensor.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    sensor.value.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      sensor.unit,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              if (sensor.threshold != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: sensor.value > sensor.threshold!
                          ? Colors.red
                          : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Threshold: ${sensor.threshold}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'thermostat':
        return Icons.thermostat;
      case 'water_drop':
        return Icons.water_drop;
      case 'air':
        return Icons.air;
      case 'science':
        return Icons.science;
      default:
        return Icons.sensors;
    }
  }
}
