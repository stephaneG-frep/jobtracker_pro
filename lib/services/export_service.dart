import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/job_application.dart';

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
  }) async {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(build: (context) {
      return [
        pw.Header(level: 0, child: pw.Text(_pdfText(title))),
        pw.Paragraph(
            text:
                'Periode: ${from?.toIso8601String() ?? '-'} -> ${to?.toIso8601String() ?? '-'}'),
        pw.TableHelper.fromTextArray(data: [
          ['Entreprise', 'Poste', 'Statut', 'Date'],
          ...apps.map((a) => [
                _pdfText(a.company),
                _pdfText(a.title),
                _pdfText(statusLabelBuilder?.call(a.status) ?? a.status.name),
                a.appliedAt.toIso8601String()
              ])
        ])
      ];
    }));
    return doc.save();
  }

  static String _pdfText(String value) {
    const replacements = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'ç': 'c',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'î': 'i',
      'ï': 'i',
      'ô': 'o',
      'ö': 'o',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'À': 'A',
      'Â': 'A',
      'Ä': 'A',
      'Ç': 'C',
      'É': 'E',
      'È': 'E',
      'Ê': 'E',
      'Ë': 'E',
      'Î': 'I',
      'Ï': 'I',
      'Ô': 'O',
      'Ö': 'O',
      'Ù': 'U',
      'Û': 'U',
      'Ü': 'U',
    };

    return value.split('').map((char) => replacements[char] ?? char).join();
  }
}
