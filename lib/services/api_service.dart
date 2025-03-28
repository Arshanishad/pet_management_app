import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_model.dart';

class ApiService {
  static const String apiUrl = "https://jatinderji.github.io/users_pets_api/users_pets.json";

  /// Fetch list of pets from API
  Future<List<PetModel>> fetchPets() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey("data")) {
          List<dynamic> petList = jsonResponse["data"];
          return petList.map((e) => PetModel.fromJson(e)).toList();
        } else {
          throw Exception("Invalid API response: Missing 'data' key");
        }
      } else {
        throw Exception("Failed to load pets: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching pets: $e");
      throw Exception("Error fetching pets: $e");
    }
  }
}
