// ignore_for_file: unnecessary_this, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notesapp/auth/local_auth.dart';
import 'package:notesapp/db/notes_database.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/pages/add_edit_note_page.dart';
import 'package:notesapp/pages/note_detail_page.dart';
import 'package:notesapp/widgets/note_cart_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/custom_drawer.dart';

class NotePageState extends StatefulWidget {
  const NotePageState({super.key});

  @override
  State<NotePageState> createState() => _NotePageState();
}

class _NotePageState extends State<NotePageState> {
  late List<Note> notes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  @override
  void dispose() {
    NoteDatabase.instance.close();
    super.dispose();
  }

  Future refreshNote() async {
    setState(() => _isLoading = true);
    this.notes = await NoteDatabase.instance.readAll();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: "Notes".text.xl3.white.make(),
        backgroundColor: Colors.transparent,
      ),

      // Drawer
      drawer: CustomDrawer(),

      // Body
      body: _isLoading
          ? CircularProgressIndicator()
          : notes.isEmpty
              ? Center(
                  child: Text(
                    'Why not add a note?',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                )
              : buildNotes(),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage()),
          );

          refreshNote();
        },
      ),
    );
  }

  Widget buildNotes() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: List.generate(notes.length, (index) {
            final note = notes[index];

            return GestureDetector(
              onTap: () async {
                bool isAuth = true;

                if (note.isImportant) {
                  isAuth = await LocalAuth.authenticate();
                }

                if (!isAuth) {
                  return;
                }

                // ignore: use_build_context_synchronously
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ));

                refreshNote();
              },
              child: NoteCardWidget(note: note, index: index),
            );
          }).reversed.toList(),
        ),
      );
}
