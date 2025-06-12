import 'package:flutter/material.dart';
import 'screens/dashboard_page.dart';
import 'screens/automatik_page.dart';
import 'screens/devices_page.dart';
import 'screens/history_page.dart';
import 'screens/settings_page.dart';
import 'widgets/background_wrapper.dart';

void main() => runApp(const CanZeltApp());

class CanZeltApp extends StatelessWidget {
  const CanZeltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CanZelt',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const BackgroundWrapper(child: HomeScreen()), // Hintergrund global
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const pages = [
    DashboardPage(),
    AutomatikPage(),
    DevicesPage(),
    HistoryPage(),
    SettingsPage(),
  ];

  static const titles = [
    'Dashboard',
    'Automatik',
    'Geräte',
    'Verlauf',
    'Einstellungen',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green[800],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.thermostat_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_motion_outlined), label: 'Automatik'),
          BottomNavigationBarItem(icon: Icon(Icons.devices_outlined), label: 'Geräte'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined), label: 'Verlauf'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Einstellungen'),
        ],
      ),
    );
  }
}
