import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart';
import '../models/ticket_model.dart';

abstract class BookingRepository {
  Stream<List<TicketModel>> watchAvailableTickets();
  Stream<List<TicketModel>> watchAllTickets();
<<<<<<< HEAD
=======
  Stream<Set<String>> watchUnavailableSeats({required String ticketId});
>>>>>>> 1720f050641ae31583f5184049b74f40c1702131

  Stream<List<BookingModel>> watchBookings({
    required String userId,
    required String ticketId,
  });

  Future<void> bookSeats({
    required String userId,
    required String ticketId,
    required List<String> seatNumbers,
  });

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  });

  Future<void> deleteBooking({required String bookingId});

  Future<String> createTicket({
    required String originStation,
    required String destinationStation,
    required DateTime date,
    required String train,
    required String status,
    String? seatClass,
    String? departTime,
    String? arriveTime,
    String? duration,
    int? oldPrice,
    int? price,
    int? seatsLeft,
  });

  Future<void> updateTicket({
    required String ticketId,
    required String originStation,
    required String destinationStation,
    required DateTime date,
    required String train,
    required String status,
    String? seatClass,
    String? departTime,
    String? arriveTime,
    String? duration,
    int? oldPrice,
    int? price,
    int? seatsLeft,
  });

  Future<void> deleteTicket({required String ticketId});

  Future<void> verifyAllPending({
    required String userId,
    required String ticketId,
  });
}

class FirestoreBookingRepository implements BookingRepository {
  FirestoreBookingRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tickets =>
      _firestore.collection('tickets');

  CollectionReference<Map<String, dynamic>> get _bookings =>
      _firestore.collection('bookings');

  @override
  Stream<List<TicketModel>> watchAvailableTickets() {
    return _tickets.where('status', isEqualTo: 'available').snapshots().map((
      snapshot,
    ) {
      final tickets = snapshot.docs
          .map(TicketModel.fromFirestore)
          .toList(growable: false);
      final sortedTickets = [...tickets]
        ..sort((left, right) => left.date.compareTo(right.date));
      return sortedTickets;
    });
  }

  @override
  Stream<List<BookingModel>> watchBookings({
    required String userId,
    required String ticketId,
  }) {
    return _bookings
        .where('userId', isEqualTo: userId)
        .where('ticketId', isEqualTo: ticketId)
        .snapshots()
        .map((snapshot) {
          final bookings = snapshot.docs
              .map(BookingModel.fromFirestore)
              .toList(growable: false);
          final sortedBookings = [...bookings]
            ..sort((left, right) {
              final leftDate =
                  left.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final rightDate =
                  right.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              return rightDate.compareTo(leftDate);
            });
          return sortedBookings;
        });
  }

  @override
  Stream<List<TicketModel>> watchAllTickets() {
    return _tickets.snapshots().map((snapshot) {
      final tickets = snapshot.docs
          .map(TicketModel.fromFirestore)
          .toList(growable: false);
      final sortedTickets = [...tickets]
        ..sort((left, right) => left.date.compareTo(right.date));
      return sortedTickets;
    });
  }

  @override
<<<<<<< HEAD
=======
  Stream<Set<String>> watchUnavailableSeats({required String ticketId}) {
    return _bookings.where('ticketId', isEqualTo: ticketId).snapshots().map((
      snapshot,
    ) {
      final blocked = snapshot.docs
          .map(BookingModel.fromFirestore)
          .where((booking) => booking.status != 'cancelled')
          .map((booking) => booking.seatNumber)
          .toSet();
      return blocked;
    });
  }

  @override
>>>>>>> 1720f050641ae31583f5184049b74f40c1702131
  Future<void> bookSeats({
    required String userId,
    required String ticketId,
    required List<String> seatNumbers,
  }) async {
    final bookingGroupId = _bookings.doc().id;

    await _firestore.runTransaction((transaction) async {
      final seats = seatNumbers.toSet().toList(growable: false);
      final refs = seats
          .map((seatNumber) => _bookings.doc('${ticketId}_$seatNumber'))
          .toList(growable: false);

      final existingDocs = await Future.wait(refs.map(transaction.get));

      for (final document in existingDocs) {
        if (document.exists) {
          final seat = (document.data()?['seatNumber'] as String?) ?? '';
          throw StateError('Seat already booked: $seat');
        }
      }

      for (final seatNumber in seats) {
        final id = '${ticketId}_$seatNumber';
        final booking = BookingModel(
          id: id,
          userId: userId,
          ticketId: ticketId,
          seatNumber: seatNumber,
          status: 'pending',
          bookingGroupId: bookingGroupId,
          createdAt: DateTime.now(),
        );
        transaction.set(_bookings.doc(id), booking.toMap());
      }
    });
  }

  @override
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    await _bookings.doc(bookingId).update({'status': status});
  }

  @override
  Future<void> deleteBooking({required String bookingId}) async {
    await _bookings.doc(bookingId).delete();
  }

  @override
  Future<String> createTicket({
    required String originStation,
    required String destinationStation,
    required DateTime date,
    required String train,
    required String status,
    String? seatClass,
    String? departTime,
    String? arriveTime,
    String? duration,
    int? oldPrice,
    int? price,
    int? seatsLeft,
  }) async {
    final reference = _tickets.doc();
    final ticket = TicketModel(
      id: reference.id,
      originStation: originStation,
      destinationStation: destinationStation,
      date: date,
      train: train,
      status: status,
      seatClass: seatClass,
      departTime: departTime,
      arriveTime: arriveTime,
      duration: duration,
      oldPrice: oldPrice,
      price: price,
      seatsLeft: seatsLeft,
    );
    await reference.set(ticket.toMap());
    return reference.id;
  }

  @override
  Future<void> updateTicket({
    required String ticketId,
    required String originStation,
    required String destinationStation,
    required DateTime date,
    required String train,
    required String status,
    String? seatClass,
    String? departTime,
    String? arriveTime,
    String? duration,
    int? oldPrice,
    int? price,
    int? seatsLeft,
  }) async {
    final ticket = TicketModel(
      id: ticketId,
      originStation: originStation,
      destinationStation: destinationStation,
      date: date,
      train: train,
      status: status,
      seatClass: seatClass,
      departTime: departTime,
      arriveTime: arriveTime,
      duration: duration,
      oldPrice: oldPrice,
      price: price,
      seatsLeft: seatsLeft,
    );
    await _tickets.doc(ticketId).update(ticket.toMap());
  }

  @override
  Future<void> deleteTicket({required String ticketId}) async {
    await _tickets.doc(ticketId).delete();
  }

  @override
  Future<void> verifyAllPending({
    required String userId,
    required String ticketId,
  }) async {
    final querySnapshot = await _bookings
        .where('userId', isEqualTo: userId)
        .where('ticketId', isEqualTo: ticketId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (querySnapshot.docs.isEmpty) {
      return;
    }

    await _firestore.runTransaction((transaction) async {
      for (final booking in querySnapshot.docs) {
        transaction.update(booking.reference, {'status': 'completed'});
      }
    });
  }
}
