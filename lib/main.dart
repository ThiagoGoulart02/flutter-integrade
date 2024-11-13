import 'package:flutter/material.dart';
import 'package:integrade/provider/itemProvider.dart';
import 'package:integrade/view/form_view.dart';
import 'package:integrade/view/home_view.dart';
import 'package:integrade/view/list_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/listaDinamica': (context) =>
            const ItemListScreen(), // Defina ListaDinamicaPage
        '/formulario': (context) => const FormularioPage(),
      },
    );
  }
}
