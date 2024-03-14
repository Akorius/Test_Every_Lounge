import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';

class Document {
  final String? url;
  final AirportDestinationType? type;

  Document({this.url, this.type});

  factory Document.fromJson(Map<dynamic, dynamic> json) => Document(
        url: json['url'] as String,
        type: (json['type'] as String).isNotEmpty == true
            ? AirportDestinationType.values.byName((json['type'] as String).toLowerCase())
            : AirportDestinationType.departure,
      );

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': type?.name,
    };
  }
}
