import 'bin.dart';
import 'card_identifier_result.dart';
import 'card_type.dart';

class BankCardIdentifier {
  BankCardIdentifierResult identify(String bin, List<Bin> fetchedBins) {
    if (bin.length != 6) throw Exception("Длинна БИН должна быть 6");
    int index = -1;
    index = fetchedBins.indexWhere((element) => element.bin == bin);
    if (index == -1) {
      return BankCardIdentifierResult(BankCardType.other, 0, 0);
    } else {
      final Bin bin = fetchedBins[index];
      return BankCardIdentifierResult(bin.type, bin.selfPasses, bin.guestPasses);
    }
  }
}
