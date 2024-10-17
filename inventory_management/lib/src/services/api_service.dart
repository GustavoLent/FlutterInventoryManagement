import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/company.dart';
import '../models/location.dart';
import '../models/asset.dart';

class ApiService {
  static const String baseUrl = "https://fake-api.tractian.com";

  Future<List<Company>> getCompanies() async {
    final response = await http.get(Uri.parse('$baseUrl/companies'));

    if (response.statusCode == 200) {
      List<dynamic> companiesJson = jsonDecode(response.body);
      return companiesJson.map((json) => Company.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<List<Location>> getLocations(String companyId) async {
    final response = await http.get(Uri.parse('$baseUrl/companies/$companyId/locations'));

    if (response.statusCode == 200) {
      List<dynamic> locationsJson = jsonDecode(response.body);
      return locationsJson.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  // Method to get assets for a specific company
  Future<List<Asset>> getAssets(String companyId) async {
    final response = await http.get(Uri.parse('$baseUrl/companies/$companyId/assets'));

    if (response.statusCode == 200) {
      List<dynamic> assetsJson = jsonDecode(response.body);
      return assetsJson.map((json) => Asset.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load assets');
    }
  }
}
