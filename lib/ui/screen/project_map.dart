import 'package:flutter/material.dart';

class ProjectMap extends StatefulWidget {
  const ProjectMap({Key? key}) : super(key: key);

  @override
  State<ProjectMap> createState() => _ProjectMapState();
}

class _ProjectMapState extends State<ProjectMap> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text(
      'Map will go here',
      style: Theme.of(context).textTheme.bodyText1,
    )),
  );
}