import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_gas_stations/app/controllers/gas_station_controller.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class GasStationScreen extends StatefulWidget {
  const GasStationScreen({super.key});

  @override
  State<GasStationScreen> createState() => GasStationScreenState();
}

class GasStationScreenState extends State<GasStationScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKey,
      appBar: AppBar(
        title: const Text('Local Gas Stations'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<GasStationController>(
        create: (context) => GasStationController(),
        child: Builder(
          builder: (context) {
            final GasStationController gasStationController = context.watch<GasStationController>();
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(gasStationController.lat, gasStationController.long),
                zoom: 14,
              ),
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              onMapCreated: (gmc) {
                gasStationController.onMapCreated(gmc);
                _mapController = gmc;
              },
              markers: gasStationController.markers,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _zoom(),
          ),
          const SizedBox(height: 7),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () => _zoom(zoomIn: false),
          ),
        ],
      ),
    );
  }
  
  void _zoom({bool zoomIn = true}) {
    _mapController.animateCamera(zoomIn ? CameraUpdate.zoomIn() : CameraUpdate.zoomOut());
  }
}