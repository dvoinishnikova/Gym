class GymLoad {
  final int people;
  final String approx;
  final String status;

  GymLoad({
    required this.people,
    required this.approx,
    required this.status,
  });

  factory GymLoad.fromJson(Map<String, dynamic> json) {
    return GymLoad(
      people: json["people_now"],
      approx: json["approx"],
      status: json["status"],
    );
  }
}