import 'package:everylounge/domain/entities/file/pdf_data.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/widgets/appbars/appbar.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFView extends StatelessWidget {
  static const String path = "pdfView";

  final PdfData pdfData;

  const PDFView({super.key, required this.pdfData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(
          pdfData.title,
          style: context.textStyles.textLargeBold(),
        ),
      ),
      body: const PDF().cachedFromUrl(
        pdfData.link,
        placeholder: (progress) => const Center(child: AppCircularProgressIndicator.large()),
        errorWidget: (error) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}
