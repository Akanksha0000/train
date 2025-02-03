import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/train.dart';
import '../services/digitraffic_service.dart';

class TrainPopup extends StatefulWidget {
  final Train train;

  const TrainPopup({super.key, required this.train});

  @override
  State<TrainPopup> createState() => _TrainPopupState();
}

class _TrainPopupState extends State<TrainPopup> {
  TrainDetails? trainDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainDetails();
  }

  Future<void> _loadTrainDetails() async {
    try {
      final details = await DigitrafficService()
          .getTrainDetails(widget.train.trainNumber);
      if (mounted) {
        setState(() {
          trainDetails = details;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 300,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Train ${widget.train.trainNumber}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    if (trainDetails != null) ...[
                      Text('Type: ${trainDetails!.trainType}'),
                      Text(
                        'From: ${trainDetails!.departureStation}',
                      ),
                      Text(
                        'To: ${trainDetails!.destinationStation}',
                      ),
                      Text(
                        'Scheduled: ${DateFormat('HH:mm').format(trainDetails!.scheduledDeparture)}',
                      ),
                      if (trainDetails!.actualDeparture != null)
                        Text(
                          'Actual: ${DateFormat('HH:mm').format(trainDetails!.actualDeparture!)}',
                        ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Current Speed: ${widget.train.speed.toStringAsFixed(1)} km/h',
                    ),
                    Text(
                      'Status: ${widget.train.delayed ? "Delayed" : "On Time"}',
                      style: TextStyle(
                        color: widget.train.delayed ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}