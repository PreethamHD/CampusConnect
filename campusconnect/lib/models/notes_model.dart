// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SemesterModel {
  final String sem;
  final List<SubjectModel> subjects;
  SemesterModel({required this.sem, required this.subjects});

  SemesterModel copyWith({String? sem, List<SubjectModel>? subjects}) {
    return SemesterModel(
      sem: sem ?? this.sem,
      subjects: subjects ?? this.subjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sem': sem,
      'subjects': subjects.map((x) => x.toMap()).toList(),
    };
  }

  factory SemesterModel.fromMap(Map<String, dynamic> map) {
    return SemesterModel(
      sem: map['sem'] as String,
      subjects: List<SubjectModel>.from(
        (map['subjects'] as List).map<SubjectModel>(
          (x) => SubjectModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SemesterModel.fromJson(String source) =>
      SemesterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SemesterModel(sem: $sem, subjects: $subjects)';

  @override
  bool operator ==(covariant SemesterModel other) {
    if (identical(this, other)) return true;

    return other.sem == sem && listEquals(other.subjects, subjects);
  }

  @override
  int get hashCode => sem.hashCode ^ subjects.hashCode;
}

class SubjectModel {
  final String subject;
  final List<NotesModel> notes;
  SubjectModel({required this.subject, required this.notes});

  SubjectModel copyWith({String? subject, List<NotesModel>? notes}) {
    return SubjectModel(
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subject': subject,
      'notes': notes.map((x) => x.toMap()).toList(),
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      subject: map['subject'] as String,
      notes: List<NotesModel>.from(
        (map['notes'] as List).map<NotesModel>(
          (x) => NotesModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectModel.fromJson(String source) =>
      SubjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SubjectModel(subject: $subject, notes: $notes)';

  @override
  bool operator ==(covariant SubjectModel other) {
    if (identical(this, other)) return true;

    return other.subject == subject && listEquals(other.notes, notes);
  }

  @override
  int get hashCode => subject.hashCode ^ notes.hashCode;
}

class NotesModel {
  final String notesname;
  final String links;
  NotesModel({required this.notesname, required this.links});

  NotesModel copyWith({String? notesname, String? links}) {
    return NotesModel(
      notesname: notesname ?? this.notesname,
      links: links ?? this.links,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'notesname': notesname, 'links': links};
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      notesname: map['notesname'] as String,
      links: map['links'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotesModel.fromJson(String source) =>
      NotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotesModel(notesname: $notesname, links: $links)';

  @override
  bool operator ==(covariant NotesModel other) {
    if (identical(this, other)) return true;

    return other.notesname == notesname && other.links == links;
  }

  @override
  int get hashCode => notesname.hashCode ^ links.hashCode;
}
