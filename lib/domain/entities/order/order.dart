import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/order/aeroflot/aeroflot_data.dart';
import 'package:everylounge/domain/entities/order/aeroflot/aeroflot_leg.dart';
import 'package:everylounge/domain/entities/order/aeroflot/aeroflot_segment.dart';
import 'package:everylounge/domain/entities/order/contacts.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/domain/entities/order/passenger.dart';
import 'package:everylounge/domain/entities/order/premium/flight_info.dart';
import 'package:everylounge/domain/entities/order/qr.dart';
import 'package:everylounge/domain/entities/order/updated_order.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/domain/entities/protobuf/order.pb.dart' as proto;

class Order {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String airportCode;
  final num amount;
  final OrderStatus status;
  final Lounge lounge;
  final PremiumService? premiumService;
  final String? transactionNumber;
  final Contacts contacts;
  final List<Passenger> passengers;
  final String text;
  final String internalId;
  final String pnr;
  final String? pnrTransaction;
  final String description;
  final Qr? qr;
  final int? qrId;
  final String validTill;
  final int userType;
  final OrderType? type;
  final String? chekinUrl;
  final AeroflotData? aeroflotData;

  ///for premium
  final List<FlightInfo>? flightInfo;

  final ActiveBank? bank;
  final AcquiringType? acquiringType;

  Order({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.airportCode,
    required this.amount,
    required this.status,
    required this.lounge,
    required this.premiumService,
    required this.transactionNumber,
    required this.contacts,
    required this.passengers,
    required this.text,
    required this.internalId,
    required this.pnr,
    required this.pnrTransaction,
    required this.description,
    required this.qr,
    required this.validTill,
    required this.userType,
    required this.qrId,
    required this.type,
    this.chekinUrl,
    this.aeroflotData,
    this.flightInfo,
    this.bank,
    this.acquiringType,
  });

  bool get showPasses =>
      acquiringType != null ? acquiringType == AcquiringType.passages : bankForPaymentByPasses(bank) && transactionNumber == null;

  bool maskPNR({
    required bool isPartnerOrg,
  }) {
    switch (status) {
      case OrderStatus.initPay:
      case OrderStatus.created:
      case OrderStatus.confirmed:
      case OrderStatus.bankPaid:
        return isPartnerOrg || pnr.startsWith("PPG");
      case OrderStatus.paid:
      case OrderStatus.completed:
      case OrderStatus.cancelled:
      case OrderStatus.visited:
      case OrderStatus.expired:
      default:
        return false;
    }
  }

  String serviceName() {
    switch (type) {
      case OrderType.upgrade:
        var fNumbers = '';
        aeroflotData?.legs?.first.segments.forEach((element) {
          fNumbers = fNumbers + (fNumbers.isEmpty ? '' : ', ') + element.flightNumber;
        });
        return 'Повышение класса обслуживания на рейс: $fNumbers';
      case OrderType.premium:
        return premiumService?.name ?? 'Премиум услуги аэропорта';
      case OrderType.lounge:
      default:
        return lounge.name;
    }
  }

  Order updateFromUpdated(UpdatedOrder updatedOrder) {
    return Order(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        airportCode: airportCode,
        amount: amount,
        status: updatedOrder.status,
        lounge: lounge,
        premiumService: premiumService,
        transactionNumber: transactionNumber,
        contacts: contacts,
        passengers: passengers,
        text: text,
        internalId: internalId,
        pnr: pnr,
        description: description,
        qr: qr,
        validTill: validTill,
        userType: userType,
        qrId: updatedOrder.qrId,
        type: type,
        chekinUrl: chekinUrl,
        aeroflotData: aeroflotData,
        flightInfo: flightInfo,
        bank: bank,
        acquiringType: acquiringType,
        pnrTransaction: pnrTransaction);
  }

