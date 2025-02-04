  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'dart:ui';
  import '../models/train.dart';
  import '../services/digitraffic_service.dart';

  class TrainPopup extends StatefulWidget {
    final Train train;
    const TrainPopup({super.key, required this.train});

    @override
    State createState() => _TrainPopupState();
  }

  class _TrainPopupState extends State<TrainPopup> {
    List<TrainDetails>? trainDetails;
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
      return Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 400,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Train ${widget.train.trainNumber}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: trainDetails?.length ?? 0,
                              itemBuilder: (context, index) {
                                final detail = trainDetails![index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Station: ${detail.stationShortCode}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: detail.trainStopping
                                                    ? Colors.green.withOpacity(0.2)
                                                    : Colors.red.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                detail.trainStopping ? 'Stopping' : 'Passing',
                                                style: TextStyle(
                                                  color: detail.trainStopping
                                                      ? Colors.green[300]
                                                      : Colors.red[300],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        _buildInfoRow(
                                          'Track',
                                          detail.commercialTrack ?? 'N/A',
                                        ),
                                        _buildInfoRow(
                                          'Scheduled',
                                          DateFormat('HH:mm').format(detail.scheduledTime),
                                        ),
                                        if (detail.actualTime != null)
                                          _buildInfoRow(
                                            'Actual',
                                            DateFormat('HH:mm').format(detail.actualTime!),
                                          ),
                                        _buildInfoRow(
                                          'Delay',
                                          '${detail.differenceInMinutes} min',
                                          textColor: detail.differenceInMinutes > 0
                                              ? Colors.red[300]
                                              : Colors.green[300],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildInfoRow(String label, String value, {Color? textColor}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }