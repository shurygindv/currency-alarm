import 'package:http/http.dart' as http;

// TODO: maybe
class HttpService {
  Future<void> get(String url) {
    http.get(url);
  }
}
