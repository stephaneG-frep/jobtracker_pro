class Interview {
  DateTime dateTime;
  String place;
  String withPerson;
  String notes;

  Interview({
    DateTime? dateTime,
    this.place = '',
    this.withPerson = '',
    this.notes = '',
  }) : dateTime = dateTime ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'place': place,
      'withPerson': withPerson,
      'notes': notes,
    };
  }

  factory Interview.fromMap(Map<String, dynamic> map) {
    return Interview(
      dateTime: map['dateTime'] != null ? DateTime.parse(map['dateTime']) : DateTime.now(),
      place: map['place'] ?? '',
      withPerson: map['withPerson'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}
