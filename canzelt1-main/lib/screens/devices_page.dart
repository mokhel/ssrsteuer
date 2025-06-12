import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background_wrapper.dart'; // Hintergrund-Wrapper importieren

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool luefter = false;
  bool heizmatte = false;
  bool befeuchter = false;
  bool licht = false;

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  Future<void> _loadStates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      luefter = prefs.getBool('luefter') ?? false;
      heizmatte = prefs.getBool('heizmatte') ?? false;
      befeuchter = prefs.getBool('befeuchter') ?? false;
      licht = prefs.getBool('licht') ?? false;
    });
  }

  Future<void> _saveState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(title: const Text('Geräte')),
      body: BackgroundWrapper(
        child: ListView(
          children: [
            _buildSwitchTile('Lüfter', luefter, (value) {
              setState(() => luefter = value);
              _saveState('luefter', value);
            }),
            _buildSwitchTile('Heizmatte', heizmatte, (value) {
              setState(() => heizmatte = value);
              _saveState('heizmatte', value);
            }),
            _buildSwitchTile('Befeuchter', befeuchter, (value) {
              setState(() => befeuchter = value);
              _saveState('befeuchter', value);
            }),
            _buildSwitchTile('Beleuchtung', licht, (value) {
              setState(() => licht = value);
              _saveState('licht', value);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
    );
  }
}
