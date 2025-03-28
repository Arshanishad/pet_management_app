import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/pet_provider.dart';


class PetDetailsScreen extends StatelessWidget {
  final int index;

  PetDetailsScreen({required this.index});

  void deletePet(BuildContext context) {
    Provider.of<PetProvider>(context, listen: false).deletePet(index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pet Details")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => deletePet(context),
          child: Text("Cancel Reservation"),
        ),
      ),
    );
  }
}
