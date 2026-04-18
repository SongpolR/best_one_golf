import 'package:drift/drift.dart';

import '../../../domain/entities/golf_course.dart';
import '../app_database.dart';
import '../tables/golf_courses_table.dart';

part 'golf_course_dao.g.dart';

@DriftAccessor(tables: [GolfCoursesTable])
class GolfCourseDao extends DatabaseAccessor<AppDatabase>
    with _$GolfCourseDaoMixin {
  GolfCourseDao(super.db);

  Future<List<GolfCourse>> getAllCourses() async {
    final rows = await select(golfCoursesTable).get();
    return rows.map(_toDomain).toList();
  }

  Future<void> ensureSeeded() async {
    final existing = await select(golfCoursesTable).get();
    if (existing.isNotEmpty) return;

    await into(golfCoursesTable).insert(
      const GolfCoursesTableCompanion(
        id: Value('singha-park-khon-kaen'),
        name: Value('Singha Park Khon Kaen Golf Club'),
        location: Value('Khon Kaen'),
        totalHoles: Value(18),
        pars: Value('4,4,5,4,3,4,5,3,4,4,5,4,3,4,4,4,3,5'),
      ),
    );
  }

  GolfCourse _toDomain(GolfCoursesTableData row) {
    return GolfCourse(
      id: row.id,
      name: row.name,
      location: row.location,
      totalHoles: row.totalHoles,
      pars: row.pars.split(',').map(int.parse).toList(),
    );
  }
}
