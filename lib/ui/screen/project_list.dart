import 'package:codesamuraiproto2022/model/project.dart';
import 'package:codesamuraiproto2022/parser/csv_parser.dart';
import 'package:codesamuraiproto2022/theme/constants.dart';
import 'package:codesamuraiproto2022/ui/component/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  final rawList = CsvParser().getRawList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: FutureBuilder(
      future: rawList,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasError) {
          print(snapshot.error);
          child = Center(child: Text(
            'Error parsing CSV',
            style: Theme.of(context).textTheme.bodyText1,
          ));
        } else if (snapshot.hasData) {
          print(snapshot.data);
          List<Project> projects = [];

          for (var project in snapshot.data!) {
            projects.add(Project.fromCsvLine(project));
          }
          
          child = ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
            return Padding(
              padding: cardListEdgeInsets,
              child: ProjectCard(
                project: projects[index],
              ),
            );
          });
        } else {
          child = Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: SpinKitCubeGrid(
                  size: 100.0, color: Theme.of(context).primaryColor),
            ),
          );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: child,
        );
      },
    ),
  );
  }
}