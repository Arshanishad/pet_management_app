import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../provider/pet_provider.dart';
import '../widgets/alert_dialog.dart';

class RegisterPetScreen extends StatefulWidget {
  const RegisterPetScreen({super.key});

  @override
  _RegisterPetScreenState createState() => _RegisterPetScreenState();
}

class _RegisterPetScreenState extends State<RegisterPetScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedPet;
  final userNameController = TextEditingController();
  final petNameController = TextEditingController();
  final petImageController = TextEditingController();
  final ageController = TextEditingController();
  String gender = 'Male';
  final numPetsController = TextEditingController();
  bool isFriendly = true;

  Future<void> registerPet() async {
    if (!_formKey.currentState!.validate()) return;
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final pet = PetModel(
      id: 0,
      userName: userNameController.text,
      petName: petNameController.text,
      petImage: petImageController.text,
      isFriendly: isFriendly,
      age: int.parse(ageController.text),
      gender: gender,
      numPets: int.parse(numPetsController.text),
    );
    await petProvider.addPet(pet);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pet Registered Successfully")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Register Pet")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Dropdown for available pets
                DropdownButtonFormField<String>(
                  value: selectedPet,
                  hint: const Text("Select Available Pet"),
                  items: petProvider.pets.map((pet) {
                    return DropdownMenuItem(
                      value: pet.petName,
                      child: Text(pet.petName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPet = value;
                    });
                  },
                ),
                TextFormField(
                  controller: userNameController,
                  decoration: const InputDecoration(labelText: "Owner Name"),
                  validator: (value) => value!.isEmpty ? "Enter owner name" : null,
                ),
                TextFormField(
                  controller: petNameController,
                  decoration: const InputDecoration(labelText: "Pet Name"),
                  validator: (value) => value!.isEmpty ? "Enter pet name" : null,
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter pet age" : null,
                ),

                // Gender selection
                DropdownButtonFormField<String>(
                  value: gender,
                  items: ['Male', 'Female'].map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
                  onChanged: (value) => setState(() => gender = value!),
                  decoration: const InputDecoration(labelText: "Gender"),
                ),

                TextFormField(
                  controller: numPetsController,
                  decoration: const InputDecoration(labelText: "Number of Pets"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter number of pets" : null,
                ),

                TextFormField(
                  controller: petImageController,
                  decoration: const InputDecoration(labelText: "Pet Image URL"),
                  validator: (value) => value!.isEmpty ? "Enter image URL" : null,
                ),

                SwitchListTile(
                  title: const Text("Friendly?"),
                  value: isFriendly,
                  onChanged: (value) => setState(() => isFriendly = value),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    customAlertBox(
                      context: context,
                      title: "Add Pet",
                      content: 'Do you want to add this pet?',
                      yes: registerPet,
                    );
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
