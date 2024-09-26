import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_gas_stations/app/models/gas_station.dart';
import 'package:http/http.dart' as http;


class GasStaionRepository extends ChangeNotifier {
  // final List<GasStation> _gasStations = [
  //   GasStation(
  //     name: 'Posto GT - Rede Rodoil',
  //     address: 'R. João Negrão, 1072 - Rebouças - Centro, Curitiba - PR',
  //     photo:
  //         'https://lh5.googleusercontent.com/p/AF1QipP_xnSi5-sp9slSuMpSx-JlmvwvHGL1VJ_JcOGX=w408-h306-k-no',
  //     lat: -25.4361979,
  //     long: -49.2624613,
  //   ),
  //   GasStation(
  //     name: 'Auto Posto Rodoviária',
  //     address: 'Av. Presidente Affonso Camargo 10 - Rebouças, Curitiba - PR',
  //     photo:
  //         'https://lh5.googleusercontent.com/p/AF1QipPnfQSsnvt6-VAxF-fUQ0onQCeRktJptOvSL_9F=w408-h306-k-no',
  //     lat: -25.435538,
  //     long: -49.2623809,
  //   ),
  //   GasStation(
  //     name: 'Auto Posto Nilo Cairo',
  //     address: 'R. Tibagi, 652 - Centro, Curitiba - PR',
  //     photo:
  //         'https://lh5.googleusercontent.com/p/AF1QipOB2w7C9Q_NTblNRhcxJtN3-s4_gSjHI1rs5cSM=w408-h544-k-no',
  //     lat: -25.435260,
  //     long: -49.2620769,
  //   ),
  // ];
  
  // List<GasStation> get gasStations => _gasStations;
  
   // Fetch nearby restaurants using the Places API
  Future<({String? error, List<GasStation>? gasStations})> getNearbyGasStations({required double lat, required double long}) async {
    String apiKey = dotenv.env['ANDROID_MAPS_API_KEY']!;
    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$long'
        '&radius=1500'
        '&type=gas_station'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<GasStation> gasStations = (data['results'] as List).map((json) {
        return GasStation.fromJson(json);
      }).toList();
      
      return (error: null, gasStations: gasStations);
    } else {
      return (error: 'Erro a otentar buscar', gasStations: <GasStation>[]);
    }
  }

  Future<void> getImage(String photoReference) async {
    final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=${dotenv.env['ANDROID_MAPS_API_KEY']}'));
  }
}