import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ESP32 IP-Adresse:', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          TextField(controller: controller, decoration: const InputDecoration(border: OutlineInputBorder())),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Hier später in SharedPreferences speichern
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}
