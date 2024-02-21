import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/course.dart';
import '../service/isar_service.dart';

final isarServiceProvider = Provider((ref) => IsarService());

final getAllcoursesProvider = FutureProvider<List<Course>>((ref) async {
  final isarService = ref.read(isarServiceProvider);
  return isarService.getAllCourses();
});

final updateCourseTitleProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, args) async {
  final isarService = ref.read(isarServiceProvider);
  int courseId = args['id'];
  String newTitle = args['newTitle'];
  await isarService.updateCourseTitle(courseId, newTitle);
});

final deleteCourseProvider =
    FutureProvider.family<void, int>((ref, courseId) async {
  final isarService = ref.read(isarServiceProvider);
  await isarService.deleteCourse(courseId);
});
