import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final String espIp = 'http://192.168.178.85/sensor';
  final List<FlSpot> temperaturDaten = [];
  Timer? _timer;
  double _xAchse = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => fetchData());
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
        double temp = (data['temperatur'] ?? 0).toDouble();
        setState(() {
          _xAchse += 10;
          temperaturDaten.add(FlSpot(_xAchse, temp));
          if (temperaturDaten.length > 30) {
            temperaturDaten.removeAt(0); // nur letzte ~5 Minuten
          }
        });
      } else {
        print("Fehler: ${response.statusCode}");
      }
    } catch (e) {
      print("Verbindungsfehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperaturverlauf')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: temperaturDaten.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: temperaturDaten,
                isCurved: true,
                barWidth: 2,
                color: Colors.redAccent,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
