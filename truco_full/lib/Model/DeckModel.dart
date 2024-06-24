
import 'package:truco_full/Model/CardModel.dart';
import 'package:truco_full/Model/PlayerModel.dart';

/// A classe `deckModel` representa uma estrutura que combina uma lista de cartas,
/// uma carta específica e um jogador associado.
class DeckModel {
  /// Lista de cartas contida neste modelo de baralho.
  late List<CardModel> cartas;

  /// Carta específica associada a este modelo de baralho.
  late CardModel carta;

  /// Jogador associado a este modelo de baralho.
  late PlayerModel jogador;

  /// Construtor da classe `deckModel`.
  /// 
  /// @param cartas Lista de cartas para inicializar o modelo de baralho.
  /// @param jogador Jogador associado ao modelo de baralho.
  /// @param carta Carta específica associada ao modelo de baralho.
  DeckModel({
    required this.cartas,
    required this.jogador,
    required this.carta,
  });
}
