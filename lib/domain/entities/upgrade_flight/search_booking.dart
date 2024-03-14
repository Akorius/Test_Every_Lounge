import 'package:everylounge/domain/entities/upgrade_flight/leg.dart';
import 'package:everylounge/domain/entities/upgrade_flight/passenger.dart';
import 'package:everylounge/domain/entities/upgrade_flight/segment.dart';

class SearchedBooking {
  SearchedBooking({
    required this.isAward,
    required this.legs,
    required this.passengers,
    required this.pnrDate,
    required this.pnrKey,
    required this.pnrLocator,
    required this.posCountry,
  });

  final bool isAward;
  final List<Leg> legs;
  final List<PassengerFU> passengers;
  final String pnrDate;
  final String pnrKey;
  final String pnrLocator;
  final String posCountry;

  SearchedBooking.mock()
      : this(
          isAward: false,
          legs: [
            Leg(segments: [
              Segment.mock(flightNumber: 'UT 813'),
              Segment.mock(flightNumber: 'UT 814'),
            ]),
            Leg(segments: [
              Segment.mock(flightNumber: 'UT 812'),
              Segment.mock(flightNumber: 'UT 816'),
            ]),
          ],
          passengers: [
            PassengerFU.mock(),
            PassengerFU.mock(firstName: 'AFANASENKO'),
          ],
          pnrDate: "2023-05-23",
          pnrKey:
              "bba4db76f22a67e070db29df5854e57f990dde8fee74ca78d0e461c6a9e90bb78d294ae37724890dd1652f008ef22893f3a3c1211ffae19a5a897cb2d9c1b8b9",
          pnrLocator: "NFVP91",
          posCountry: "RU",
        );

  factory SearchedBooking.fromJson(Map<String, dynamic> json) => SearchedBooking(
        isAward: json['is_award'],
        legs: List.from(json['legs']).map((e) => Leg.fromJson(e)).toList(),
        passengers: List.from(json['passengers']).map((e) => PassengerFU.fromJson(e)).toList(),
        pnrDate: json['pnr_date'],
        pnrKey: json['pnr_key'],
        pnrLocator: json['pnr_locator'],
        posCountry: json['pos_country'],
      );
}
