import 'dart:io';

import 'package:flutter/material.dart';
import 'package:objectbox_example/home_page.dart';

import 'objectbox.g.dart';

late final Store store;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = await openStore();
  if (Sync.isAvailable()) {
    Sync.client(
      store,
      Platform.isAndroid ? 'ws://10.0.2.2:9999' : 'ws://127.0.0.1:9999',
      SyncCredentials.none(),
    ).start();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
