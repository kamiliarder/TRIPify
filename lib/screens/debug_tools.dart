import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/models/booking_model.dart';
import '../data/models/ticket_model.dart';
import '../data/repositories/firestore_booking_repository.dart';

enum DebugSection { booking, ticket }

class DebugToolsScreen extends StatefulWidget {
  const DebugToolsScreen({
    required this.bookingRepository,
    required this.initialSection,
    super.key,
  });

  final BookingRepository bookingRepository;
  final DebugSection initialSection;

  @override
  State<DebugToolsScreen> createState() => _DebugToolsScreenState();
}

class _DebugToolsScreenState extends State<DebugToolsScreen> {
  static const List<String> _indonesianStations = [
    'Jakarta (CGK)',
    'Bandung (BD)',
    'Surabaya (SBY)',
    'Yogyakarta (YIA)',
    'Medan (KNO)',
    'Semarang (SRG)',
    'Makassar (UPG)',
    'Denpasar (DPS)',
    'Palembang (PLM)',
    'Balikpapan (BPN)',
    'Banjarmasin (BJM)',
    'Jambi (JSM)',
    'Riau (PKU)',
    'Padang (PDG)',
    'Pontianak (PNK)',
    'Samarinda (SRI)',
    'Kupang (KOE)',
    'Manado (MDC)',
    'Bandarlampung (TKG)',
    'Malang (MLG)',
    'Solo (SLO)',
    'Sleman (SLM)',
    'Kediri (KDI)',
    'Jombang (JMB)',
    'Gresik (GSK)',
    'Tuban (TBN)',
    'Cilacap (CLP)',
    'Purwokerto (PWK)',
    'Pekalongan (PKL)',
    'Tegal (TGL)',
    'Cirebon (CRB)',
    'Indramayu (IDM)',
    'Karawang (KRW)',
    'Bekasi (BKS)',
    'Depok (DPK)',
    'Tangerang (TNG)',
    'Serang (SRG)',
    'Bogor (BGR)',
  ];

  late DebugSection _selectedSection;

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
  String _ticketOrigin = 'Bandung (BD)';
  String _ticketDestination = 'Surabaya (SBY)';
  DateTime _ticketDate = DateTime.now();
  TimeOfDay _departTime = const TimeOfDay(hour: 9, minute: 30);
  TimeOfDay _arriveTime = const TimeOfDay(hour: 12, minute: 20);
  final TextEditingController _durationController = TextEditingController(
    text: '2j 50m',
  );
  final TextEditingController _seatClassController = TextEditingController(
    text: 'Ekonomi',
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
    _durationController.dispose();
    _seatClassController.dispose();
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
            SegmentedButton<DebugSection>(
              segments: const [
                ButtonSegment<DebugSection>(
                  value: DebugSection.booking,
                  icon: Icon(Icons.bookmark_outline),
                  label: Text('Booking'),
                ),
                ButtonSegment<DebugSection>(
                  value: DebugSection.ticket,
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
            if (_selectedSection == DebugSection.booking)
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
        _buildStationCard(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildDatePickerField()),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimePickerField(
                label: 'Berangkat',
                value: _departTime,
                onPressed: _pickDepartTime,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimePickerField(
                label: 'Tiba',
                value: _arriveTime,
                onPressed: _pickArriveTime,
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

  Widget _buildStationCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
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
                InkWell(
                  onTap: () => _editTicketStation(isOrigin: true),
                  child: Text(
                    _ticketOrigin,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
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
                InkWell(
                  onTap: () => _editTicketStation(isOrigin: false),
                  child: Text(
                    _ticketDestination,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                final temp = _ticketOrigin;
                _ticketOrigin = _ticketDestination;
                _ticketDestination = temp;
              });
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.swap_vert, color: Colors.grey, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: _pickTicketDate,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tanggal',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              '${_ticketDate.year}-${_twoDigits(_ticketDate.month)}-${_twoDigits(_ticketDate.day)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required TimeOfDay value,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(value),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editTicketStation({required bool isOrigin}) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => _StationPickerDialog(
        stations: _indonesianStations,
        title: isOrigin ? 'Pilih Stasiun Asal' : 'Pilih Stasiun Tujuan',
      ),
    );
    if (selected != null) {
      setState(() {
        if (isOrigin) {
          _ticketOrigin = selected;
        } else {
          _ticketDestination = selected;
        }
      });
    }
  }

  Future<void> _pickTicketDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _ticketDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _ticketDate = picked;
      });
    }
  }

  Future<void> _pickDepartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _departTime,
    );
    if (picked != null) {
      setState(() {
        _departTime = picked;
      });
    }
  }

  Future<void> _pickArriveTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _arriveTime,
    );
    if (picked != null) {
      setState(() {
        _arriveTime = picked;
      });
    }
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
    final parsedPrice = int.tryParse(_priceController.text.trim());
    final parsedOldPrice = int.tryParse(_oldPriceController.text.trim());
    final parsedSeatsLeft = int.tryParse(_seatsLeftController.text.trim());
    final depart = _formatTime(_departTime);
    final arrive = _formatTime(_arriveTime);
    final date = DateTime(
      _ticketDate.year,
      _ticketDate.month,
      _ticketDate.day,
      _departTime.hour,
      _departTime.minute,
    );

    if (train.isEmpty || parsedPrice == null || parsedSeatsLeft == null) {
      _setTicketMessage(
        'Isi train, price, dan seats left dengan nilai valid.',
        isError: true,
      );
      return null;
    }

    return _ParsedTicketForm(
      train: train,
      originStation: _ticketOrigin,
      destinationStation: _ticketDestination,
      date: date,
      status: _ticketStatus,
      seatClass: _seatClassController.text.trim(),
      departTime: depart,
      arriveTime: arrive,
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
      _ticketOrigin = ticket.originStation;
      _ticketDestination = ticket.destinationStation;
      _ticketDate = ticket.date;
      _departTime =
          _parseTime(ticket.departTime) ?? const TimeOfDay(hour: 9, minute: 30);
      _arriveTime =
          _parseTime(ticket.arriveTime) ??
          const TimeOfDay(hour: 12, minute: 20);
      _durationController.text = ticket.duration ?? '';
      _seatClassController.text = ticket.seatClass ?? '';
      _oldPriceController.text = ticket.oldPrice?.toString() ?? '';
      _priceController.text = ticket.price?.toString() ?? '';
      _seatsLeftController.text = ticket.seatsLeft?.toString() ?? '';
      _ticketStatus = ticket.status;
    });
  }

  TimeOfDay? _parseTime(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final parts = raw.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  String _twoDigits(int value) {
    return value < 10 ? '0$value' : '$value';
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

class _StationPickerDialog extends StatefulWidget {
  const _StationPickerDialog({required this.stations, required this.title});

  final List<String> stations;
  final String title;

  @override
  State<_StationPickerDialog> createState() => _StationPickerDialogState();
}

class _StationPickerDialogState extends State<_StationPickerDialog> {
  late List<String> filteredStations;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredStations = widget.stations;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterStations(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStations = widget.stations;
      } else {
        filteredStations = widget.stations
            .where(
              (station) => station.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    onChanged: _filterStations,
                    decoration: InputDecoration(
                      hintText: 'Cari stasiun...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredStations.isEmpty
                  ? const Center(
                      child: Text(
                        'Stasiun tidak ditemukan',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredStations.length,
                      itemBuilder: (context, index) {
                        final station = filteredStations[index];
                        return ListTile(
                          title: Text(station),
                          onTap: () => Navigator.of(context).pop(station),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('Batal'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
