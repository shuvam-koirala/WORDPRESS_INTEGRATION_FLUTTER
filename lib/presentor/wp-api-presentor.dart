import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchWpPost() async {
  String url = "https://renemorozowich.com/wp-json/wp/v2/posts";
  final response = await http.get(url, headers: {"Accept": "application/json"});
  var dataList = jsonDecode(response.body);
  return dataList;
}
