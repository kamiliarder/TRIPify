import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart';
import '../models/ticket_model.dart';

abstract class BookingRepository {
  Stream<List<TicketModel>> watchAvailableTickets();

  Future<void> bookSeats({
    required String userId,
    required String ticketId,
    required List<String> seatNumbers,
  });

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
