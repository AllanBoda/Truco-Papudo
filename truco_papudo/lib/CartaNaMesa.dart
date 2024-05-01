import 'Cartas.dart';
import 'Jogador.dart';

class CartaNaMesa {
  late Cartas? carta;
  late Jogador jogador;

  CartaNaMesa(this.carta, this.jogador);

  @override
   @override
  String toString() {
    return "Carta: $carta - Jogador: ${jogador.nome}, Equipe: ${jogador.equipe}";
  }
}
