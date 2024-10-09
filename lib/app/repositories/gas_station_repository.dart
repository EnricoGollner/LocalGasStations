import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_gas_stations/app/models/gas_station.dart';
import 'package:http/http.dart' as http;


class GasStaionRepository extends ChangeNotifier {
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
}