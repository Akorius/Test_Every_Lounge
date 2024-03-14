import 'contacts.dart';
import 'passengers.dart';

class CreateOrderObject {
  int loungeId;
  Contacts contacts;
  List<Passengers> passengers;

  CreateOrderObject({
    required this.loungeId,
    required this.contacts,
    required this.passengers,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['loungeId'] = loungeId;
    json['contacts'] = contacts.toJson();
    json['passengers'] = passengers.map((v) => v.toJson()).toList();
    return json;
  }
}
