import 'package:flutter/foundation.dart';
import '../models/pet_model.dart';
import '../services/api_service.dart';
import '../database/pet_db.dart';

class PetProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<PetModel> _pets = [];
  List<PetModel> _filteredPets = [];
  List<PetModel> _localPets = [];
  String _errorMessage = '';

  List<PetModel> get pets => _pets;
  List<PetModel> get filteredPets => _filteredPets;
  List<PetModel> get localPets => _localPets;
  String get errorMessage => _errorMessage;

  bool isLoading = false;

  Future<void> fetchPets() async {
    isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _pets = await _apiService.fetchPets();
      _filteredPets = _pets.where((pet) => pet.isFriendly).toList();
    } catch (e) {
      _errorMessage = "Failed to fetch pets. Please try again.";
      if (kDebugMode) {
        print("Error fetching pets: $e");
      }
      _pets = [];
      _filteredPets = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLocalPets() async {
    try {
      _localPets = await PetDB.getPets();
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error loading local pets.";
      if (kDebugMode) {
        print("Error loading local pets: $e");
      }
    }
  }

  Future<void> addPet(PetModel pet) async {
    try {
      await PetDB.addPet(pet);
      await loadLocalPets();
    } catch (e) {
      _errorMessage = "Error adding pet.";
      if (kDebugMode) {
        print("Error adding pet: $e");
      }
    }
  }

  Future<void> deletePet(int index) async {
    try {
      await PetDB.deletePet(index);
      await loadLocalPets();
    } catch (e) {
      _errorMessage = "Error deleting pet.";
      if (kDebugMode) {
        print("Error deleting pet: $e");
      }
    }
  }
}
