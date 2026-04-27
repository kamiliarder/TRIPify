import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  BookingModel({
    required this.id,
    required this.userId,
    required this.ticketId,
    required this.seatNumber,
    required this.status,
    this.bookingGroupId,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String ticketId;
  final String seatNumber;
  final String status;
  final String? bookingGroupId;
  final DateTime? createdAt;

  factory BookingModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    return BookingModel(
      id: document.id,
      userId: (data['userId'] as Object?)?.toString() ?? '',
      ticketId: (data['ticketId'] as Object?)?.toString() ?? '',
      seatNumber: (data['seatNumber'] as String?) ?? '',
      status: (data['status'] as String?) ?? 'pending',
      bookingGroupId: data['bookingGroupId'] as String?,
      createdAt: _parseDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'ticketId': ticketId,
      'seatNumber': seatNumber,
      'status': status,
      if (bookingGroupId != null) 'bookingGroupId': bookingGroupId,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  static DateTime? _parseDate(dynamic rawDate) {
    if (rawDate is Timestamp) {
      return rawDate.toDate();
    }
    if (rawDate is DateTime) {
      return rawDate;
    }
    if (rawDate is String) {
      return DateTime.tryParse(rawDate);
    }
    return null;
  }
}
