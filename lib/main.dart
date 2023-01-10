import 'package:app/service/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Nunito'),
          home: Auth(),
          debugShowCheckedModeBanner: false,
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => NotificationService())
        ]);
  }
}
