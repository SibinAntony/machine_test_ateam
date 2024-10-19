import 'package:door_step_customer/provider/home_provider.dart';
import 'package:door_step_customer/ui/home_screen.dart';
import 'package:door_step_customer/ui/saved_trips_screen.dart';
import 'package:door_step_customer/ui/trip_screen.dart';
import 'package:door_step_customer/ui/widgets/trip_map_widget.dart';
import 'package:door_step_customer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'di_container.dart' as di;
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // MapboxOptions.setAccessToken(ACCESS_TOKEN);

  // String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  print('Access token : $ACCESS_TOKEN');


  await Hive.initFlutter();
  await Hive.openBox(tripHiveBox);

  // runApp(const MyApp());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: HomeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      initialRoute: '/home_screen',
      routes: {
        '/home_screen': (context) => const HomeScreen(),
        '/saved_trip_screen': (context) => const SavedTripScreen(),
        '/trip_screen': (context) =>  TripScreen(),
      },
      // home: const HomeScreen(),
    );
  }
}


