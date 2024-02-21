import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class UpdateCourseScreen extends StatefulWidget {
  final String initialTitle;

  const UpdateCourseScreen(
      {Key? key, required this.initialTitle, required Id courseId})
      : super(key: key);

  @override
  _UpdateCourseScreenState createState() => _UpdateCourseScreenState();
}

class _UpdateCourseScreenState extends State<UpdateCourseScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.initialTitle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Course Title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _textController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'New Course Title',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _textController.text);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
