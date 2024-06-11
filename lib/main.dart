import 'package:flutter/material.dart';
import 'BoardPage.dart'; // Importe o arquivo onde está a classe BoardPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Jogo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BoardPage(), // Defina BoardPage como a tela inicial do seu aplicativo
    );
  }
}