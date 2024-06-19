import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Model/PlayerModel.dart';

class deckModel {
  List<CardModel> cartas;
  CardModel carta;
  PlayerModel jogador;

  deckModel({
    required this.cartas,
    required this.jogador,
    required this.carta
  });
}
