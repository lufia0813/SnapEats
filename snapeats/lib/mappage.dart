import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: const Text("Snap",
        style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: const Text("Location Feature Coming Soon.."),
      );
  }
}