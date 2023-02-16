import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Network {
  // late final String url;
  // Network({required this.url});
  late final url;
  Network(
      {required String domain,
      String unencodedPath = '',
      Map<String, dynamic>? queryParameters}) {
    url = Uri.https(domain, unencodedPath, queryParameters);
  }

  Future<dynamic> getRequest() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      // as Map<String, dynamic>
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
