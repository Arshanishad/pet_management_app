import 'package:flutter/material.dart';
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
    _errorMessage = ''; // Clear previous errors
    notifyListeners();

    try {
      _pets = await _apiService.fetchPets();
      _filteredPets = _pets.where((pet) => pet.isFriendly).toList();
    } catch (e) {
      _errorMessage = "Failed to fetch pets. Please try again.";
      print("Error fetching pets: $e");
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
      print("Error loading local pets: $e");
    }
  }

  Future<void> addPet(PetModel pet) async {
    try {
      await PetDB.addPet(pet);
      await loadLocalPets(); // Reload from database for consistency
    } catch (e) {
      _errorMessage = "Error adding pet.";
      print("Error adding pet: $e");
    }
  }

  Future<void> deletePet(int index) async {
    try {
      await PetDB.deletePet(index);
      await loadLocalPets(); // Reload from database to ensure UI updates correctly
    } catch (e) {
      _errorMessage = "Error deleting pet.";
      print("Error deleting pet: $e");
    }
  }
}
