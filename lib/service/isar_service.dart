import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/course.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveCourse(Course newCourse) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.courses.putSync(newCourse));
  }

  Future<List<Course>> getAllCourses() async {
    final isar = await db;
    return await isar.courses.where().findAll();
  }

  Stream<List<Course>> listenToCourses() async* {
    final isar = await db;
    yield* isar.courses.where().watch();
  }

  Future<void> deleteCourse(int courseId) async {
    final isar = await db;
    await isar.writeTxn(() => isar.courses.delete(courseId));
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationSupportDirectory();
      return await Isar.open(
        [CourseSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> updateCourseTitle(int courseId, String newTitle) async {
    final isar = await db;
    final course = await isar.courses.get(courseId);
    if (course != null) {
      course.title = newTitle;
      await isar.writeTxn(() => isar.courses.put(course));
    }
  }
}
