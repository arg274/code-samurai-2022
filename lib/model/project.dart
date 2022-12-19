class Project {
  String name;
  String category;
  String agency;
  String description;
  DateTime start;
  DateTime end;
  String budget;
  double completion;
  List<Coord> coords;

  Project(this.name, this.category, this.agency, this.description, this.start,
      this.end, this.budget, this.completion, this.coords);

  factory Project.fromCsvLine(List<dynamic> csvLine) {
    String name = csvLine[0];
    String category = csvLine[1];
    String agency = csvLine[2];
    String description = csvLine[3];
    DateTime start = DateTime.parse(csvLine[4]);
    DateTime end = DateTime.parse(csvLine[5]);
    String budget = csvLine[6];
    double completion = double.parse(csvLine[7].toString().substring(0, csvLine[7].toString().length - 1));
    List<Coord> coords = [];

    // Parsing coords
    RegExp exp = RegExp(r'\(\d+.\d+, \d+.\d+\)');
    var tuplesRaw = csvLine[8].toString();
    Iterable<RegExpMatch> matches = exp.allMatches(tuplesRaw);
    for (final m in matches) {
      var tuple = m[0].toString();
      var coordSplit = tuple.substring(1, tuple.length - 1).split(', ');
      coords.add(Coord(double.parse(coordSplit[0]), double.parse(coordSplit[1])));
    }

    return Project(name, category, agency, description, start, end, budget, completion, coords);
  }
}

class Coord {
  double lat;
  double long;

  Coord(this.lat, this.long);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Coord && runtimeType == other.runtimeType && long == other.long && lat == other.lat;

  @override
  int get hashCode => (2 * long + lat).hashCode;
}