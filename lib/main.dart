import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/models/booking_model.dart';
import 'data/models/ticket_model.dart';
import 'data/repositories/firestore_booking_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripify',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  final BookingRepository _bookingRepository = FirestoreBookingRepository(
    firestore: FirebaseFirestore.instance,
  );

  static const List<String> recentSearches = [
    'Bandung → Jakarta\n25 Oktober 2024',
    'Bandung → Jakarta\n24 Oktober 2024',
    'Bandung → Jakarta\n23 Oktober 2024',
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    const bookingFormOverlap =
        0.0; // You can change the value, but for now its unused
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Scrollable content — goes behind the floating bar
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff2F1398), Color(0xff0451c4)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selamat Datang Kembali!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Mr. Kamil',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                'assets/images/logo_small.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Transform.translate(
                        offset: const Offset(0, bookingFormOverlap),
                        child: _buildBookingForm(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24 + bookingFormOverlap),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pencarian Terakhir',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recentSearches.length,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                              right: index != recentSearches.length - 1
                                  ? 12
                                  : 0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                recentSearches[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Promo & Diskon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Image.network(
                            'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/rsfit40004000gsm/homenext_dashboard/2026/02/12/63fe03f1-dd8d-4cf8-9ba6-b9cd2d0df3ec-1770877580873-a15bcd644e1362cdcf6de7cdc41b8ab1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildBestDealSection(),
                const SizedBox(height: 24),
                _buildDebugButtonsSection(),
              ],
            ),
          ),

          Positioned(
            bottom: 16 + bottomInset,
            left: 24,
            right: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(0, Icons.home_outlined, 'Beranda'),
                      _buildNavItem(1, Icons.bookmark_outline, 'Orders'),
                      _buildNavItem(2, Icons.person_outline, 'You'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF001D88), Color(0xFF0064FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dari',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Bandung (BD)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 12),
                      const Text(
                        'Ke',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Surabaya (SBY)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.swap_vert,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanggal',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Kamis, 3 Okt',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Penumpang',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Text(
                  '1 Penumpang',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cari Tiket',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.search, color: Colors.black87),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestDealSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best Deal For You',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          StreamBuilder<List<TicketModel>>(
            stream: _bookingRepository.watchAvailableTickets(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Gagal memuat tiket: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final tickets = snapshot.data ?? const <TicketModel>[];
              if (tickets.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('Belum ada tiket tersedia.'),
                );
              }

              return Column(
                children: tickets
                    .map(_buildBestDealCard)
                    .toList(growable: false),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDebugButtonsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _openDebugScreen(_DebugSection.booking),
              icon: const Icon(Icons.bookmark_outline),
              label: const Text('Booking Debug'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _openDebugScreen(_DebugSection.ticket),
              icon: const Icon(Icons.train_outlined),
              label: const Text('Ticket Debug'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDebugScreen(_DebugSection section) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _DebugToolsScreen(
          bookingRepository: _bookingRepository,
          initialSection: section,
        ),
      ),
    );
  }

  Widget _buildBestDealCard(TicketModel ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE1E1E1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 24,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'K',
                        style: TextStyle(color: Color(0xFF223E99)),
                      ),
                      TextSpan(
                        text: 'A',
                        style: TextStyle(color: Color(0xFF223E99)),
                      ),
                      TextSpan(
                        text: 'I',
                        style: TextStyle(color: Color(0xFFED6D1D)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.train,
                      style: const TextStyle(
                        fontSize: 24 * 0.72,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      ticket.seatClass ?? 'Ekonomi',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5F5F5F),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (ticket.oldPrice != null)
                    Text(
                      _formatIdr(ticket.oldPrice),
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    _formatIdr(ticket.price),
                    style: const TextStyle(
                      color: Color(0xFFF81818),
                      fontSize: 32 * 0.72,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ticket.seatsLeft != null
                        ? '${ticket.seatsLeft} kursi tersisa'
                        : 'Kursi tersisa belum tersedia',
                    style: const TextStyle(
                      color: Color(0xFFF81818),
                      fontSize: 18 * 0.72,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStationColumn(
                ticket.departTime ?? '-',
                ticket.originStation,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFC8C8C8),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          ticket.duration ?? '-',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFA9A9A9),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFC8C8C8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildStationColumn(
                ticket.arriveTime ?? '-',
                ticket.destinationStation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatIdr(int? value) {
    if (value == null) {
      return 'IDR -';
    }
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'IDR $formatted';
  }

  Widget _buildStationColumn(String time, String station) {
    return SizedBox(
      width: 88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 20 * 0.72,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            station,
            style: const TextStyle(
              fontSize: 15 * 0.72,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Colors.black
                : Colors.black.withValues(alpha: 0.7),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected
                  ? Colors.black
                  : Colors.black.withValues(alpha: 0.7),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

enum _DebugSection { booking, ticket }

class _DebugToolsScreen extends StatefulWidget {
  const _DebugToolsScreen({
    required this.bookingRepository,
    required this.initialSection,
  });

  final BookingRepository bookingRepository;
  final _DebugSection initialSection;

  @override
  State<_DebugToolsScreen> createState() => _DebugToolsScreenState();
}

class _DebugToolsScreenState extends State<_DebugToolsScreen> {
  late _DebugSection _selectedSection;

  final TextEditingController _userIdController = TextEditingController(
    text: '1',
  );
  final TextEditingController _ticketIdController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController(
    text: 'A1',
  );
  final TextEditingController _bookingIdController = TextEditingController();
  String _bookingStatus = 'confirmed';
  String? _bookingMessage;
  bool _bookingError = false;

  final TextEditingController _manageTicketIdController =
      TextEditingController();
  final TextEditingController _trainController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: '2026-05-01 09:30',
  );
  final TextEditingController _seatClassController = TextEditingController(
    text: 'Ekonomi',
  );
  final TextEditingController _departTimeController = TextEditingController(
    text: '09:30',
  );
  final TextEditingController _arriveTimeController = TextEditingController(
    text: '12:20',
  );
  final TextEditingController _durationController = TextEditingController(
    text: '2j 50m',
  );
  final TextEditingController _oldPriceController = TextEditingController(
    text: '180000',
  );
  final TextEditingController _priceController = TextEditingController(
    text: '150000',
  );
  final TextEditingController _seatsLeftController = TextEditingController(
    text: '6',
  );
  String _ticketStatus = 'available';
  String? _ticketMessage;
  bool _ticketError = false;

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection;
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _ticketIdController.dispose();
    _seatsController.dispose();
    _bookingIdController.dispose();
    _manageTicketIdController.dispose();
    _trainController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    _seatClassController.dispose();
    _departTimeController.dispose();
    _arriveTimeController.dispose();
    _durationController.dispose();
    _oldPriceController.dispose();
    _priceController.dispose();
    _seatsLeftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Tools')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<_DebugSection>(
              segments: const [
                ButtonSegment<_DebugSection>(
                  value: _DebugSection.booking,
                  icon: Icon(Icons.bookmark_outline),
                  label: Text('Booking'),
                ),
                ButtonSegment<_DebugSection>(
                  value: _DebugSection.ticket,
                  icon: Icon(Icons.train_outlined),
                  label: Text('Ticket'),
                ),
              ],
              selected: {_selectedSection},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedSection = selection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_selectedSection == _DebugSection.booking)
              _buildBookingCrudSection()
            else
              _buildTicketCrudSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCrudSection() {
    final userId = _userIdController.text.trim();
    final ticketId = _ticketIdController.text.trim();
    final canRead = userId.isNotEmpty && ticketId.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking CRUD (Debug)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _userIdController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'User ID',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ticketIdController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Ticket ID',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _seatsController,
          decoration: const InputDecoration(
            labelText: 'Seat numbers (comma separated, e.g. A1,A2)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _onCreateBookingPressed,
                child: const Text('Create Booking'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: _onCompletePendingPressed,
                child: const Text('Complete Pending'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _bookingIdController,
          decoration: const InputDecoration(
            labelText: 'Booking document ID (for update/delete)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _bookingStatus,
          decoration: const InputDecoration(
            labelText: 'New status',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'pending', child: Text('pending')),
            DropdownMenuItem(value: 'confirmed', child: Text('confirmed')),
            DropdownMenuItem(value: 'completed', child: Text('completed')),
            DropdownMenuItem(value: 'cancelled', child: Text('cancelled')),
          ],
          onChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _bookingStatus = value;
            });
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _onUpdateBookingPressed,
                child: const Text('Update Status'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _onDeleteBookingPressed,
                child: const Text('Delete Booking'),
              ),
            ),
          ],
        ),
        if (_bookingMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _bookingMessage!,
            style: TextStyle(
              color: _bookingError ? Colors.red : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (!canRead)
          const Text(
            'Isi User ID dan Ticket ID untuk membaca daftar booking.',
            style: TextStyle(color: Colors.black54),
          )
        else
          StreamBuilder<List<BookingModel>>(
            stream: widget.bookingRepository.watchBookings(
              userId: userId,
              ticketId: ticketId,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  'Gagal memuat booking: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CircularProgressIndicator(),
                );
              }
              final bookings = snapshot.data ?? const <BookingModel>[];
              if (bookings.isEmpty) {
                return const Text('Belum ada booking untuk filter ini.');
              }

              return Column(
                children: bookings
                    .map(
                      (booking) => Card(
                        child: ListTile(
                          title: Text(
                            '${booking.seatNumber} • ${booking.status}',
                          ),
                          subtitle: Text(
                            'ID: ${booking.id}\n'
                            'User: ${booking.userId} • Ticket: ${booking.ticketId}',
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTicketCrudSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ticket CRUD (Debug)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _manageTicketIdController,
          decoration: const InputDecoration(
            labelText: 'Ticket ID (required for update/delete)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _trainController,
          decoration: const InputDecoration(
            labelText: 'Train',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _originController,
                decoration: const InputDecoration(
                  labelText: 'Origin',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _dateController,
          decoration: const InputDecoration(
            labelText: 'Date (YYYY-MM-DD HH:mm)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _departTimeController,
                decoration: const InputDecoration(
                  labelText: 'Depart time',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _arriveTimeController,
                decoration: const InputDecoration(
                  labelText: 'Arrive time',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _durationController,
          decoration: const InputDecoration(
            labelText: 'Duration',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _seatClassController,
          decoration: const InputDecoration(
            labelText: 'Seat class',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _oldPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Old price (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _seatsLeftController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Seats left',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _ticketStatus,
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'available', child: Text('available')),
            DropdownMenuItem(value: 'sold_out', child: Text('sold_out')),
            DropdownMenuItem(value: 'inactive', child: Text('inactive')),
          ],
          onChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _ticketStatus = value;
            });
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _onCreateTicketPressed,
                child: const Text('Create Ticket'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _onUpdateTicketPressed,
                child: const Text('Update Ticket'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _onDeleteTicketPressed,
                child: const Text('Delete Ticket'),
              ),
            ),
          ],
        ),
        if (_ticketMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _ticketMessage!,
            style: TextStyle(
              color: _ticketError ? Colors.red : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 12),
        StreamBuilder<List<TicketModel>>(
          stream: widget.bookingRepository.watchAllTickets(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Gagal memuat ticket: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(),
              );
            }
            final tickets = snapshot.data ?? const <TicketModel>[];
            if (tickets.isEmpty) {
              return const Text('Belum ada tiket.');
            }

            return Column(
              children: tickets
                  .map(
                    (ticket) => Card(
                      child: ListTile(
                        title: Text(
                          '${ticket.train} • ${ticket.originStation} → ${ticket.destinationStation}',
                        ),
                        subtitle: Text(
                          'ID: ${ticket.id}\n'
                          'Status: ${ticket.status} • Harga: ${ticket.price ?? 0}',
                        ),
                        isThreeLine: true,
                        onTap: () => _fillTicketForm(ticket),
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onCreateBookingPressed() async {
    final userId = _userIdController.text.trim();
    final ticketId = _ticketIdController.text.trim();
    final seats = _seatsController.text
        .split(',')
        .map((seat) => seat.trim())
        .where((seat) => seat.isNotEmpty)
        .toSet()
        .toList(growable: false);

    if (userId.isEmpty || ticketId.isEmpty || seats.isEmpty) {
      _setBookingMessage(
        'User ID, Ticket ID, dan seat number wajib diisi.',
        isError: true,
      );
      return;
    }

    try {
      await widget.bookingRepository.bookSeats(
        userId: userId,
        ticketId: ticketId,
        seatNumbers: seats,
      );
      _setBookingMessage('Booking berhasil dibuat (${seats.length} seat).');
    } on FirebaseException catch (error) {
      _setBookingMessage('Create gagal: ${error.message}', isError: true);
    } on StateError catch (error) {
      _setBookingMessage('Create gagal: ${error.message}', isError: true);
    }
  }

  Future<void> _onCompletePendingPressed() async {
    final userId = _userIdController.text.trim();
    final ticketId = _ticketIdController.text.trim();
    if (userId.isEmpty || ticketId.isEmpty) {
      _setBookingMessage('User ID dan Ticket ID wajib diisi.', isError: true);
      return;
    }

    try {
      await widget.bookingRepository.verifyAllPending(
        userId: userId,
        ticketId: ticketId,
      );
      _setBookingMessage('Semua booking pending berhasil diubah ke completed.');
    } on FirebaseException catch (error) {
      _setBookingMessage(
        'Complete pending gagal: ${error.message}',
        isError: true,
      );
    }
  }

  Future<void> _onUpdateBookingPressed() async {
    final bookingId = _bookingIdController.text.trim();
    if (bookingId.isEmpty) {
      _setBookingMessage('Booking ID wajib diisi untuk update.', isError: true);
      return;
    }

    try {
      await widget.bookingRepository.updateBookingStatus(
        bookingId: bookingId,
        status: _bookingStatus,
      );
      _setBookingMessage('Status booking berhasil diubah ke $_bookingStatus.');
    } on FirebaseException catch (error) {
      _setBookingMessage('Update gagal: ${error.message}', isError: true);
    }
  }

  Future<void> _onDeleteBookingPressed() async {
    final bookingId = _bookingIdController.text.trim();
    if (bookingId.isEmpty) {
      _setBookingMessage('Booking ID wajib diisi untuk delete.', isError: true);
      return;
    }

    try {
      await widget.bookingRepository.deleteBooking(bookingId: bookingId);
      _setBookingMessage('Booking berhasil dihapus.');
    } on FirebaseException catch (error) {
      _setBookingMessage('Delete gagal: ${error.message}', isError: true);
    }
  }

  Future<void> _onCreateTicketPressed() async {
    final parsed = _parseTicketForm();
    if (parsed == null) {
      return;
    }

    try {
      final ticketId = await widget.bookingRepository.createTicket(
        originStation: parsed.originStation,
        destinationStation: parsed.destinationStation,
        date: parsed.date,
        train: parsed.train,
        status: parsed.status,
        seatClass: parsed.seatClass,
        departTime: parsed.departTime,
        arriveTime: parsed.arriveTime,
        duration: parsed.duration,
        oldPrice: parsed.oldPrice,
        price: parsed.price,
        seatsLeft: parsed.seatsLeft,
      );
      _manageTicketIdController.text = ticketId;
      _setTicketMessage('Ticket berhasil dibuat: $ticketId');
    } on FirebaseException catch (error) {
      _setTicketMessage('Create ticket gagal: ${error.message}', isError: true);
    }
  }

  Future<void> _onUpdateTicketPressed() async {
    final ticketId = _manageTicketIdController.text.trim();
    if (ticketId.isEmpty) {
      _setTicketMessage('Ticket ID wajib diisi untuk update.', isError: true);
      return;
    }

    final parsed = _parseTicketForm();
    if (parsed == null) {
      return;
    }

    try {
      await widget.bookingRepository.updateTicket(
        ticketId: ticketId,
        originStation: parsed.originStation,
        destinationStation: parsed.destinationStation,
        date: parsed.date,
        train: parsed.train,
        status: parsed.status,
        seatClass: parsed.seatClass,
        departTime: parsed.departTime,
        arriveTime: parsed.arriveTime,
        duration: parsed.duration,
        oldPrice: parsed.oldPrice,
        price: parsed.price,
        seatsLeft: parsed.seatsLeft,
      );
      _setTicketMessage('Ticket berhasil diupdate.');
    } on FirebaseException catch (error) {
      _setTicketMessage('Update ticket gagal: ${error.message}', isError: true);
    }
  }

  Future<void> _onDeleteTicketPressed() async {
    final ticketId = _manageTicketIdController.text.trim();
    if (ticketId.isEmpty) {
      _setTicketMessage('Ticket ID wajib diisi untuk delete.', isError: true);
      return;
    }

    try {
      await widget.bookingRepository.deleteTicket(ticketId: ticketId);
      _setTicketMessage('Ticket berhasil dihapus.');
    } on FirebaseException catch (error) {
      _setTicketMessage('Delete ticket gagal: ${error.message}', isError: true);
    }
  }

  _ParsedTicketForm? _parseTicketForm() {
    final train = _trainController.text.trim();
    final origin = _originController.text.trim();
    final destination = _destinationController.text.trim();
    final parsedDate = DateTime.tryParse(_dateController.text.trim());
    final parsedPrice = int.tryParse(_priceController.text.trim());
    final parsedOldPrice = int.tryParse(_oldPriceController.text.trim());
    final parsedSeatsLeft = int.tryParse(_seatsLeftController.text.trim());

    if (train.isEmpty ||
        origin.isEmpty ||
        destination.isEmpty ||
        parsedDate == null ||
        parsedPrice == null ||
        parsedSeatsLeft == null) {
      _setTicketMessage(
        'Isi train, origin, destination, date valid, price, dan seats left.',
        isError: true,
      );
      return null;
    }

    return _ParsedTicketForm(
      train: train,
      originStation: origin,
      destinationStation: destination,
      date: parsedDate,
      status: _ticketStatus,
      seatClass: _seatClassController.text.trim(),
      departTime: _departTimeController.text.trim(),
      arriveTime: _arriveTimeController.text.trim(),
      duration: _durationController.text.trim(),
      oldPrice: parsedOldPrice,
      price: parsedPrice,
      seatsLeft: parsedSeatsLeft,
    );
  }

  void _fillTicketForm(TicketModel ticket) {
    setState(() {
      _manageTicketIdController.text = ticket.id;
      _trainController.text = ticket.train;
      _originController.text = ticket.originStation;
      _destinationController.text = ticket.destinationStation;
      _dateController.text = ticket.date.toIso8601String().substring(0, 16);
      _seatClassController.text = ticket.seatClass ?? '';
      _departTimeController.text = ticket.departTime ?? '';
      _arriveTimeController.text = ticket.arriveTime ?? '';
      _durationController.text = ticket.duration ?? '';
      _oldPriceController.text = ticket.oldPrice?.toString() ?? '';
      _priceController.text = ticket.price?.toString() ?? '';
      _seatsLeftController.text = ticket.seatsLeft?.toString() ?? '';
      _ticketStatus = ticket.status;
    });
  }

  void _setBookingMessage(String message, {bool isError = false}) {
    setState(() {
      _bookingMessage = message;
      _bookingError = isError;
    });
  }

  void _setTicketMessage(String message, {bool isError = false}) {
    setState(() {
      _ticketMessage = message;
      _ticketError = isError;
    });
  }
}

class _ParsedTicketForm {
  _ParsedTicketForm({
    required this.train,
    required this.originStation,
    required this.destinationStation,
    required this.date,
    required this.status,
    required this.seatClass,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.oldPrice,
    required this.price,
    required this.seatsLeft,
  });

  final String train;
  final String originStation;
  final String destinationStation;
  final DateTime date;
  final String status;
  final String seatClass;
  final String departTime;
  final String arriveTime;
  final String duration;
  final int? oldPrice;
  final int? price;
  final int? seatsLeft;
}
