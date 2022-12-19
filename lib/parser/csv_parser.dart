import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class CsvParser {
  static final CsvParser _singleton = CsvParser._internal();
  final _projectsCsv = rootBundle.loadString('assets/projects.csv');

  factory CsvParser() {
    return _singleton;
  }

  CsvParser._internal();

  Future<List<List<dynamic>>> getRawList() async {
    var projectsRaw = await _projectsCsv;
    var projectsRawList = const CsvToListConverter().convert(projectsRaw).toList();
    projectsRawList.removeAt(0);
    return projectsRawList;
  }
}