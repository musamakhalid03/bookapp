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
  late double _seatSize;
  late double _seatSpacing;
  late double _rowLabelWidth;
  late int _seatsPerRow;
  late double _screenFontSize;

  @override
  void initState() {
    super.initState();
    _initializeSeats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateResponsiveValues();
  }

  void _calculateResponsiveValues() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {

      _seatSize = 24.0;
      _seatSpacing = 3.0;
      _rowLabelWidth = 30.0;
      _seatsPerRow = 8;
      _screenFontSize = 18.0;
    } else if (screenWidth < 900) {

      _seatSize = 32.0;
      _seatSpacing = 6.0;
      _rowLabelWidth = 40.0;
      _seatsPerRow = 10;
      _screenFontSize = 22.0;
    } else {
      _seatSize = 36.0;
      _seatSpacing = 8.0;
      _rowLabelWidth = 50.0;
      _seatsPerRow = 12;
      _screenFontSize = 26.0;
    }
  }

  void _initializeSeats() {
    for (String row in ['A', 'B', 'C', 'D', 'E', 'F']) {
      for (int seat = 1; seat <= 12; seat++) {
        String seatId = '$row$seat';
        _seatStatus[seatId] = seat % 4 != 0 && seat % 7 != 0;
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
        } else {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Seat $seatId is already occupied'),
              duration: const Duration(seconds: 1),
            ),
          );
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

  Widget _seatGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth < 600 ? 12 : 20),
          margin: EdgeInsets.only(
            bottom: screenWidth < 600 ? 24 : 32,
            left: screenWidth < 600 ? 16 : 32,
            right: screenWidth < 600 ? 16 : 32,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.withOpacity(0.4),
                Colors.grey.withOpacity(0.2),
                Colors.grey.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(screenWidth < 600 ? 6 : 12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: screenWidth < 600 ? 1 : 2,
            ),
          ),
          child: Text(
            'S C R E E N',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _screenFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: screenWidth < 600 ? 3 : 5,
            ),
          ),
        ),
        ...['A', 'B', 'C', 'D', 'E', 'F'].map((row) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenWidth < 600 ? 6 : 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: _rowLabelWidth,
                  child: Text(
                    row,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth < 600 ? 16 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                SizedBox(width: screenWidth < 600 ? 8 : 16),
                ...List.generate(_seatsPerRow, (index) {
                  String seatId = '$row${index + 1}';
                  bool seatExists = _seatStatus.containsKey(seatId);
                  
                  if (!seatExists && index >= 10 && _seatsPerRow > 10) {
                    return SizedBox(
                      width: _seatSize,
                      height: _seatSize,
                      child: const SizedBox.shrink(),
                    );
                  }
                  
                  return seatExists ? _seat(seatId) : const SizedBox.shrink();
                }).where((widget) => widget is! SizedBox || (widget).width != null),
              ],
            ),
          );
        }),
        
        SizedBox(height: screenWidth < 600 ? 24 : 32),
        _buildLegend(),
        SizedBox(height: screenWidth < 600 ? 16 : 24),
      ],
    );
  }

  Widget _seat(String seatId) {
    final isSelected = _selectedSeats.contains(seatId);
    final isOccupied = !_seatStatus[seatId]!;
    
    return GestureDetector(
      onTap: () => _toggleSeat(seatId),
      child: Container(
        width: _seatSize,
        height: _seatSize,
        margin: EdgeInsets.symmetric(horizontal: _seatSpacing),
        decoration: BoxDecoration(
          color: _getSeatColor(seatId),
          borderRadius: BorderRadius.circular(_seatSize * 0.2),
          border: Border.all(
            color: isOccupied 
                ? Colors.transparent 
                : isSelected 
                  ? const Color(0xFF4DABF7).withOpacity(0.8)
                  : Colors.white.withOpacity(0.4),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4DABF7).withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            seatId.substring(1), 
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: _seatSize * 0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: isSmallScreen ? 16 : 24,
      runSpacing: isSmallScreen ? 12 : 16,
      children: [
        legendItem(
          Colors.white,
          'Available',
          isSmallScreen,
        ),
        legendItem(
          const Color(0xFF4DABF7),
          'Selected',
          isSmallScreen,
        ),
        legendItem(
          Colors.grey.withOpacity(0.5),
          'Occupied',
          isSmallScreen,
        ),
      ],
    );
  }

  Widget legendItem(Color color, String label, bool isSmallScreen) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSmallScreen ? 16 : 20,
          height: isSmallScreen ? 16 : 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(isSmallScreen ? 3 : 4),
            border: Border.all(
              color: color == Colors.white 
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title,
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                child: _seatGrid(),
              ),
            ),
          
            _bottomSection(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _bottomSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedSeats.isNotEmpty)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Seats:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        _selectedSeats.join(', '),
                        style: TextStyle(
                          color: const Color(0xFF4DABF7),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${(_selectedSeats.length * _seatPrice).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
              ],
            ),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedSeats.isNotEmpty
                  ? _showBookingConfirmation
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedSeats.isNotEmpty
                    ? const Color(0xFF4DABF7)
                    : Colors.grey.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 16 : 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                ),
                elevation: 4,
                shadowColor: _selectedSeats.isNotEmpty
                    ? const Color(0xFF4DABF7).withOpacity(0.5)
                    : Colors.transparent,
              ),
              child: Text(
                _selectedSeats.isNotEmpty
                    ? 'Book ${_selectedSeats.length} Seat${_selectedSeats.length > 1 ? 's' : ''}'
                    : 'Select Seats',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 600;
        
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
          ),
          backgroundColor: const Color(0xFF2D2D2D),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirm Booking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 16 : 20),
                
                Text(
                  'Movie: ${widget.movie.title}',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 8 : 12),
                
                Text(
                  'Seats: ${_selectedSeats.join(', ')}',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 8 : 12),
                
                Text(
                  'Total Price: \$${(_selectedSeats.length * _seatPrice).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 24 : 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: isSmallScreen ? 8 : 12,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                    
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Booking confirmed for ${_selectedSeats.length} seat${_selectedSeats.length > 1 ? 's' : ''}!',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );

                        setState(() {
                          _selectedSeats.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 20 : 24,
                          vertical: isSmallScreen ? 10 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}