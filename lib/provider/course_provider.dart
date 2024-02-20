import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/course.dart';
import '../service/isar_service.dart';

final isarServiceProvider = Provider((ref) => IsarService());

final getAllcoursesProvider = FutureProvider<List<Course>>((ref) async {
  final isarService = ref.read(isarServiceProvider);
  return isarService.getAllCourses();
});
