import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/bici_api.dart';
import 'data/bici_repository.dart';
import 'viewmodels/stations_vm.dart';
import 'views/home_page.dart';

void main() {
  final api = BiciApi();
  final repo = BiciRepository(api);

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final BiciRepository repo;

  const MyApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StationsVm(repo),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BiciCoruña - App Alternativa',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}


