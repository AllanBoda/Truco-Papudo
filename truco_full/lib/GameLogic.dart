import 'package:flutter/material.dart';
import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Class/CartaNaMesa.dart';
import 'package:truco_full/Model/PlayerModel.dart';
import './Class/Game.dart';

class GameLogic {
  final Game game;
  final BuildContext context;
  int jogadoresQueJogaram = 0;
  bool cartaTocada = false;

  GameLogic(this.game, this.context);

 // Construtor vazio
  GameLogic.empty(BuildContext defaultContext)
      : game = Game(), // Inicializa game com uma nova instância de Game
        context = defaultContext; // Inicializa context com null


  void jogarCarta(int index, PlayerModel jogador, Function atualizarEstado) {
    if (cartaTocada && jogadoresQueJogaram <= 2 && jogador == game.jogadorAtual) {
      game.escolherCartaDaJogada(index, jogador);
      jogadoresQueJogaram++;
      cartaTocada = false;
      game.jogadorAtual = game.proximoJogador()!;

      if (jogadoresQueJogaram == 2) {
        game.iniciarRodada();
        jogadoresQueJogaram = 0;

        PlayerModel? vencedor = verificarCampeao();
        if (vencedor != null) {
          _mostrarCampeao(vencedor, atualizarEstado);
        }
      }
    } else {
      game.iniciarJogo();
    }
    atualizarEstado();
  }

  PlayerModel? verificarCampeao() {
    for (var jogador in game.baralho.listaJogador) {
      if (jogador.pontos >= 12) {
        return jogador;
      }
    }
    return null;
  }

  void _mostrarCampeao(PlayerModel vencedor, Function atualizarEstado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Campeão!'),
          content: Text('${vencedor.nome} é o campeão com ${vencedor.pontos} pontos!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetarPlacar();
                game.iniciarJogo();
                atualizarEstado();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetarPlacar() {
    for (var jogador in game.baralho.listaJogador) {
      jogador.pontos = 0;
    }
  }

  // Converte a lista de cartas na mesa para uma lista de modelos de cartas exibíveis
  List<CardModel> converterCartasNaMesaParaString(List<CartaNaMesa> cartasNaMesa) {
    return cartasNaMesa.map((cartaNaMesa) {
      return CardModel(
        faceValue: '${cartaNaMesa.carta?.value} de ${cartaNaMesa.carta?.naipe}',
        value: cartaNaMesa.carta?.value ?? 0,
        naipe: cartaNaMesa.carta?.naipe ?? 0,
        faceUrl: ""
      );
    }).toList();
  }

    // Converte a lista de cartas do jogador para uma lista de modelos de cartas exibíveis
  List<CardModel> converterCartasParaString(List<CardModel> cartas) {
    return cartas.map((carta) {
      return CardModel(
        faceValue: '${carta.value} de ${carta.naipe}',
        value: carta.value,
        naipe: carta.naipe,
        faceUrl: ""
      );
    }).toList();
  }
}
