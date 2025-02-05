import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/train.dart';

class StationInfoPopup extends StatelessWidget {
  final Station station;

  const StationInfoPopup({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${station.name} (${station.code})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Platform', station.platformNumber),
          if (station.scheduledArrival != null)
            _buildInfoRow('Scheduled Arrival', 
              DateFormat('HH:mm').format(station.scheduledArrival!)),
          if (station.scheduledDeparture != null)
            _buildInfoRow('Scheduled Departure', 
              DateFormat('HH:mm').format(station.scheduledDeparture!)),
          if (station.actualArrival != null)
            _buildInfoRow('Expected Arrival', 
              DateFormat('HH:mm').format(station.actualArrival!)),
          if (station.actualDeparture != null)
            _buildInfoRow('Expected Departure', 
              DateFormat('HH:mm').format(station.actualDeparture!)),
          _buildInfoRow('Halt Duration', '${station.haltDuration} min'),
          _buildInfoRow('Distance from Source', '${station.distanceFromSource} km'),
          _buildInfoRow('Status', station.isDelayed ? 'Delayed' : 'On Time'),
          if (station.delay != null && station.delay! > 0)
            _buildInfoRow('Delay', '${station.delay} min'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}

class TrainSchedulePopup extends StatelessWidget {
  final Train train;

  const TrainSchedulePopup({super.key, required this.train});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${train.trainName} (${train.trainNumber})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Current Status', train.status),
          _buildInfoRow('Platform', train.platformNumber),
          _buildInfoRow('Delay', '${train.delay} minutes'),
          _buildInfoRow('Source', train.sourceStation),
          _buildInfoRow('Destination', train.destinationStation),
          _buildInfoRow('Current Station', train.currentStationName),
          const SizedBox(height: 16),
          const Text(
            'Station Schedule',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: train.stations.length,
              itemBuilder: (context, index) {
                final station = train.stations[index];
                return Card(
                  child: ListTile(
                    title: Text(station.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (station.scheduledArrival != null)
                          Text('Arrival: ${DateFormat('HH:mm').format(station.scheduledArrival!)}'),
                        if (station.scheduledDeparture != null)
                          Text('Departure: ${DateFormat('HH:mm').format(station.scheduledDeparture!)}'),
                        Text('Distance: ${station.distanceFromSource} km'),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: station.isDelayed ? Colors.red[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        station.isDelayed ? 'Delayed' : 'On Time',
                        style: TextStyle(
                          color: station.isDelayed ? Colors.red[900] : Colors.green[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}