import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample1_isar/view/update_course_screen.dart';

import '../provider/course_provider.dart';
import 'course_screen.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseData = ref.watch(getAllcoursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Isar DB'),
      ),
      body: Center(
        child: courseData.when(
          data: (courses) {
            if (courses.isEmpty) {
              return const Center(child: Text('No courses found'));
            }
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final newTitle = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateCourseScreen(
                                courseId: course.id,
                                initialTitle: course.title,
                              ),
                            ),
                          );
                          if (newTitle != null) {
                            await ref.read(updateCourseTitleProvider(
                                    {'id': course.id, 'newTitle': newTitle})
                                .future);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Course title updated successfully')),
                            );
                          }
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(deleteCourseProvider(course.id).future);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const CourseScreen(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
