class StringUtil {
  static String nullStr(dynamic aux) {
    if (aux == null) {
      return "";
    }
    return aux.toString();
  }
}
