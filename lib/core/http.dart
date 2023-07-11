import 'package:http/http.dart' as http;

import 'api_routes.dart';

class Http {
  static get(String request) {
    return http.get(
      Uri.parse(APIRoutesEnum.baseUrl.routeName + request),
      headers: {"Content-Type": "application/json"},
    ).timeout(const Duration(seconds: 30));
  }

  static post({required String requestLink, required Object? data}) {
    var link = APIRoutesEnum.baseUrl.routeName + requestLink;
    return http
        .post(Uri.parse(link),
            headers: {"Content-Type": "application/json"}, body: data)
        .timeout(const Duration(seconds: 30));
  }
}
