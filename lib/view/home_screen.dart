import 'package:flutter/material.dart';
import 'package:pet_management_app/view/register_screen.dart';
import 'package:provider/provider.dart';
import 'pet_details_screen.dart';
import '../provider/pet_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Fetching pets..."); // Debugging print
      Provider.of<PetProvider>(context, listen: false).fetchPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        title: const Text("Pet Management"),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => const RegisterPetScreen()));
            },
              child: const Icon(Icons.add,size:30,color: Colors.black,))
        ],
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          if (petProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (petProvider.errorMessage.isNotEmpty) {
            return Center(child: Text("Error: ${petProvider.errorMessage}"));
          } else if (petProvider.pets.isEmpty) {
            return const Center(child: Text("No pets available"));
          } else {
            return ListView.builder(
              itemCount: petProvider.pets.length,
              itemBuilder: (context, index) {
                final pet = petProvider.pets[index];
                return ListTile(
                  title: Text(pet.petName), 
                  subtitle: Text("Owner: ${pet.userName}"),
                  leading: CircleAvatar(
                    backgroundImage: pet.petImage.isNotEmpty
                        ? NetworkImage(pet.petImage)
                        : const AssetImage("assets/default_pet.png") as ImageProvider,
                    onBackgroundImageError: (_, __) => const Icon(Icons.error),
                  ),
                  trailing: Icon(Icons.pets, color: pet.isFriendly ? Colors.green : Colors.red),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PetDetailsScreen( index: index)),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<PetProvider>(context, listen: false).fetchPets(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
