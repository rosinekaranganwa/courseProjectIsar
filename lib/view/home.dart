import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/course.dart';
import '../provider/course_provider.dart';
import 'course_screen.dart';
import 'course_update_form.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsyncValue = ref.watch(getAllcoursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isar DB'),
        actions: [
          IconButton(
            onPressed: () async {
              // Clean the database
              final isarService = ref.read(isarServiceProvider);
              await isarService.cleanDb();
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Center(
        child: courseAsyncValue.when(
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
                          // Update course title
                          final newTitle = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Update Course Title'),
                                content: CourseUpdateForm(
                                  initialTitle: course.title,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(null);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final form = CourseUpdateForm.of(context);
                                      if (form != null && form.validate()) {
                                        // Ensure form is not null
                                        Navigator.of(context).pop(form.title);
                                      }
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (newTitle != null) {
                            final updatedCourse = Course()
                              ..id = course.id
                              ..title = newTitle;
                            final isarService = ref.read(isarServiceProvider);
                            await isarService.updateCourse(updatedCourse);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Course title updated to '$newTitle'",
                                ),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          // Delete course
                          final isarService = ref.read(isarServiceProvider);
                          await isarService.deleteCourse(course.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Course deleted"),
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
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
            builder: (context) => CourseScreen(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
