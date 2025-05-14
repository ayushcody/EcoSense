import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/sensor_provider.dart';
import '../models/sensor_model.dart';
import '../models/sensor_data.dart';
import '../widgets/app_background.dart';
import 'dart:math' as math;

class SensorDetailsScreen extends StatefulWidget {
  final String sensorId;

  const SensorDetailsScreen({
    super.key,
    required this.sensorId,
  });

  @override
  State<SensorDetailsScreen> createState() => _SensorDetailsScreenState();
}

class _SensorDetailsScreenState extends State<SensorDetailsScreen> {
  bool _isDaily = true; // Toggle between daily and weekly view
  SensorData? _selectedData;

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final sensor = sensorProvider.getSensor(widget.sensorId);

    if (sensor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sensor Details')),
        body: const Center(child: Text('Sensor not found')),
      );
    }

    return Scaffold(
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(sensor.name),
                background: Container(
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => _showThresholdDialog(context, sensor),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentValueCard(sensor),
                    const SizedBox(height: 16),
                    _buildGraphCard(sensor),
                    const SizedBox(height: 16),
                    _buildStatusCard(sensor),
                    const SizedBox(height: 16),
                    _buildHistoricalDataCard(sensor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentValueCard(SensorModel sensor) {
    final connectivity = _getConnectivityStatus(sensor);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Value',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _getIconData(sensor.icon),
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sensor.value.toStringAsFixed(1)} ${sensor.unit}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.wifi,
                          size: 16,
                          color: connectivity.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          connectivity.label,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (sensor.threshold != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: sensor.value > sensor.threshold!
                        ? Colors.red
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Threshold: ${sensor.threshold} ${sensor.unit}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard(SensorModel sensor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historical Data',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text('Daily'),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text('Weekly'),
                    ),
                  ],
                  selected: {_isDaily},
                  onSelectionChanged: (Set<bool> newSelection) {
                    setState(() {
                      _isDaily = newSelection.first;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: _buildChart(sensor),
            ),
            if (_selectedData != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconData(sensor.icon),
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedData!.value.toStringAsFixed(1)} ${sensor.unit} at ${_formatTime(_selectedData!.timestamp)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(SensorModel sensor) {
    final status = _getSensorStatus(sensor);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              status.icon,
              size: 32,
              color: status.color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricalDataCard(SensorModel sensor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildStatRow('Minimum', _getMinValue(sensor), sensor.unit),
            const Divider(height: 24),
            _buildStatRow('Maximum', _getMaxValue(sensor), sensor.unit),
            const Divider(height: 24),
            _buildStatRow('Average', _getAvgValue(sensor), sensor.unit),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, double value, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          '${value.toStringAsFixed(1)} $unit',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildChart(SensorModel sensor) {
    final random = math.Random();

    // Generate some dummy data for the chart
    final List<FlSpot> spots = [];
    final now = DateTime.now();
    final baseValue = sensor.value;

    final int totalPoints = _isDaily ? 24 : 7;
    final double maxX = _isDaily ? 23 : 6;

    for (int i = 0; i < totalPoints; i++) {
      // Generate some random fluctuation around the current value
      final fluctuation = (random.nextDouble() - 0.5) * 10;
      final value = baseValue + fluctuation;
      spots.add(FlSpot(i.toDouble(), value));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: _isDaily ? 4 : 1,
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
              interval: _isDaily ? 4 : 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                String text = '';
                if (_isDaily) {
                  text = '${value.toInt()}:00';
                } else {
                  final weekDays = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];
                  text = weekDays[value.toInt() % 7];
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8.0,
                  child: Text(text),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: sensor.value * 2,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withAlpha(128),
                Theme.of(context).colorScheme.primary,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withAlpha(76),
                  Theme.of(context).colorScheme.primary.withAlpha(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white.withAlpha(204),
          ),
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
            if (event is FlTapUpEvent) {
              if (touchResponse?.lineBarSpots != null &&
                  touchResponse!.lineBarSpots!.isNotEmpty) {
                final spot = touchResponse.lineBarSpots!.first;
                setState(() {
                  _selectedData = SensorData(
                    id: sensor.id,
                    name: sensor.name,
                    unit: sensor.unit,
                    icon: sensor.icon,
                    value: spot.y,
                    timestamp: _isDaily
                        ? DateTime(now.year, now.month, now.day, spot.x.toInt())
                        : now.subtract(Duration(days: (6 - spot.x).toInt())),
                  );
                });
              }
            }
          },
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
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

  ({String label, Color color}) _getConnectivityStatus(SensorModel sensor) {
    // Simulated connectivity status
    final random = math.Random();
    final value = random.nextDouble();

    if (value > 0.8) {
      return (label: 'Excellent', color: Colors.green);
    } else if (value > 0.6) {
      return (label: 'Good', color: Colors.lightGreen);
    } else if (value > 0.4) {
      return (label: 'Fair', color: Colors.amber);
    } else if (value > 0.2) {
      return (label: 'Poor', color: Colors.orange);
    } else {
      return (label: 'Offline', color: Colors.red);
    }
  }

  ({String title, String description, IconData icon, Color color})
      _getSensorStatus(SensorModel sensor) {
    if (sensor.threshold != null && sensor.value > sensor.threshold!) {
      return (
        title: 'Alert: Above Threshold',
        description:
            'The current value exceeds the set threshold of ${sensor.threshold} ${sensor.unit}',
        icon: Icons.warning_amber_rounded,
        color: Colors.red,
      );
    }

    // Logic based on sensor type
    if (sensor.name.toLowerCase().contains('temperature') ||
        sensor.unit.contains('°')) {
      if (sensor.value > 30) {
        return (
          title: 'High Temperature',
          description: 'Temperature is above 30°C which is considered high',
          icon: Icons.thermostat,
          color: Colors.red,
        );
      } else if (sensor.value < 10) {
        return (
          title: 'Low Temperature',
          description: 'Temperature is below 10°C which is considered low',
          icon: Icons.ac_unit,
          color: Colors.blue,
        );
      }
    } else if (sensor.name.toLowerCase().contains('humidity')) {
      if (sensor.value > 70) {
        return (
          title: 'High Humidity',
          description: 'Humidity is above 70% which is considered high',
          icon: Icons.water,
          color: Colors.blue,
        );
      } else if (sensor.value < 30) {
        return (
          title: 'Low Humidity',
          description: 'Humidity is below 30% which is considered low',
          icon: Icons.water_drop,
          color: Colors.orange,
        );
      }
    } else if (sensor.name.toLowerCase().contains('air') ||
        sensor.unit.contains('AQI')) {
      if (sensor.value > 150) {
        return (
          title: 'Poor Air Quality',
          description: 'Air quality index is above 150 which is unhealthy',
          icon: Icons.air,
          color: Colors.red,
        );
      } else if (sensor.value > 100) {
        return (
          title: 'Moderate Air Quality',
          description: 'Air quality index is between 100-150 which is moderate',
          icon: Icons.air,
          color: Colors.amber,
        );
      }
    }

    // Default status
    return (
      title: 'Normal Operation',
      description: 'All values are within the normal range',
      icon: Icons.check_circle,
      color: Colors.green,
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  double _getMinValue(SensorModel sensor) {
    if (sensor.history.isEmpty) {
      return sensor.value * 0.8; // Simulate a minimum for demo
    }
    return sensor.history
        .map((data) => data.value)
        .reduce((a, b) => a < b ? a : b);
  }

  double _getMaxValue(SensorModel sensor) {
    if (sensor.history.isEmpty) {
      return sensor.value * 1.2; // Simulate a maximum for demo
    }
    return sensor.history
        .map((data) => data.value)
        .reduce((a, b) => a > b ? a : b);
  }

  double _getAvgValue(SensorModel sensor) {
    if (sensor.history.isEmpty) {
      return sensor.value; // Use current value for demo
    }
    final sum =
        sensor.history.map((data) => data.value).reduce((a, b) => a + b);
    return sum / sensor.history.length;
  }

  Future<void> _showThresholdDialog(
      BuildContext context, SensorModel sensor) async {
    final controller = TextEditingController(
      text: sensor.threshold?.toString() ?? '',
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Threshold for ${sensor.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Threshold Value',
                hintText: 'Enter value in ${sensor.unit}',
                suffixText: sensor.unit,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You will receive alerts when the sensor value exceeds this threshold.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                context.read<SensorProvider>().setThreshold(sensor.id, value);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
