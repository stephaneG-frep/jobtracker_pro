import 'package:flutter_test/flutter_test.dart';
import 'package:jobtracker_pro/models/interview.dart';
import 'package:jobtracker_pro/models/job_application.dart';

void main() {
  group('JobApplication serialization', () {
    test('round-trips through toMap/fromMap', () {
      final app = JobApplication(
        id: 'a',
        company: 'Acme',
        title: 'Dev',
        appliedAt: DateTime(2026, 10, 1),
        status: ApplicationStatus.interview,
        contractType: ContractType.freelance,
        salary: '50k',
        followUpAt: DateTime(2026, 10, 8),
        interviews: [Interview(place: 'Paris')],
      );

      final copy = JobApplication.fromMap(app.toMap());

      expect(copy.status, ApplicationStatus.interview);
      expect(copy.contractType, ContractType.freelance);
      expect(copy.salary, '50k');
      expect(copy.appliedAt, DateTime(2026, 10, 1));
      expect(copy.followUpAt, DateTime(2026, 10, 8));
      expect(copy.interviews.single.place, 'Paris');
    });

    test('stores enums by name', () {
      final map = JobApplication(
              id: 'a', company: 'c', title: 't', status: ApplicationStatus.sent)
          .toMap();
      expect(map['status'], 'sent');
      expect(map['contractType'], 'cdi');
    });

    test('reads the legacy index format', () {
      final app = JobApplication.fromMap(
          {'id': 'a', 'company': 'c', 'title': 't', 'status': 2, 'contractType': 1});
      expect(app.status, ApplicationStatus.followUp);
      expect(app.contractType, ContractType.cdd);
    });

    test('falls back on invalid data instead of throwing', () {
      final app = JobApplication.fromMap({
        'id': 'a',
        'status': 42,
        'contractType': 'unknown',
        'appliedAt': 'not a date',
        'followUpAt': 'nope',
      });
      expect(app.status, ApplicationStatus.prepare);
      expect(app.contractType, ContractType.cdi);
      expect(app.followUpAt, isNull);
    });
  });

  group('JobApplication.copyWith', () {
    final original = JobApplication(
      id: 'a',
      company: 'Acme',
      title: 'Dev',
      notes: 'keep me',
      salary: '50k',
      followUpAt: DateTime(2026, 10, 8),
      interviews: [Interview(place: 'Paris')],
    );

    test('keeps fields that are not given', () {
      final copy = original.copyWith(company: 'Globex');
      expect(copy.id, 'a');
      expect(copy.company, 'Globex');
      expect(copy.notes, 'keep me');
      expect(copy.salary, '50k');
      expect(copy.followUpAt, DateTime(2026, 10, 8));
      expect(copy.interviews, hasLength(1));
    });

    test('clears a nullable field when given null', () {
      final copy = original.copyWith(followUpAt: null);
      expect(copy.followUpAt, isNull);
      expect(original.followUpAt, isNotNull);
    });

    test('does not share the interviews list', () {
      final copy = original.copyWith();
      copy.interviews.add(Interview());
      expect(original.interviews, hasLength(1));
    });
  });
}
