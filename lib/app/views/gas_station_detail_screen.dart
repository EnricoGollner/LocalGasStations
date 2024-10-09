import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_gas_stations/app/models/gas_station.dart';

class GasStatinoDetailScreen extends StatelessWidget {
  final GasStation gasStation;

  const GasStatinoDetailScreen({super.key, required this.gasStation});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: _buildImage(context),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      gasStation.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: gasStation.isOpen ? Colors.green : Colors.redAccent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      gasStation.isOpen ? 'Open' : 'Closed',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Text(gasStation.address),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;

    return gasStation.photoReference == null
        ? Image.asset(
            'assets/no-image.png',
            height: 250,
            width: widthSize,
            fit: BoxFit.cover,
          )
        : Image.network(
            _getImageUrl(gasStation.photoReference!),
            height: 250,
            width: widthSize,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Container(
                alignment: Alignment.center,
                height: 250,
                child:
                    const CircularProgressIndicator(color: Colors.blueAccent),
              );
            },
          );
  }

  ///Método que retorna o URL para requisição da imagem de destaque do posto para ser exibida no modal de detalhes do posto selecionado
  String _getImageUrl(String photoReference) {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place/photo';
    return '$baseUrl?maxwidth=250&photo_reference=$photoReference&key=${dotenv.env['ANDROID_MAPS_API_KEY']}';
  }
}
