import 'package:event_app/blocs/map_bloc.dart';
import 'package:event_app/pages/map_page.dart';
import 'package:event_app/repositories/map_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'credentials.env');
  runApp(const EventApp());
}

class EventApp extends StatelessWidget {
  const EventApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MapRepository(),
      child: BlocProvider(
        create: (context) =>
            MapBloc(mapRepository: context.read<MapRepository>())..add(MapInitializeCoordinatesEvent()),
        child: const MaterialApp(
          title: 'Event App',
          home: MapPage(),
        ),
      ),
    );
  }
}
