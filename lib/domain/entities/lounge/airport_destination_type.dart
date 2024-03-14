///Типы аэропорта по отношению к рейсу
enum AirportDestinationType {
  departure,
  arrival,
  any

  /// обозначает что рейс может быть и departure, и arrival. не транзит. для транзита флаг is_transit
}

enum InnerDestinationType { departure, arrival, transit }
