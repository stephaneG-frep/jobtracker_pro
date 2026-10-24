import 'package:flutter_test/flutter_test.dart';
import 'package:jobtracker_pro/models/job_application.dart';
import 'package:jobtracker_pro/screens/applications_screen.dart';
import 'package:jobtracker_pro/services/export_service.dart';
import 'package:jobtracker_pro/utils/text_utils.dart';

void main() {
  final app = JobApplication(
    id: 'a',
    company: 'Acme Corp',
    title: 'Développeur Flutter',
    city: 'Paris',
    contactName: 'Jeanne Martin',
    notes: 'Télétravail possible',
  );

  group('matchesSearch', () {
    test('matches everything when the query is empty', () {
      expect(matchesSearch(app, ''), isTrue);
      expect(matchesSearch(app, '   '), isTrue);
    });

    test('ignores case and accents', () {
      expect(matchesSearch(app, 'developpeur'), isTrue);
      expect(matchesSearch(app, 'ACME'), isTrue);
      expect(matchesSearch(app, 'teletravail'), isTrue);
    });

    test('requires every word, in any field', () {
      expect(matchesSearch(app, 'flutter paris'), isTrue);
      expect(matchesSearch(app, 'martin acme'), isTrue);
      expect(matchesSearch(app, 'flutter lyon'), isFalse);
    });
  });

  test('formatShortDate pads day and month', () {
    expect(formatShortDate(DateTime(2026, 3, 7)), '07/03/2026');
  });

  test('builds a PDF for a chosen period', () async {
    final bytes = await ExportService.toPdfBytes(
      [app],
      from: DateTime(2026, 10, 1),
      to: DateTime(2026, 10, 24),
    );
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
