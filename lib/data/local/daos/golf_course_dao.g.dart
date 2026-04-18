// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'golf_course_dao.dart';

// ignore_for_file: type=lint
mixin _$GolfCourseDaoMixin on DatabaseAccessor<AppDatabase> {
  $GolfCoursesTableTable get golfCoursesTable =>
      attachedDatabase.golfCoursesTable;
  GolfCourseDaoManager get managers => GolfCourseDaoManager(this);
}

class GolfCourseDaoManager {
  final _$GolfCourseDaoMixin _db;
  GolfCourseDaoManager(this._db);
  $$GolfCoursesTableTableTableManager get golfCoursesTable =>
      $$GolfCoursesTableTableTableManager(
          _db.attachedDatabase, _db.golfCoursesTable);
}
