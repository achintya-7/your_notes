// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notesapp/widgets/markdown_rendered.dart';
import 'package:notesapp/widgets/theme.dart';
import 'package:velocity_x/velocity_x.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final String? title;
  final String? description;
  final bool? isPreview;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<bool> onChangedIsText;

  const NoteFormWidget({
    super.key,
    this.isImportant,
    this.title,
    this.description,
    this.isPreview,
    required this.onChangedImportant,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onChangedIsText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Switch(value: isImportant ?? false, onChanged: onChangedImportant),
              "Important".text.xl2.white.make(),
              const Spacer(),
              Switch(value: isPreview ?? false, onChanged: onChangedIsText),
              "Preview".text.xl2.white.make(),
            ],
          ),
          buildTitle(),
          SizedBox(height: 8),
          isPreview! ? MarkDownRenderer(data: description ?? "") : buildDescription(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
          fillColor: Mytheme.darkBluishColor,
          filled: true,
        ),
        validator: (title) => title != null && title.isEmpty ? 'Title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => Expanded(
        child: TextFormField(
          maxLines: 99999,
          initialValue: description,
          style: TextStyle(color: Colors.white60, fontSize: 16),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Type Something....',
            hintStyle: TextStyle(color: Colors.white60),
            fillColor: Mytheme.darkBluishColor,
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onChanged: onChangedDescription,
        ),
      );
}
