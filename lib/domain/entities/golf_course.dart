class GolfCourse {
  final String id;
  final String name;
  final String location;
  final int totalHoles;
  final List<int> pars;

  const GolfCourse({
    required this.id,
    required this.name,
    required this.location,
    required this.totalHoles,
    required this.pars,
  });
}
