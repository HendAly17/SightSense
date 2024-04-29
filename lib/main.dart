import 'package:flutter/material.dart';
import 'image_upload_page.dart';
import 'emergency_contacts_page.dart';
import 'settings_page.dart';
import 'maps_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const OrderTrackingPage(),
    );
  }
}

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const MapsPage(),
          ImageUploadPage(),
          const MapsPage(), // For Voice Commands, keeping the map page
          EmergencyContactsPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavigationBarItem(Icons.map, 0),
            _buildNavigationBarItem(Icons.image, 1),
            _buildVoiceCommandButton(Icons.mic, 2),
            _buildNavigationBarItem(Icons.contacts, 3),
            _buildNavigationBarItem(Icons.settings, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBarItem(IconData icon, int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.green : Colors.black,
        size: 30,
      ),
    );
  }

Widget _buildVoiceCommandButton(IconData icon, int index) {
  return IconButton(
    onPressed: () {
      setState(() {
        _selectedIndex = index;
      });
    },
    icon: Icon(
      icon,
      color: _selectedIndex == index ? Colors.green : Colors.black,
      size: 65,
    ),
  );
}

}