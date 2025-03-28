import 'package:hive/hive.dart';
import '../models/pet_model.dart';


class PetDB {
  static const String petBox = "petBox";

  static Future<void> addPet(PetModel pet) async {
    var box = await Hive.openBox<PetModel>(petBox);
    box.add(pet);
  }

  static Future<List<PetModel>> getPets() async {
    var box = await Hive.openBox<PetModel>(petBox);
    return box.values.toList();
  }

  static Future<void> deletePet(int index) async {
    var box = await Hive.openBox<PetModel>(petBox);
    box.deleteAt(index);
  }
}
