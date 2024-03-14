import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/upgrade_flight/tickets.dart';
import 'package:everylounge/domain/entities/upgrade_flight/tickets_documents.dart';

class PassengerFU extends Equatable {
  String firstName;
  String lastName;
  String refNumber;
  PaxType paxType;
  final TicketingDocuments? ticketingDocuments;

  ///при поиске билета для upgradeFlight
  ///используется в SearchedBooking
  PassengerFU({
    required this.firstName,
    required this.lastName,
    required this.refNumber,
    required this.paxType,
    this.ticketingDocuments,
  });

  factory PassengerFU.mock({String? firstName, PaxType? paxType}) => PassengerFU(
        firstName: firstName ?? 'DUBYNINA',
        lastName: ' EKATERINA',
        refNumber: '12',
        paxType: paxType ?? PaxType.adult,
        ticketingDocuments: TicketingDocuments(tickets: [Ticket.mock()]),
      );

  factory PassengerFU.fromJson(Map<String, dynamic> json) => PassengerFU(
        firstName: json['first_name'],
        lastName: json['last_name'],
        refNumber: json['ref_number'],
        paxType: json['pax_type'] == 'ADULT' ? PaxType.adult : PaxType.child,
        ticketingDocuments: TicketingDocuments.fromJson(json['ticketing_documents']),
      );

  @override
  List<Object?> get props => [firstName, lastName, refNumber, paxType, ticketingDocuments];
}

enum PaxType { adult, child }
