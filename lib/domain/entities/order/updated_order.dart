import 'order_status.dart';

class UpdatedOrder {
  final int id;
  final OrderStatus status;
  final int? qrId;

  UpdatedOrder({
    required this.id,
    required this.status,
    required this.qrId,
  });

  factory UpdatedOrder.fromJson(Map<String, dynamic> map) {
    return UpdatedOrder(
      id: map['id'] as int,
      status: OrderExtension.fromInt(map['status'] as int),
      qrId: map['qr_id'] as int?,
    );
  }

  @override
  String toString() {
    return 'UpdatedOrder{id: $id, status: $status, qrId: $qrId}';
  }
}
