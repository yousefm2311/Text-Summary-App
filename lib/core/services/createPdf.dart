// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfGenerator {
  // static late Font arFont;

  // static init() async {
  //   arFont = Font.ttf((await rootBundle.load("assets/fonts/open-sans.ttf")));
  // }

  // static createPdf() async {
  //   String path = (await getApplicationDocumentsDirectory()).path;
  //   File file = File(path+"MY_PdF.pdf");

  //   Document pdf = Document();
  //   pdf.addPage(_createPage());

  //   Uint8List bytes = await pdf.save();
  //   await file.writeAsBytes(bytes);
  //   await OpenFile.open(file.path);
  // }

  // static Page _createPage() {
  //   return Page(
  //     textDirection: TextDirection.ltr,
  //     theme: ThemeData.withFont(
  //       base: arFont,
  //     ),
  //     pageFormat: PdfPageFormat.a4,
  //     build: (context) {
  //       return Center(
  //         child: Container(
  //           child: Text('Hello World'),
  //         ),
  //       );
  //     },
  //   );
  // }

  static createPdf() async {
    String path = (await getApplicationDocumentsDirectory()).path;

    File file = File("${path}MyPdf.pdf");

    Document pdf = Document();

    pdf.addPage(_createPdf());

    Uint8List bytes = await pdf.save();

    await file.writeAsBytes(bytes);

    await OpenFile.open(file.path);
  }

  static Page _createPdf() {
    return Page(build: (context) {
      return Center(
        child: Container(
          child: Text('Hello World'),
        ),
      );
    });
  }
}
