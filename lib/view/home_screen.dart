import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pet_management_app/view/register_screen.dart';
import 'package:provider/provider.dart';
import '../core/globals.dart';
import 'pet_details_screen.dart';
import '../provider/pet_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showFriendlyOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PetProvider>(context, listen: false).fetchPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        title: Text(
          "Pet Management",
          style: TextStyle(fontSize: w * 0.05),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: w * 0.04),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPetScreen()),
                );
              },
              child: Icon(
                Icons.add,
                size: w * 0.07,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(w * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Show only friendly pets",
                  style: TextStyle(fontSize: w * 0.045),
                ),
                Switch(
                  value: showFriendlyOnly,
                  onChanged: (value) {
                    setState(() {
                      showFriendlyOnly = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<PetProvider>(
              builder: (context, petProvider, child) {
                if (petProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (petProvider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      "Error: ${petProvider.errorMessage}",
                      style: TextStyle(fontSize: w * 0.045),
                    ),
                  );
                } else {
                  final pets = showFriendlyOnly
                      ? petProvider.pets.where((pet) => pet.isFriendly).toList()
                      : petProvider.pets;

                  if (pets.isEmpty) {
                    return Center(
                      child: Text(
                        "No pets available",
                        style: TextStyle(fontSize: w * 0.045),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      if (kDebugMode) {
                        print("Pet Image: ${pets[index].petImage}");
                      }
                      final pet = pets[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: w * 0.01),
                        child: ListTile(
                          title: Text(
                            pet.petName,
                            style: TextStyle(fontSize: w * 0.045),
                          ),
                          subtitle: Text(
                            "Owner: ${pet.userName}",
                            style: TextStyle(fontSize: w * 0.04),
                          ),
                          leading: CircleAvatar(
                            radius: w * 0.08,
                            backgroundColor: Colors.grey[300], // Placeholder color
                            backgroundImage: pet.petImage.isNotEmpty
                                ? CachedNetworkImageProvider(pet.petImage)
                                : const AssetImage("assets/default_pet.png") as ImageProvider,
                            child: pet.petImage.isEmpty
                                ? const Icon(Icons.error, color: Colors.red)
                                : null,
                          ),
                          trailing: Icon(
                            Icons.pets,
                            size: w * 0.06,
                            color: pet.isFriendly ? Colors.green : Colors.red,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetDetailsScreen(pet: pet,),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<PetProvider>(context, listen: false).fetchPets(),
        child: Icon(
          Icons.refresh,
          size: w * 0.07,
        ),
      ),
    );
  }
}
