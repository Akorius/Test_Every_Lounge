import 'package:translit/translit.dart' as tr;

class Translitor {
  String translit(String source) {
    source = source.replaceAll("ай", "ay");
    source = source.replaceAll("ей", "ey");
    source = source.replaceAll("ий", "iy");
    source = source.replaceAll("ой", "oy");
    source = source.replaceAll("уй", "uy");
    source = source.replaceAll("эй", "ey");
    source = source.replaceAll("юй", "yuy");
    source = source.replaceAll("яй", "yay");

    source = source.replaceAll("АЙ", "AY");
    source = source.replaceAll("ЕЙ", "EY");
    source = source.replaceAll("ИЙ", "IY");
    source = source.replaceAll("ОЙ", "OY");
    source = source.replaceAll("УЙ", "UY");
    source = source.replaceAll("ЭЙ", "EY");
    source = source.replaceAll("ЮЙ", "YUY");
    source = source.replaceAll("ЯЙ", "YAY");

    source = source.replaceAll("Ай", "Ay");
    source = source.replaceAll("Ей", "Ey");
    source = source.replaceAll("Ий", "Iy");
    source = source.replaceAll("Ой", "Oy");
    source = source.replaceAll("Уй", "Uy");
    source = source.replaceAll("Эй", "Ey");
    source = source.replaceAll("Юй", "YUy");
    source = source.replaceAll("Яй", "YAy");

    source = source.replaceAll("Ё", "E"); // кириллица
    source = source.replaceAll("ё", "e"); // кириллица
    source = source.replaceAll("Ë", "E"); //латинская
    source = source.replaceAll("ë", "e"); //латинская
    source = source.replaceAll("Ж", "ZH");
    source = source.replaceAll("Э", "E");
    source = source.replaceAll("э", "e");
    source = source.replaceAll("Ю", "YU");
    source = source.replaceAll("Я", "YA");
    source = source.replaceAll("Й", "I");
    source = source.replaceAll("й", "i");
    source = source.replaceAll("Х", "KH");
    source = source.replaceAll("х", "kh");
    source = source.replaceAll("Ц", "TS");
    source = source.replaceAll("ц", "ts");
    source = source.replaceAll("Ш", "SH");
    source = source.replaceAll("ш", "sh");
    source = source.replaceAll("Щ", "SCH");
    source = source.replaceAll("щ", "sch");
    source = tr.Translit().toTranslit(source: source);
    source = source.replaceAll("Ь", "");
    source = source.replaceAll("ь", "");
    source = source.replaceAll("Ъ", "");
    source = source.replaceAll("ъ", "");
    return source;
  }
}
