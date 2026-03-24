class Trainer {
  final int id;
  final String name;
  final String type;
  final int experienceYears;
  final int clientsCount;
  final double rating;
  final String description;
  final String phone;
  final String telegram;
  final String image;

  Trainer({
    required this.id,
    required this.name,
    required this.type,
    required this.experienceYears,
    required this.clientsCount,
    required this.rating,
    required this.description,
    required this.phone,
    required this.telegram,
    required this.image,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      experienceYears: json['experience_years'],
      clientsCount: json['clients_count'],
      rating: (json['rating'] as num).toDouble(),
      description: json['description'],
      phone: json['phone'],
      telegram: json['telegram'],
      image: json['image'],
    );
  }
}