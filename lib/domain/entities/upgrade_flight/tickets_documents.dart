import 'package:everylounge/domain/entities/upgrade_flight/tickets.dart';

class TicketingDocuments {
  TicketingDocuments({
    required this.tickets,
  });

  final List<Ticket> tickets;

  factory TicketingDocuments.fromJson(Map<String, dynamic> json) => TicketingDocuments(
        tickets: List.from(json['tickets']).map((e) => Ticket.fromJson(e)).toList(),
      );
}
