import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  Widget animatedChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        height: 150,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(height: 2, color: Colors.grey),
            ),
            
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text("Notifications"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text("Privacy"),
        ),
        Divider(),
        
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return SwitchListTile(
              title: const Text("Theme"),
              value: themeProvider.darkTheme,
              onChanged: (bool value) {
                themeProvider.darkTheme = value;
              },
              secondary: const Icon(Icons.brightness_6),
            );
          },
        ),
        
      ],
    );
  }

  
}