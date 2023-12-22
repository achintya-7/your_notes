// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notesapp/db/notes_database.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  AddEditNotePage({super.key, this.note});

  final Note? note;

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formkey = GlobalKey<FormState>();

  late bool isImportant;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formkey,
        child: NoteFormWidget(
          isImportant: isImportant,
          title: title,
          description: description,
          onChangedImportant: (isImportant) =>
              setState(() => this.isImportant = isImportant),
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) =>
              setState(() => this.description = description),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty;

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isFormValid ? Colors.green.shade500 : Colors.grey.shade700,
          ),
          onPressed: addorUpdateNote,
          child: Text('Save'),
        ));
  }

  void addorUpdateNote() async {
    final isValid = _formkey.currentState!.validate();

    if (isValid) {
      // if note is not there, isUpdating is false
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
        Navigator.of(context).pop();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      title: title,
      description: description,
    );

    await NoteDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
        isImportant: isImportant,
        title: title,
        description: description,
        createdTime: DateTime.now());

    await NoteDatabase.instance.create(note);
  }
}
