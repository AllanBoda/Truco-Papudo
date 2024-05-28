import 'package:flutter/material.dart';
import './Class/Cartas.dart';
import 'PlayerHand.dart';
import './Class/Game.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final Game game = Game();

  @override
  void initState() {
    super.initState();
    game.iniciarJogo();
  }

  List<String> converterCartasParaString(List<Cartas> cartas) {
    return cartas.map((carta) => carta.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PlayerHand(
              hand: converterCartasParaString(
                  game.baralho.listaJogador[0].maoJogador),
              showHand: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlayerHand(
                  hand: converterCartasParaString(
                      game.baralho.listaJogador[1].maoJogador),
                  vertical: true,
                  showHand: true,
                ),
                const Spacer(flex: 5),
                PlayerHand(
                  hand: converterCartasParaString(
                      game.baralho.listaJogador[2].maoJogador),
                  vertical: true,
                  showHand: true,
                ),
              ],
            ),
            PlayerHand(
              hand: converterCartasParaString(
                  game.baralho.listaJogador[3].maoJogador),
              showHand: true,
            ),
          ],
        ),
      ),
    );
  }
}
