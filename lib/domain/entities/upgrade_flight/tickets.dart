class Ticket {
  Ticket({
    required this.airportCodes,
    required this.inactive,
    required this.number,
  });

  final List<String> airportCodes;
  final bool inactive;
  final String number;

  factory Ticket.mock() => Ticket(
        airportCodes: ["SVX", "SVO"],
        inactive: false,
        number: "5552302305481",
      );

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        airportCodes: List.castFrom<dynamic, String>(json['airport_codes']),
        inactive: json['inactive'],
        number: json['number'],
      );
}
