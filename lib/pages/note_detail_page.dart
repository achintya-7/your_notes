// ignore_for_file: prefer_const_constructors_in_immutables, unnecessary_this, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/db/notes_database.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/pages/add_edit_note_page.dart';
import 'package:notesapp/widgets/markdown_rendered.dart';

class NoteDetailPage extends StatefulWidget {
  NoteDetailPage({super.key, required this.noteId});

  final int noteId;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    this.note = await NoteDatabase.instance.read(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: TextStyle(color: Colors.white38),
                  ),
                  SizedBox(height: 20),
                  MarkDownRenderer(data: note.description),
                ],
              ),
            ),
    );
  }

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AddEditNotePage(note: note)),
        );
      });

  Widget deleteButton() => IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        await NoteDatabase.instance.delete(widget.noteId);

        Navigator.of(context).pop();
      });
}
