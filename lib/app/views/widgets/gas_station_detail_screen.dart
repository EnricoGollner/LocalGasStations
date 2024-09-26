import 'package:flutter/material.dart';
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
          child: _buildImage(context)
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, left: 24),
          child: Text(
            gasStation.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60, left: 24),
          child: Text(gasStation.address),
        )
      ],
    );
  }
  
  Widget _buildImage(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    // await GasStaionRepository().getImage(gasStation.photoReference!);

    return gasStation.photoReference == null
      ? Image.asset(
          'assets/no-image.png',
          height: 250,
          width: widthSize,
          fit: BoxFit.cover,
        )
      : Image.network(
          'https://images.pexels.com/photos/399635/pexels-photo-399635.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          height: 250,
          width: widthSize,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
              return const SizedBox(
                height: 250,
                child: CircularProgressIndicator(),
              );
          },
        );
  }
}