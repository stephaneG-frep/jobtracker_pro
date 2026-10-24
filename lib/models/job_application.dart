import 'dart:convert';

import 'interview.dart';

enum ApplicationStatus { prepare, sent, followUp, interview, rejected, accepted }
enum ContractType { cdi, cdd, interim, alternance, stage, freelance }

// Marks a nullable copyWith argument as "not provided", so null can mean "clear".
const Object _unset = Object();

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

  JobApplication copyWith({
    String? company,
    String? title,
    Object? url = _unset,
    DateTime? appliedAt,
    ApplicationStatus? status,
    ContractType? contractType,
    String? city,
    Object? salary = _unset,
    Object? contactName = _unset,
    Object? contactEmail = _unset,
    Object? contactPhone = _unset,
    Object? notes = _unset,
    Object? followUpAt = _unset,
    List<Interview>? interviews,
  }) {
    T? pick<T>(Object? value, T? current) =>
        identical(value, _unset) ? current : value as T?;

    return JobApplication(
      id: id,
      company: company ?? this.company,
      title: title ?? this.title,
      url: pick<String>(url, this.url),
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
      contractType: contractType ?? this.contractType,
      city: city ?? this.city,
      salary: pick<String>(salary, this.salary),
      contactName: pick<String>(contactName, this.contactName),
      contactEmail: pick<String>(contactEmail, this.contactEmail),
      contactPhone: pick<String>(contactPhone, this.contactPhone),
      notes: pick<String>(notes, this.notes),
      followUpAt: pick<DateTime>(followUpAt, this.followUpAt),
      interviews: List.of(interviews ?? this.interviews),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'title': title,
      'url': url,
      'appliedAt': appliedAt.toIso8601String(),
      'status': status.name,
      'contractType': contractType.name,
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
      appliedAt: _parseDate(map['appliedAt']) ?? DateTime.now(),
      status: _parseEnum(map['status'], ApplicationStatus.values, ApplicationStatus.prepare),
      contractType: _parseEnum(map['contractType'], ContractType.values, ContractType.cdi),
      city: map['city'] ?? '',
      salary: map['salary'],
      contactName: map['contactName'],
      contactEmail: map['contactEmail'],
      contactPhone: map['contactPhone'],
      notes: map['notes'],
      followUpAt: _parseDate(map['followUpAt']),
      interviews: map['interviews'] is List
          ? List<Interview>.from((map['interviews'] as List).map((m) => Interview.fromMap(Map<String, dynamic>.from(m))))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory JobApplication.fromJson(String source) => JobApplication.fromMap(json.decode(source));
}

DateTime? _parseDate(Object? value) => value is String ? DateTime.tryParse(value) : null;

// Accepts the enum name (current format) or its index (legacy format).
T _parseEnum<T extends Enum>(Object? value, List<T> values, T fallback) {
  if (value is String) {
    for (final v in values) {
      if (v.name == value) return v;
    }
  } else if (value is int && value >= 0 && value < values.length) {
    return values[value];
  }
  return fallback;
}
