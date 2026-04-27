import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  TicketModel({
    required this.id,
    required this.originStation,
    required this.destinationStation,
    required this.date,
    required this.train,
    required this.status,
    this.seatClass,
    this.departTime,
    this.arriveTime,
    this.duration,
    this.oldPrice,
    this.price,
    this.seatsLeft,
  });

  final String id;
  final String originStation;
  final String destinationStation;
  final DateTime date;
  final String train;
  final String status;
  final String? seatClass;
  final String? departTime;
  final String? arriveTime;
  final String? duration;
  final int? oldPrice;
  final int? price;
  final int? seatsLeft;

  factory TicketModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    return TicketModel(
      id: document.id,
      originStation: (data['originStation'] as String?) ?? '',
      destinationStation: (data['destinationStation'] as String?) ?? '',
      date: _parseDate(data['date']),
      train: (data['train'] as String?) ?? '',
      status: (data['status'] as String?) ?? 'available',
      seatClass: data['seatClass'] as String?,
      departTime: data['departTime'] as String?,
      arriveTime: data['arriveTime'] as String?,
      duration: data['duration'] as String?,
      oldPrice: _toInt(data['oldPrice']),
      price: _toInt(data['price']),
      seatsLeft: _toInt(data['seatsLeft']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originStation': originStation,
      'destinationStation': destinationStation,
      'date': Timestamp.fromDate(date),
      'train': train,
      'status': status,
      if (seatClass != null) 'seatClass': seatClass,
      if (departTime != null) 'departTime': departTime,
      if (arriveTime != null) 'arriveTime': arriveTime,
      if (duration != null) 'duration': duration,
      if (oldPrice != null) 'oldPrice': oldPrice,
      if (price != null) 'price': price,
      if (seatsLeft != null) 'seatsLeft': seatsLeft,
    };
  }

  static DateTime _parseDate(dynamic rawDate) {
    if (rawDate is Timestamp) {
      return rawDate.toDate();
    }
    if (rawDate is DateTime) {
      return rawDate;
    }
    if (rawDate is String) {
      return DateTime.tryParse(rawDate) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }
}
