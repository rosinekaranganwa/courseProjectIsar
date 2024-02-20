import 'package:flutter/material.dart';

class CourseUpdateForm extends StatefulWidget {
  final String initialTitle;

  const CourseUpdateForm({Key? key, required this.initialTitle})
      : super(key: key);

  static _CourseUpdateFormState of(BuildContext context) =>
      context.findAncestorStateOfType<_CourseUpdateFormState>()!;

  @override
  _CourseUpdateFormState createState() => _CourseUpdateFormState();
}

class _CourseUpdateFormState extends State<CourseUpdateForm> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialTitle);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      autofocus: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Course Name is not allowed to be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'New Course Title',
      ),
    );
  }

  String get title => _textController.text;

  bool validate() {
    return _textController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
