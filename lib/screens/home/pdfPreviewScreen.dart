import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';


class pdfPreviewScreen extends StatelessWidget {
  final String path;
  final String name;
  pdfPreviewScreen({this.path, this.name});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
    );
    return Container();
  }
}
