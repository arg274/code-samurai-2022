import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:codesamuraiproto2022/model/project.dart';
import 'package:codesamuraiproto2022/theme/constants.dart';
import 'package:transparent_image/transparent_image.dart';

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
              Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(cardRadius)),
                  child: AspectRatio(
                    aspectRatio: 1200 / 627,
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: MemoryImage(kTransparentImage),
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/no_img.jpg',
                            fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7.5, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Text(project.category,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 12.0, 20.0, 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 4.0),
                      margin: const EdgeInsets.all(1.0),
                      child: IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(FeatherIcons.copy),
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
                            child: Text(project.description,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
