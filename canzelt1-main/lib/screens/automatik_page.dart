import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background_wrapper.dart'; // Hintergrund-Wrapper

class AutomatikPage extends StatefulWidget {
  const AutomatikPage({super.key});
  @override
  State<AutomatikPage> createState() => _AutomatikPageState();
}

class _AutomatikPageState extends State<AutomatikPage> {
  final Map<String, Map<String, int>> phaseTargets = {
    'Keimung': {'tempMin': 24, 'tempMax': 26, 'humMin': 70, 'humMax': 80},
    'Wachstum': {'tempMin': 22, 'tempMax': 28, 'humMin': 60, 'humMax': 70},
    'Vorblüte': {'tempMin': 20, 'tempMax': 26, 'humMin': 50, 'humMax': 60},
    'Blüte': {'tempMin': 18, 'tempMax': 24, 'humMin': 40, 'humMax': 50},
  };

  String selectedPhase = 'Keimung';
  bool heaterOn = false;
  bool humidifierOn = false;

  @override
  void initState() {
    super.initState();
    loadPhase();
  }

  Future<void> loadPhase() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedPhase = prefs.getString('activePhase') ?? 'Keimung';
    });
    checkDeviceStatus();
  }

  Future<void> savePhase() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('activePhase', selectedPhase);
  }

  void checkDeviceStatus() {
    final targets = phaseTargets[selectedPhase]!;
    int currentTemperature = 22; // Beispielwerte
    int currentHumidity = 65;

    setState(() {
      heaterOn = currentTemperature < targets['tempMin']!;
      humidifierOn = currentHumidity < targets['humMin']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final targets = phaseTargets[selectedPhase]!;

    return Scaffold(
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pflanzenphase wählen:',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedPhase,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: Colors.white.withOpacity(0.5),
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                isExpanded: true,
                alignment: Alignment.center, // wichtig für mittige Darstellung
                items: phaseTargets.keys.map((phase) {
                  return DropdownMenuItem(
                    value: phase,
                    child: Center(child: Text(phase, textAlign: TextAlign.center)),
                  );
                }).toList(),
                onChanged: (phase) {
                  if (phase != null) {
                    setState(() {
                      selectedPhase = phase;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await savePhase();
                    checkDeviceStatus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Phase "$selectedPhase" übernommen')),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Phase übernehmen'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Ziel-Temperatur: ${targets['tempMin']}–${targets['tempMax']} °C',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Ziel-Luftfeuchte: ${targets['humMin']}–${targets['humMax']} %',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 32),
              Text(
                'Heizmatte: ${heaterOn ? 'AN' : 'AUS'}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Befeuchter: ${humidifierOn ? 'AN' : 'AUS'}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
