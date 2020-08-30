import 'package:http/http.dart' as http;

// TODO
class HttpService {
  Future<void> get(String url) {
    http.get(url);
  }
}
