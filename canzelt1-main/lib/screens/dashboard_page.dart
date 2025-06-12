import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/background_wrapper.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double temperature = 0.0;
  double humidity = 0.0;
  bool isLoading = true;

  final String espIp = 'http://192.168.178.85/data'; // Deine ESP-IP hier
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchData();

    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(espIp));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          temperature = data['temperature'];
          humidity = data['humidity'];
          isLoading = false;
        });
      } else {
        print('Fehler: ${response.statusCode}');
      }
    } catch (e) {
      print('Verbindungsfehler: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🌡 Temperatur: ${temperature.toStringAsFixed(1)} °C',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                '💧 Luftfeuchtigkeit: ${humidity.toStringAsFixed(1)} %',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: fetchData,
                icon: const Icon(Icons.refresh),
                label: const Text('Manuell aktualisieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
