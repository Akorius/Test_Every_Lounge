class JsonUtils {
  static String clean(String stringJson) {
    stringJson = stringJson.replaceAll("\\n", "");
    stringJson = stringJson.replaceAll('\\"', '"');
    stringJson = stringJson.replaceAll('"{', "{");
    stringJson = stringJson.replaceAll('}"', '}');
    return stringJson;
  }
}
