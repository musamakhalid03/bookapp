// ignore_for_file: deprecated_member_use

import 'package:com_test_testapp/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  final MovieDetail movie;

  const SeatSelectionScreen({super.key, required this.movie});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> _selectedSeats = [];
  final Map<String, bool> _seatStatus = {};
  final double _seatPrice = 15.0;

  @override
  void initState() {
    super.initState();
    _initializeSeats();
  }

  void _initializeSeats() {
    // Rows A to F
    for (String row in ['A', 'B', 'C', 'D', 'E', 'F']) {
      for (int seat = 1; seat <= 10; seat++) {
        String seatId = '$row$seat';
        // Randomly mark some seats as occupied
        _seatStatus[seatId] = seat % 3 != 0;
      }
    }
  }

  void _toggleSeat(String seatId) {
    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        if (_seatStatus[seatId] == true) {
          _selectedSeats.add(seatId);
        }
      }
    });
  }

  Color _getSeatColor(String seatId) {
    if (!_seatStatus[seatId]!) {
      return Colors.grey.withOpacity(0.5);
    } else if (_selectedSeats.contains(seatId)) {
      return const Color(0xFF4DABF7);
    } else {
      return Colors.white;
    }
  }

  Widget _buildSeatGrid() {
    return Column(
      children: [
        // Screen
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.withOpacity(0.3),
                Colors.grey.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'SCREEN',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
        ),
        // Seats
        ...['A', 'B', 'C', 'D', 'E', 'F'].map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row label
                SizedBox(
                  width: 40,
                  child: Text(
                    row,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Seats in this row
                ...List.generate(10, (index) {
                  String seatId = '$row${index + 1}';
                  return GestureDetector(
                    onTap: () => _toggleSeat(seatId),
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _getSeatColor(seatId),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _seatStatus[seatId]!
                              ? Colors.white.withOpacity(0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: _selectedSeats.contains(seatId)
                                ? Colors.white
                                : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
        const SizedBox(height: 32),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(Colors.white, 'Available'),
            const SizedBox(width: 20),
            _buildLegendItem(const Color(0xFF4DABF7), 'Selected'),
            const SizedBox(width: 20),
            _buildLegendItem(Colors.grey.withOpacity(0.5), 'Occupied'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildSeatGrid(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
            child: Column(
              children: [
                if (_selectedSeats.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Selected Seats:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _selectedSeats.join(', '),
                            style: const TextStyle(
                              color: Color(0xFF4DABF7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Price:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '\$${(_selectedSeats.length * _seatPrice).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ElevatedButton(
                  onPressed: _selectedSeats.isNotEmpty
                      ? () {
                          _showBookingConfirmation();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: _selectedSeats.isNotEmpty
                        ? const Color(0xFF4DABF7)
                        : Colors.grey,
                  ),
                  child: Text(
                    _selectedSeats.isNotEmpty
                        ? 'Book ${_selectedSeats.length} Seat(s)'
                        : 'Select Seats',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Text(
            'Confirm booking for ${_selectedSeats.length} seat(s) for \$${(_selectedSeats.length * _seatPrice).toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking confirmed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Clear selection after booking
              setState(() {
                _selectedSeats.clear();
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}