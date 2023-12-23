import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkDownRenderer extends StatelessWidget {
  const MarkDownRenderer({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: MarkdownBody(
          data: data,
          selectable: true,
          fitContent: false,
        ),
      ),
    );
  }
}
