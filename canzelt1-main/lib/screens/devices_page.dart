import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background_wrapper.dart'; // Hintergrund-Wrapper importieren
import 'package:http/http.dart' as http;

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool heizmatteAn = false;
  bool luefterAn = false;
  bool befeuchterAn = false;
  bool lichtAn = false;

  final String espIp = 'http://192.168.178.85'; // <- ggf. anpassen

  Future<void> schalteGeraet(String geraet, bool status) async {
    final url = Uri.parse('$espIp/$geraet?status=${status ? 'ein' : 'aus'}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          if (geraet == 'heizmatte') heizmatteAn = status;
          if (geraet == 'luefter') luefterAn = status;
          if (geraet == 'befeuchter') befeuchterAn = status;
          if (geraet == 'licht') lichtAn = status;
        });
      } else {
        print('Fehler beim Senden: ${response.statusCode}');
      }
    } catch (e) {
      print('Verbindungsfehler: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text(
                'Lüfter',
                style: TextStyle(color: Colors.white),
              ),
              value: luefterAn,
              onChanged: (val) => schalteGeraet('luefter', val),
            ),
            SwitchListTile(
              title: const Text(
                'Heizmatte',
                style: TextStyle(color: Colors.white),
              ),
              value: heizmatteAn,
              onChanged: (val) => schalteGeraet('heizmatte', val),
            ),
            SwitchListTile(
              title: const Text(
                'Befeuchter',
                style: TextStyle(color: Colors.white),
              ),
              value: befeuchterAn,
              onChanged: (val) => schalteGeraet('befeuchter', val),
            ),
            SwitchListTile(
              title: const Text(
                'Beleuchtung',
                style: TextStyle(color: Colors.white),
              ),
              value: lichtAn,
              onChanged: (val) => schalteGeraet('licht', val),
            ),
          ],
        ),
      ),
    );
  }
}
