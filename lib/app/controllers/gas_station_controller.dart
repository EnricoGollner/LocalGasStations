import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_gas_stations/app/models/gas_station.dart';
import 'package:local_gas_stations/app/repositories/gas_station_repository.dart';
import 'package:local_gas_stations/app/views/widgets/gas_station_detail_screen.dart';
import 'package:local_gas_stations/app/views/gas_station_screen.dart';


class GasStationController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  late GoogleMapController _mapsController;
  Set<Marker> markers = <Marker>{};

  GoogleMapController get mapsController => _mapsController;

  Future<void> onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await getPosition();
    await loadGasStations();
  }
  
  Future<void> getPosition() async {
    try {
      Position position = await _currentPosition();
      lat = position.latitude;
      long = position.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }
  
  Future<Position> _currentPosition() async {
    LocationPermission permission;
    bool isActive = await Geolocator.isLocationServiceEnabled();

    if (!isActive) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso a localização');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> loadGasStations() async {
    await GasStaionRepository().getNearbyGasStations(lat: lat, long: long).then(
      (result) async {
        if (result.error != null) {
          error = result.error!;
          return;
        } else {
          for (GasStation gasStation in result.gasStations!) {
            markers.add(
              Marker(
                markerId: MarkerId(gasStation.name),
                position: LatLng(gasStation.lat, gasStation.long),
                icon: await BitmapDescriptor.asset(const ImageConfiguration(size: Size(30, 30)), 'assets/icon-gas-station.png'),
                onTap: () {
                  showModalBottomSheet(
                    context: appKey.currentState!.context,
                    builder: (context) {
                      return GasStatinoDetailScreen(gasStation: gasStation);
                    },
                  );
                },
              ),
            );
          }
        }
        notifyListeners();
      },
    );
  }
}