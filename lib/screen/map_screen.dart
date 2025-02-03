import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import '../models/train.dart';
import '../services/digitraffic_service.dart';
import '../widgets/train_popup.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final PopupController _popupLayerController = PopupController();
  List<Train> trains = [];

  @override
  void initState() {
    super.initState();
    _loadTrains();
  }

  Future<void> _loadTrains() async {
    try {
      final trainsData = await DigitrafficService().getTrains();
      setState(() {
        trains = trainsData;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading trains: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTrains,
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(62.2426, 25.7473), // Center of Finland
          zoom: 6,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.train_tracker',
          ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              popupController: _popupLayerController,
              markers: trains.map((train) {
                return Marker(
                  point: LatLng(
                    train.location.latitude,
                    train.location.longitude,
                  ),
                  width: 40,
                  height: 40,
                  builder: (context) => Icon(
                    Icons.train,
                    color: train.delayed ? Colors.red : Colors.blue,
                  ),
                );
              }).toList(),
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) {
                  final train = trains.firstWhere((t) =>
                      t.location.latitude == marker.point.latitude &&
                      t.location.longitude == marker.point.longitude);
                  return TrainPopup(train: train);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}