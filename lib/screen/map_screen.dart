import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import '../models/train.dart';
import '../services/auth_provider.dart';
import '../widgets/train_popup.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Train? _train;
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  final mapController = MapController();
  final _trainNumberController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _trainNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadTrainData() async {
    final trainNumber = _trainNumberController.text.trim();
    if (trainNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a train number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _train = null;
      _markers = [];
      _polylines = [];
    });

    try {
      final service = DigitTrafficService();
      final train = await service.getLiveTrainStatus(trainNumber, 1);
      setState(() {
        _train = train;
        _updateMapData();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
}

  void _updateMapData() {
    if (_train == null) return;


    _markers = _train!.stations.map((station) {
      return Marker(
        point: LatLng(station.position.latitude, station.position.longitude),
        width: 30,
        height: 30,
        builder: (ctx) => GestureDetector(
          onTap: () => _showStationInfo(station),
          child: Icon(
            Icons.location_on,
            color: station.isNonStop ? Colors.grey : Colors.red,
            size: station.isNonStop ? 20 : 30,
          ),
        ),
      );
    }).toList();

    
    _markers.add(
      Marker(
        point: LatLng(
          _train!.currentPosition.latitude,
          _train!.currentPosition.longitude,
        ),
        width: 40,
        height: 40,
        builder: (ctx) => GestureDetector(
          onTap: () => _showTrainSchedule(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Icon(
              Icons.train,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ),
      ),
    );

   
    _polylines = [
      Polyline(
        points: _train!.stations
            .where((s) => s.position.latitude != 0 && s.position.longitude != 0)
            .map((s) => LatLng(s.position.latitude, s.position.longitude))
            .toList(),
        color: Colors.blue,
        strokeWidth: 3.0,
      ),
    ];

   
    if (_train!.currentPosition.latitude != 0 && 
        _train!.currentPosition.longitude != 0) {
      mapController.move(
        LatLng(
          _train!.currentPosition.latitude,
          _train!.currentPosition.longitude,
        ),
        8.0,
      );
    }
  }

  void _showStationInfo(Station station) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StationInfoPopup(station: station),
    );
  }

  void _showTrainSchedule() {
    if (_train == null) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => TrainSchedulePopup(train: _train!),
    );
  }

  Widget _buildTrainStatusCard() {
    if (_train == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_train!.trainName} (${_train!.trainNumber})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current Station: ${_train!.currentStationName}'),
                Text('Platform: ${_train!.platformNumber}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${_train!.status}',
                  style: TextStyle(
                    color: _train!.delay > 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_train!.delay > 0)
                  Text(
                    'Delay: ${_train!.delay} min',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 8,
              right: 8,
              bottom: 8,
            ),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _trainNumberController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter Train Number',
                      prefixIcon: const Icon(Icons.train),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      errorText: _errorMessage,
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _loadTrainData(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _loadTrainData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search, color: Colors.blue),
                ),
              ],
            ),
          ),
          
         
          _buildTrainStatusCard(),
          
        
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: LatLng(20.5937, 78.9629), 
                zoom: 5,
                interactiveFlags: InteractiveFlag.all,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylines: _polylines,
                ),
                MarkerLayer(
                  markers: _markers,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}