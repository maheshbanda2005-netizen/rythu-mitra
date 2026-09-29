class AgriExpert {
  final String id;
  final String name;
  final String title; // Senior Agronomist, Plant Pathologist, Soil Scientist
  final String institution; // PJTSAU, ICAR-CRIDA, KVK
  final int experienceYears;
  final List<String> languages;
  final double rating;
  final int consultationsCount;
  final bool isOnline;
  final String phone;

  const AgriExpert({
    required this.id,
    required this.name,
    required this.title,
    required this.institution,
    required this.experienceYears,
    required this.languages,
    required this.rating,
    required this.consultationsCount,
    required this.isOnline,
    required this.phone,
  });
}
