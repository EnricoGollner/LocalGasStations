import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_gas_stations/app/controllers/gas_station_controller.dart';
import 'package:local_gas_stations/app/views/gas_station_screen.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    Provider(
      create: (_) => GasStationController(),
      builder: (_, __) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Gas Stations',
      home: GasStationScreen(),
    );
  }
}
