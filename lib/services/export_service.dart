import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/job_application.dart';

class ExportService {
  static String toCsv(List<JobApplication> apps) {
    final rows = <List<String>>[];
    rows.add(["id","company","title","status","appliedAt","city","contract","email","phone","salary"]);
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

  static Future<Uint8List> toPdfBytes(List<JobApplication> apps, {DateTime? from, DateTime? to}) async {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(build: (context) {
      return [
        pw.Header(level: 0, child: pw.Text('Rapport JobTracker Pro')),
        pw.Paragraph(text: 'Période: ${from?.toIso8601String() ?? '-'} -> ${to?.toIso8601String() ?? '-'}'),
        pw.TableHelper.fromTextArray(
            data: [
          ['Entreprise', 'Poste', 'Statut', 'Date'],
          ...apps.map((a) => [a.company, a.title, a.status.name, a.appliedAt.toIso8601String()])
        ])
      ];
    }));
    return doc.save();
  }
}
