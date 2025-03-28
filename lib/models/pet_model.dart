class PetModel {
  final int id;
  final String userName;
  final String petName;
  final String petImage;
  final bool isFriendly;
  final int age;
  final String gender;
  final int numPets;

  PetModel({
    required this.id,
    required this.userName,
    required this.petName,
    required this.petImage,
    required this.isFriendly,
    required this.age,
    required this.gender,
    required this.numPets,
  });

  // Convert JSON to PetModel
  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      userName: json['userName'],
      petName: json['petName'],
      petImage: json['petImage'],
      isFriendly: json['isFriendly'],
      age: json['age'] ?? 0, // Default 0 if missing
      gender: json['gender'] ?? 'Unknown', // Default 'Unknown' if missing
      numPets: json['numPets'] ?? 1, // Default 1 if missing
    );
  }

  // Convert PetModel to JSON (for saving to database)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'petName': petName,
      'petImage': petImage,
      'isFriendly': isFriendly,
      'age': age,
      'gender': gender,
      'numPets': numPets,
    };
  }
}
