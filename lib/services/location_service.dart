import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  Future<String> getPlaceName(double latitude, double longitude) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&accept-language=en");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["address"]["city"] ??
            data["address"]["town"] ??
            "Unknown location";
      } else {
        return "Request error";
      }
    } catch (e) {
      return "Network error";
    }
  }

  Future<Map<String, double>?> getCoordinatesFromCity(String cityName) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?format=json&q=$cityName");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final double latitude = double.parse(data[0]["lat"]);
          final double longitude = double.parse(data[0]["lon"]);
          return {"latitude": latitude, "longitude": longitude};
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
