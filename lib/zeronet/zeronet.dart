import 'package:http/http.dart';

class ZeroNet {
  static String wrapperKey = '';
  Client client = Client();
  getWrapperKey(String url) async {
    if (wrapperKey.isEmpty) {
      Response res = await client.get(
        url,
        headers: {'Accept': 'text/html'},
      );
      String body = res.body;
      var i = body.indexOf('wrapper_key = "');
      var bodyM = body.substring(i + 15);
      var j = bodyM.indexOf('"');
      return bodyM.substring(0, j);
    }
  }
}
