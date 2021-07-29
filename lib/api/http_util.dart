class HttpUtil {

  static bool abnormal(int code) {
    return code < 200 || code >= 300;
  }

  static bool normal(int code) {
    return code >= 200 && code < 300;
  }
}
