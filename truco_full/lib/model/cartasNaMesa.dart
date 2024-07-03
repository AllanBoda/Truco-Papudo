import 'package:truco_full/model/cardModel.dart';
import 'playerModel.dart';

/// A classe `CartaNaMesa` representa uma carta que foi jogada na mesa durante o jogo de truco.
/// Mantém informações sobre a carta jogada, o jogador que a jogou e se um truco 
/// foi pedido durante essa jogada.
class CartaNaMesa {
  late CardModel? carta;
  late PlayerModel jogador;
  late bool trucoPediu;

  /// Construtor da classe `CartaNaMesa`.
  /// 
  /// @param carta A carta que foi jogada na mesa.
  /// @param jogador O jogador que jogou a carta.
  /// @param trucoPediu Indica se o jogador pediu truco durante esta jogada (default: false).
  CartaNaMesa(this.carta, this.jogador, {this.trucoPediu = false}) {
    // Garante que a propriedade cardOwner de CardModel seja definida corretamente
    if (carta != null) {
      carta!.cardOwner = jogador.id;
    }
  }

  /// Sobrescrita do método `toString()` para formatar a representação textual da carta na mesa.
  /// 
  /// @return Uma string que descreve a carta jogada e o jogador que a jogou.
  @override
  String toString() {
    return "Carta: $carta - Jogador: ${jogador.nome}, Equipe: ${jogador.equipe}";
  }
}
