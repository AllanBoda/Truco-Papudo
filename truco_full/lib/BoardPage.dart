import 'package:flutter/material.dart';
import 'package:truco_full/CardModel.dart';
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

  List<CardModel> converterCartasParaString(List<Cartas> cartas) {
    return cartas.map((carta) {
      return CardModel(
        faceValue: '${carta.valor} de ${carta.naipe}',
        value: carta.valor,
        naipe: carta.naipe,
        faceUrl: './images/${carta.valor}_of_${carta.naipe}.png', // Update this path according to your assets structure
      );
    }).toList();
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
