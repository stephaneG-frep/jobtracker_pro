import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/job_application.dart';
import '../utils/text_utils.dart';

class ExportService {
  static String toCsv(List<JobApplication> apps) {
    final rows = <List<String>>[];
    rows.add([
      "id",
      "company",
      "title",
      "status",
      "appliedAt",
      "city",
      "contract",
      "email",
      "phone",
      "salary"
    ]);
    for (var a in apps) {
      rows.add([
        a.id,
        a.company,
        a.title,
        a.status.toString(),
        a.appliedAt.toIso8601String(),
        a.city,
        a.contractType.toString(),
        a.contactEmail ?? '',
        a.contactPhone ?? '',
        a.salary ?? '',
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  static Future<Uint8List> toPdfBytes(
    List<JobApplication> apps, {
    DateTime? from,
    DateTime? to,
    String title = 'Rapport JobTracker Pro',
    String Function(ApplicationStatus status)? statusLabelBuilder,
    List<String> columnHeaders = const ['Entreprise', 'Poste', 'Statut', 'Date'],
    String Function(String from, String to)? periodLabelBuilder,
  }) async {
    final fromLabel = from == null ? '-' : formatShortDate(from);
    final toLabel = to == null ? '-' : formatShortDate(to);
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(build: (context) {
      return [
        pw.Header(level: 0, child: pw.Text(_pdfText(title))),
        if (from != null || to != null)
          pw.Paragraph(
              text: _pdfText(periodLabelBuilder?.call(fromLabel, toLabel) ??
                  'Periode: $fromLabel -> $toLabel')),
        pw.TableHelper.fromTextArray(data: [
          columnHeaders.map(_pdfText).toList(),
          ...apps.map((a) => [
                _pdfText(a.company),
                _pdfText(a.title),
                _pdfText(statusLabelBuilder?.call(a.status) ?? a.status.name),
                formatShortDate(a.appliedAt.toLocal()),
              ])
        ])
      ];
    }));
    return doc.save();
  }

  static String _pdfText(String value) => removeDiacritics(value);
}
