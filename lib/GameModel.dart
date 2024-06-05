import 'package:flutter/material.dart';
import 'CardModel.dart';

class GameModel extends ChangeNotifier {
  List<CardModel> deck = []; // Inicie o baralho
  List<CardModel> playerHand = []; // Mão do jogador
  List<CardModel> opponentHand = []; // Mão do oponente
  bool isPlayerTurn = true;

  GameModel() {
    _initializeDeck();
    _dealCards();
  }

  void _initializeDeck() {
    // Inicialize o baralho com as cartas do truco
  }

  void _dealCards() {
    // Distribua as cartas para os jogadores
  }

  void playCard(int index) {
    if (isPlayerTurn) {
      // Lógica para o jogador jogar uma carta
      CardModel playedCard = playerHand.removeAt(index);
      // Atualize o estado do jogo com a carta jogada
      isPlayerTurn = false;
    } else {
      // Lógica para o oponente jogar uma carta
      isPlayerTurn = true;
    }
    notifyListeners();
  }
}
