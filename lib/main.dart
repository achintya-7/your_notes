import 'package:flutter/material.dart';
import 'package:notesapp/pages/note_page.dart';
import 'package:notesapp/widgets/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: const NotePageState(),
      theme: Mytheme.darkTheme(context),
    );
  }
}
