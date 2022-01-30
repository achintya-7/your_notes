// ignore_for_file: unnecessary_this, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notesapp/db/notes_database.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/widgets/note_cart_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class NotePageState extends StatefulWidget {
  NotePageState({Key? key}) : super(key: key);

  @override
  State<NotePageState> createState() => _NoteHomeState();
}

class _NoteHomeState extends State<NotePageState> {
  late List<Note> notes;
  bool _isLoading = false;

  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  Future refreshNote() async {
    setState(() => _isLoading = true);
    this.notes = await NoteDatabase.instance.readAll();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.lightBlueAccent,
          child: Column(
            children: [
              40.heightBox,
              "Made By".text.white.xl3.semiBold.make().p(16),
              "Achintya".text.white.bold.xl4.make().shimmer(
                  primaryColor: Vx.pink500, secondaryColor: Vx.blue500),
              IconButton(
                  onPressed: () {
                    launch("https://github.com/achintya-7");
                  },
                  iconSize: 92,
                  icon: Image.asset("assets/images/icons8-github-100.png"))
            ],
          ),
        ),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Text(
                    'No Notes',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: EdgeInsets.all(8),
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNote();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );

  Widget editButton() =>
      IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {});

  Widget deleteButton() =>
      IconButton(icon: Icon(Icons.delete), onPressed: () {});
}
