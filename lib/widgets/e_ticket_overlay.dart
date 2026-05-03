import 'package:flutter/material.dart';

class ETicketOverlayData {
  const ETicketOverlayData({
    required this.bookingSequence,
    required this.origin,
    required this.destination,
    required this.bookingDate,
    required this.departureTime,
    required this.passengerName,
    required this.seatClass,
    required this.trainName,
    required this.seatLabel,
  });

  final int bookingSequence;
  final String origin;
  final String destination;
  final String bookingDate;
  final String departureTime;
  final String passengerName;
  final String seatClass;
  final String trainName;
  final String seatLabel;
}

Future<void> showETicketOverlay({
  required BuildContext context,
  required ETicketOverlayData data,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.45),
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        backgroundColor: Colors.transparent,
        child: ETicketOverlayCard(
          data: data,
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    },
  );
}

class ETicketOverlayCard extends StatelessWidget {
  const ETicketOverlayCard({
    required this.data,
    required this.onClose,
    super.key,
  });

  final ETicketOverlayData data;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ticketCode = formatTicketCode(data.bookingSequence);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(13, 10, 13, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: onClose,
              child: const SizedBox(
                width: 22,
                height: 22,
                child: Icon(Icons.close, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text('Kode Tiket', style: TextStyle(fontSize: 24 * 0.57)),
          const SizedBox(height: 4),
          Text(
            ticketCode,
            style: const TextStyle(
              fontSize: 36 * 0.57,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0451C4),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fieldTitleValue('Dari', data.origin.toUpperCase()),
              _fieldTitleValue(
                'Ke',
                data.destination.toUpperCase(),
                alignRight: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fieldTitleValue('TANGGAL', data.bookingDate),
              _fieldTitleValue(
                'KEBERANGKATAN',
                data.departureTime,
                alignRight: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fieldTitleValue('PELANGGAN', data.passengerName),
              _fieldTitleValue('KELAS', data.seatClass, alignRight: true),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fieldTitleValue('KERETA', data.trainName),
              _fieldTitleValue(
                'TEMPAT DUDUK',
                data.seatLabel,
                alignRight: true,
                valueColor: const Color(0xFF0451C4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fieldTitleValue(
    String title,
    String value, {
    bool alignRight = false,
    Color? valueColor,
  }) {
    final crossAxis = alignRight
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: crossAxis,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0x80464646)),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

String formatTicketCode(int bookingSequence) {
  final safeSequence = bookingSequence < 1 ? 1 : bookingSequence;
  final padded = safeSequence.toString().padLeft(5, '0');
  return 'TRP-$padded';
}