  Order updateFromProto({
    required proto.Order order,
  }) {
    return Order(
      id: order.id,
      createdAt: order.createdAt.toDateTime(toLocal: true),
      updatedAt: order.updatedAt.toDateTime(toLocal: true),
      airportCode: order.airport,
      amount: order.amount,
      status: OrderExtension.fromInt(order.status.value),
      lounge: lounge.copyWith(
        name: order.serviceName,
        id: order.serviceId,
        organization: order.organization,
      ),
      premiumService: premiumService,
      transactionNumber: order.payId,
      contacts: Contacts(
        name: order.contact.name,
        phone: order.contact.phone,
        email: order.contact.email,
      ),
      passengers: passengers,
      //пассажиры из grpc всегда пустые
      text: text,
      // не приходит
      internalId: order.internalId,
      pnr: pnr,
      pnrTransaction: pnrTransaction,
      // не приходит
      description: description,
      // не приходит
      qr: qr,
      // не нужен
      qrId: order.qr.id,
      validTill: order.validTill,
      userType: userType,
      // не приходит
      type: type,
      bank: bank,

      chekinUrl: chekinUrl,
      aeroflotData: aeroflotData,
      flightInfo: flightInfo,
      acquiringType: order.hasAcquiringType() == true ? AcquiringType.values[order.acquiringType.value] : null,
    );
  }

  Order.mock({OrderType? type = OrderType.lounge})
      : this(
            id: 100,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            airportCode: 'ROS',
            amount: 15000,
            status: OrderStatus.paid,
            lounge: Lounge.mock(),
            premiumService: PremiumService.mock(),
            transactionNumber: "123",
            contacts: Contacts(name: "Иван Иванович"),
            passengers: [
              Passenger(
                firstName: "EKATERINA",
                middleName: "Иванович",
                lastName: "DUBYNINA",
                age: 123,
                segmentNumber: 12,
              ),
              Passenger(
                firstName: "EKATERINA",
                middleName: "Иванович",
                lastName: "AFANAC",
                age: 123,
                segmentNumber: 14,
              ),
            ],
            text: "Text 12345 text",
            internalId: "123",
            pnr: "ELE3B3Y",
            pnrTransaction: '',
            // description: "Проход в зал",
            description: "Meet and assist",
            qr: null,
            validTill: DateTime.now().toIso8601String(),
            userType: 1,
            qrId: 0,
            type: type,
            bank: ActiveBank.tochka,
            acquiringType: AcquiringType.tinkoff,
            aeroflotData: AeroflotData(
              legs: [
                AeroflotLeg(
                  segments: [
                    AeroflotSegment.mock(segmentNumber: 11),
                    AeroflotSegment.mock(segmentNumber: 12),
                  ],
                ),
                AeroflotLeg(
                  segments: [
                    AeroflotSegment.mock(segmentNumber: 13),
                    AeroflotSegment.mock(segmentNumber: 14),
                  ],
                ),
              ],
            ),
            flightInfo: [
              FlightInfo(
                airportCode: "RTE",
                airportName: "NAMEFROM",
                airportCity: "ROSTOV",
                date: DateTime.now(),
                number: "EGSH",
                type: AirportDestinationType.arrival,
              ),
              FlightInfo(
                airportCode: "YETE",
                airportName: "NAMETO",
                airportCity: "PITER",
                date: DateTime.now(),
                number: "ETER",
                type: AirportDestinationType.departure,
              ),
            ]);

