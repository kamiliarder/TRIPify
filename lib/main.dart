import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
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

  static const List<String> recentSearches = [
    'Bandung → Jakarta\n25 Oktober 2024',
    'Bandung → Jakarta\n24 Oktober 2024',
    'Bandung → Jakarta\n23 Oktober 2024',
  ];

  static const List<_BestDealTicket> bestDealTickets = [
    _BestDealTicket(
      trainName: 'Pangandaran 149C',
      seatClass: 'Ekonomi',
      departTime: '9:30',
      arriveTime: '12.20',
      duration: '2j 50m',
      origin: 'Gambir (GMR)',
      destination: 'Jakarta (CGK)',
      price: 'IDR 150.000',
      seatsLeft: '6 kursi tersisa',
    ),
    _BestDealTicket(
      trainName: 'Pangandaran 131B',
      seatClass: 'Ekonomi',
      departTime: '10:00',
      arriveTime: '12.50',
      duration: '2j 50m',
      origin: 'Gambir (GMR)',
      destination: 'Jakarta (CGK)',
      price: 'IDR 175.000',
      seatsLeft: '6 kursi tersisa',
    ),
    _BestDealTicket(
      trainName: 'Papadayan 129C',
      seatClass: 'Eksekutif',
      departTime: '10:55',
      arriveTime: '13.45',
      duration: '2j 50m',
      origin: 'Gambir (GMR)',
      destination: 'Jakarta (CGK)',
      oldPrice: 'IDR 300.000',
      price: 'IDR 250.000',
      seatsLeft: '4 kursi tersisa',
    ),
    _BestDealTicket(
      trainName: 'Parahyangan 139AC',
      seatClass: 'Eksekutif',
      departTime: '14:10',
      arriveTime: '17.00',
      duration: '2j 50m',
      origin: 'Gambir (GMR)',
      destination: 'Jakarta (CGK)',
      price: 'IDR 350.000',
      seatsLeft: '6 kursi tersisa',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    const bookingFormOverlap = 0.0; // You can change the value, but for now its unused
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
                        'Gambir (GMR)',
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
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
          ...bestDealTickets.map(_buildBestDealCard),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildBestDealCard(_BestDealTicket ticket) {
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
                      ticket.trainName,
                      style: const TextStyle(
                        fontSize: 24 * 0.72,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      ticket.seatClass,
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
                      ticket.oldPrice!,
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    ticket.price,
                    style: const TextStyle(
                      color: Color(0xFFF81818),
                      fontSize: 32 * 0.72,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ticket.seatsLeft,
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
              _buildStationColumn(ticket.departTime, ticket.origin),
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
                          ticket.duration,
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
              _buildStationColumn(ticket.arriveTime, ticket.destination),
            ],
          ),
        ],
      ),
    );
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

class _BestDealTicket {
  const _BestDealTicket({
    required this.trainName,
    required this.seatClass,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.origin,
    required this.destination,
    this.oldPrice,
    required this.price,
    required this.seatsLeft,
  });

  final String trainName;
  final String seatClass;
  final String departTime;
  final String arriveTime;
  final String duration;
  final String origin;
  final String destination;
  final String? oldPrice;
  final String price;
  final String seatsLeft;
}
