import 'package:event_app/blocs/map_bloc.dart';
import 'package:event_app/pages/map_page.dart';
import 'package:event_app/repositories/map_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
