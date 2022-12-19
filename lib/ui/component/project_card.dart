import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:codesamuraiproto2022/model/project.dart';
import 'package:codesamuraiproto2022/theme/constants.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard(
      {Key? key,
        required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardColor.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius)),
        shadowColor: Colors.transparent,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () => {},
          onLongPress: () => {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 20.0, 4.0),
                      margin: const EdgeInsets.all(2.0),
                      child: Icon(
                        FeatherIcons.mapPin,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(project.name,
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(project.agency,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Text(
                            '${DateFormat.yMMMMd().format(project.start)} - ${DateFormat.yMMMMd().format(project.start)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 0.0),
                            child: Text(project.description,
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  insertDuoStat(
                      context,
                      CircularPercentIndicator(
                        radius: 35.0,
                        lineWidth: 5.0,
                        percent: project.completion / 100,
                        center: Text(
                          '${project.completion}%',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        progressColor: Colors.teal,
                      ),
                      'Completion'),
                  insertDuoStat(context,
                      Text(
                        project.budget.replaceFirst('JPY ', ''),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      'Budget'
                  ),
                  insertDuoStat(context,
                      Text(
                        project.start.calendarDaysTill(
                            project.end.year,
                            project.end.month,
                            project.end.day).toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      'Days Left')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget insertDuoStat(BuildContext context, Widget top, String stat) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        top,
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: Text(
            stat,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        )
      ],
    ),
  );
}