  factory Order.fromJson(Map<dynamic, dynamic> json) => Order(
        id: json['id'] as int,
        createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
        updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
        airportCode: json['airport_code'] as String,
        amount: json['amount'],
        status: OrderExtension.fromInt(json['status'] as int),
        lounge: Lounge.fromJson(json['lounge']),
        premiumService: json['premium_service'] == null ? null : PremiumService.fromJson(json['premium_service']),
        transactionNumber: json['transaction_number'],
        contacts: Contacts.fromJson(json['contacts']),
        passengers: (json['passengers'] as List<dynamic>).map((e) => Passenger.fromJson(e)).toList(),
        text: json['text'] as String,
        internalId: json['internal_id'] as String,
        pnr: json['pnr'] as String,
        pnrTransaction: json['pnr_transaction'] as String?,
        description: json['description'] as String,
        qr: json['qr'] == null ? null : Qr.fromJson(json['qr'] as Map<String, dynamic>),
        validTill: json['valid_till'] as String,
        userType: json['user_type'] as int,
        qrId: json['qr_id'],
        type: json['type'] == null ? null : OrderTypeExtension.fromInt(json['type'] as int),
        chekinUrl: json['chekin_url'],
        acquiringType: json['acquiring_type'] != null ? AcquiringType.values[(json['acquiring_type'])] : AcquiringType.unknown,
        aeroflotData: json['aeroflot_data'] != null ? AeroflotData.fromJson(json['aeroflot_data']) : null,
        flightInfo: json['flight_info'] != null
            ? (json['flight_info'] as List<dynamic>).map((e) => FlightInfo.fromJson(e)).toList().reversed.toList()
            : null,
        bank: ActiveBankExtension.fromInt(json['bank']),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'airport_code': airportCode,
      'amount': amount,
      'status': status.index,
      'lounge': lounge.toJson(),
      'premium_service': premiumService?.toJson(),
      'transaction_number': transactionNumber,
      'contacts': contacts.toJson(),
      'passengers': passengers.map((e) => e.toJson()).toList(),
      'text': text,
      'internal_id': internalId,
      'pnr': pnr,
      'pnr_transaction': pnrTransaction,
      'description': description,
      'qr': qr?.toJson(),
      'qr_id': qrId,
      'valid_till': validTill,
      'user_type': userType,
      'type': type?.index,
      'chekin_url': chekinUrl,
      'aeroflot_data': aeroflotData?.toJson(),
      'flight_info': flightInfo?.map((e) => e.toJson()).toList(),
      'bank': bank?.index,
      'acquiring_type': acquiringType?.index
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          airportCode == other.airportCode &&
          amount == other.amount &&
          status == other.status &&
          lounge == other.lounge &&
          premiumService == other.premiumService &&
          transactionNumber == other.transactionNumber &&
          contacts == other.contacts &&
          passengers == other.passengers &&
          text == other.text &&
          internalId == other.internalId &&
          pnr == other.pnr &&
          pnrTransaction == other.pnrTransaction &&
          description == other.description &&
          qr == other.qr &&
          qrId == other.qrId &&
          validTill == other.validTill &&
          userType == other.userType &&
          acquiringType == other.acquiringType &&
          type == other.type;

  @override
  int get hashCode =>
      id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      airportCode.hashCode ^
      amount.hashCode ^
      status.hashCode ^
      lounge.hashCode ^
      premiumService.hashCode ^
      transactionNumber.hashCode ^
      contacts.hashCode ^
      passengers.hashCode ^
      text.hashCode ^
      internalId.hashCode ^
      pnr.hashCode ^
      pnrTransaction.hashCode ^
      description.hashCode ^
      qr.hashCode ^
      qrId.hashCode ^
      validTill.hashCode ^
      userType.hashCode ^
      acquiringType.hashCode ^
      type.hashCode;

  @override
  String toString() {
    return 'Order{id: $id, status: $status}';
  }

  Order copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? airportCode,
    num? amount,
    OrderStatus? status,
    Lounge? lounge,
    PremiumService? premiumService,
    String? transactionNumber,
    Contacts? contacts,
    List<Passenger>? passengers,
    String? text,
    String? internalId,
    String? pnr,
    String? pnrTransaction,
    String? description,
    Qr? qr,
    int? qrId,
    String? validTill,
    int? userType,
    OrderType? type,
    String? chekinUrl,
    AeroflotData? aeroflotData,
    List<FlightInfo>? flightInfo,
    ActiveBank? bank,
    AcquiringType? acquiringType,
  }) {
    return Order(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      airportCode: airportCode ?? this.airportCode,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      lounge: lounge ?? this.lounge,
      premiumService: premiumService ?? this.premiumService,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      contacts: contacts ?? this.contacts,
      passengers: passengers ?? this.passengers,
      text: text ?? this.text,
      internalId: internalId ?? this.internalId,
      pnr: pnr ?? this.pnr,
      pnrTransaction: pnrTransaction ?? this.pnrTransaction,
      description: description ?? this.description,
      qr: qr ?? this.qr,
      qrId: qrId ?? this.qrId,
      validTill: validTill ?? this.validTill,
      userType: userType ?? this.userType,
      type: type ?? this.type,
      chekinUrl: chekinUrl ?? this.chekinUrl,
      aeroflotData: aeroflotData ?? this.aeroflotData,
      flightInfo: flightInfo ?? this.flightInfo,
      bank: bank ?? this.bank,
      acquiringType: acquiringType ?? this.acquiringType,
    );
  }
}

class OrderData {
  final List<Order> listOrders;
  final int totalItems;

  OrderData({
    required this.listOrders,
    required this.totalItems,
  });

  factory OrderData.fromJson(Map<dynamic, dynamic> json) => OrderData(
        listOrders: json['listOrders'] as List<Order>,
        totalItems: json['totalItems'] as int,
      );
}
