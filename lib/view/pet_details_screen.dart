
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../provider/pet_provider.dart';
import '../widgets/alert_dialog.dart';

class PetDetailsScreen extends StatelessWidget {
  final PetModel pet;

  const PetDetailsScreen({super.key, required this.pet});

  void deletePet(BuildContext context) {
    Provider.of<PetProvider>(context, listen: false).deletePet(pet.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pet reservation canceled successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Pet Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: w,
          padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  pet.petImage,
                  width: w * 0.6,
                  height: w * 0.6,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                  },
                ),
              ),
              SizedBox(height: h * 0.03),
              Text(
                pet.petName,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: h * 0.01),
              Text(
                "Owner: ${pet.userName}",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: h * 0.01),
              Text("Age: ${pet.age} years", style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
              SizedBox(height: h * 0.01),
              Text("Gender: ${pet.gender}", style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
              SizedBox(height: h * 0.01),
              Text("Number of Pets: ${pet.numPets}", style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
              SizedBox(height: h * 0.05),
              SizedBox(
                width: w * 0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    customAlertBox(
                      context: context,
                      title: "Cancel Reservation",
                      content: 'Do you want to cancel this reservation?',
                      yes: () => deletePet(context),
                    );
                  },
                  child: const Text("Cancel Reservation", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

