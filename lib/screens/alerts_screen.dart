import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../widgets/app_background.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _phoneController = TextEditingController();
  bool _whatsappNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load from storage
    setState(() {
      _whatsappNotifications = false;
      _phoneController.text = '';
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    // Save to storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final sensors = sensorProvider.sensors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Settings'),
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
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
                              Icons.notifications_active,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'WhatsApp Notifications',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Enable WhatsApp Notifications'),
                          subtitle: const Text(
                              'Receive alerts when sensor values exceed thresholds'),
                          value: _whatsappNotifications,
                          onChanged: (value) {
                            setState(() {
                              _whatsappNotifications = value;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                        AnimatedOpacity(
                          opacity: _whatsappNotifications ? 1.0 : 0.3,
                          duration: const Duration(milliseconds: 200),
                          child: IgnorePointer(
                            ignoring: !_whatsappNotifications,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'WhatsApp Phone Number',
                                    hintText: '+1234567890',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: const Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Note: Please include country code',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveSettings,
                            child: const Text('Save Notification Settings'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Sensor Alert Thresholds',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: sensors.isEmpty
                      ? const Center(
                          child: Text('No sensors available'),
                        )
                      : ListView.builder(
                          itemCount: sensors.length,
                          itemBuilder: (context, index) {
                            final sensor = sensors[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                title: Text(sensor.name),
                                subtitle: Text(
                                  sensor.threshold != null
                                      ? 'Alert when > ${sensor.threshold} ${sensor.unit}'
                                      : 'No threshold set',
                                ),
                                leading: Icon(
                                  _getIconData(sensor.icon),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showThresholdDialog(
                                    context,
                                    sensor.id,
                                    sensor.name,
                                    sensor.unit,
                                    sensor.threshold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String icon) {
    switch (icon) {
      case 'thermostat':
        return Icons.thermostat;
      case 'water_drop':
        return Icons.water_drop;
      case 'air':
        return Icons.air;
      default:
        return Icons.sensors;
    }
  }

  Future<void> _showThresholdDialog(
    BuildContext context,
    String sensorId,
    String sensorName,
    String unit,
    double? currentThreshold,
  ) async {
    final controller = TextEditingController(
      text: currentThreshold?.toString() ?? '',
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Threshold for $sensorName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Threshold Value',
                hintText: 'Enter value in $unit',
                suffixText: unit,
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
                context.read<SensorProvider>().setThreshold(sensorId, value);
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
