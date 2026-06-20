import 'dart:convert';

import 'interview.dart';

enum ApplicationStatus { prepare, sent, followUp, interview, rejected, accepted }
enum ContractType { cdi, cdd, interim, alternance, stage, freelance }

class JobApplication {
  String id;
  String company;
  String title;
  String? url;
  DateTime appliedAt;
  ApplicationStatus status;
  ContractType contractType;
  String city;
  String? salary;
  String? contactName;
  String? contactEmail;
  String? contactPhone;
  String? notes;
  DateTime? followUpAt;
  List<Interview> interviews;

  JobApplication({
    required this.id,
    required this.company,
    required this.title,
    this.url,
    DateTime? appliedAt,
    this.status = ApplicationStatus.prepare,
    this.contractType = ContractType.cdi,
    this.city = '',
    this.salary,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.notes,
    this.followUpAt,
    List<Interview>? interviews,
  })  : appliedAt = appliedAt ?? DateTime.now(),
        interviews = interviews ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'title': title,
      'url': url,
      'appliedAt': appliedAt.toIso8601String(),
      'status': status.index,
      'contractType': contractType.index,
      'city': city,
      'salary': salary,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'notes': notes,
      'followUpAt': followUpAt?.toIso8601String(),
      'interviews': interviews.map((i) => i.toMap()).toList(),
    };
  }

  factory JobApplication.fromMap(Map<String, dynamic> map) {
    return JobApplication(
      id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      company: map['company'] ?? '',
      title: map['title'] ?? '',
      url: map['url'],
      appliedAt: map['appliedAt'] != null ? DateTime.parse(map['appliedAt']) : DateTime.now(),
      status: ApplicationStatus.values[(map['status'] ?? 0) as int],
      contractType: ContractType.values[(map['contractType'] ?? 0) as int],
      city: map['city'] ?? '',
      salary: map['salary'],
      contactName: map['contactName'],
      contactEmail: map['contactEmail'],
      contactPhone: map['contactPhone'],
      notes: map['notes'],
      followUpAt: map['followUpAt'] != null ? DateTime.parse(map['followUpAt']) : null,
      interviews: map['interviews'] != null
          ? List<Interview>.from((map['interviews'] as List).map((m) => Interview.fromMap(Map<String, dynamic>.from(m))))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory JobApplication.fromJson(String source) => JobApplication.fromMap(json.decode(source));
}
