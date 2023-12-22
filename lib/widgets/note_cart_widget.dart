// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notesapp/model/note.dart';
import 'package:intl/intl.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    super.key,
    required this.note,
    required this.index,
  });

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight, maxHeight: 250),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              note.title,
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            note.isImportant
                ? Text(
                    " ... ",
                    maxLines: 4,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                  )
                : Text(
                    extractHeadersAndText(note.description),
                    maxLines: 4,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}

String extractHeadersAndText(String markdown) {
  final regex = RegExp(r"^(#+)\s+(.+(?:\n[^\n]*){0,3})", multiLine: true);

  final matches = regex.allMatches(markdown);

  final extractedContent = matches
      .map((match) => match.group(2)?.replaceAll(RegExp(r"#"), ''))
      .map((content) => content?.replaceAllMapped(RegExp(r"\[.*?\]\(.*?\)|!\[.*?\]\(.*?\)", multiLine: true), (match) => ''))
      .take(4)
      .join('');

  return extractedContent;
}
