import 'package:codesamuraiproto2022/model/project.dart';
import 'package:codesamuraiproto2022/parser/csv_parser.dart';
import 'package:codesamuraiproto2022/theme/constants.dart';
import 'package:codesamuraiproto2022/ui/component/project_card.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'; // ignore: unnecessary_import
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CustomMarker extends StatefulWidget {
  const CustomMarker({super.key});

  @override
  State createState() => CustomMarkerState();
}

class CustomMarkerState extends State<CustomMarker> {
  final Random _rnd = new Random();

  late MapboxMapController _mapController;
  List<Marker> _markers = [];
  List<_MarkerState> _markerStates = [];

  void _addMarkerStates(_MarkerState markerState) {
    _markerStates.add(markerState);
  }

  void _onStyleLoadedCallback() {
    print('onStyleLoadedCallback');
  }

  void _onMapLongClickCallback(Point<double> point, LatLng coordinates) {
    _addMarker(point, coordinates);
  }

  void _onCameraIdleCallback() {
    _updateMarkerPosition();
  }

  void _updateMarkerPosition() {
    final coordinates = <LatLng>[];

    for (final markerState in _markerStates) {
      coordinates.add(markerState.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) {
      _markerStates.asMap().forEach((i, value) {
        _markerStates[i].updatePosition(points[i]);
      });
    });
  }

  void _addMarker(Point<double> point, LatLng coordinates) {
    setState(() {
      _markers.add(Marker(_rnd.nextInt(100000).toString(), coordinates, point,
          _addMarkerStates));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CsvParser().getRawList(),
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

          child = Scaffold(
            body: Stack(children: [
              MapboxMap(
                accessToken: 'sk.eyJ1IjoiZGVlcGFyZ2h5YSIsImEiOiJjbGJ2MHNxZHoxdG5mM3FrZTgydGFmcXo3In0.LPXgsgGp9tBc54I0kF2s3A',
                trackCameraPosition: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                  controller.addListener(() {
                    if (controller.isCameraMoving) {
                      _updateMarkerPosition();
                    }
                  });
                  var param = <LatLng>[];
                  for (var project in projects) {
                    for (var coord in project.coords) {
                      param.add(LatLng(coord.lat, coord.long));
                    }
                  }

                  _mapController.toScreenLocationBatch(param).then((value) {
                    for (var i = 0; i < param.length; i++) {
                      var point =
                      Point<double>(value[i].x as double, value[i].y as double);
                      _addMarker(point, param[i]);
                    }
                  });
                },
                onMapLongClick: _onMapLongClickCallback,
                onCameraIdle: _onCameraIdleCallback,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                initialCameraPosition:
                CameraPosition(target: LatLng(projects[0].coords[0].lat, projects[0].coords[0].long), zoom: 16),
              ),
              IgnorePointer(
                  ignoring: true,
                  child: Stack(
                    children: _markers,
                  ))
            ]),
          );
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
    );
  }
}

class Marker extends StatefulWidget {
  final Point _initialPosition;
  final LatLng _coordinate;
  final void Function(_MarkerState) _addMarkerState;

  Marker(
      String key, this._coordinate, this._initialPosition, this._addMarkerState)
      : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = _MarkerState(_initialPosition);
    _addMarkerState(state);
    return state;
  }
}

class _MarkerState extends State with TickerProviderStateMixin {
  final _iconSize = 20.0;

  Point _position;

  late AnimationController _controller;
  late Animation<double> _animation;

  _MarkerState(this._position);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ratio = 1.0;

    //web does not support Platform._operatingSystem
    if (!kIsWeb) {
      // iOS returns logical pixel while Android returns screen pixel
      ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }

    return Positioned(
        left: _position.x / ratio - _iconSize / 2,
        top: _position.y / ratio - _iconSize / 2,
        child: Icon(FeatherIcons.mapPin)
    );
  }

  void updatePosition(Point<num> point) {
    setState(() {
      _position = point;
    });
  }

  LatLng getCoordinate() {
    return (widget as Marker)._coordinate;
  }
}

class ProjectMap extends StatefulWidget {
  const ProjectMap({Key? key}) : super(key: key);

  @override
  State<ProjectMap> createState() => _ProjectMapState();
}

class _ProjectMapState extends State<ProjectMap> {
  @override
  Widget build(BuildContext context) => CustomMarker();
}