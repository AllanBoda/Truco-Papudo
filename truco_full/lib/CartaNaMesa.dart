import './Class/Cartas.dart';
import './Class/Jogador.dart';

class CartaNaMesa {
  late Cartas? carta;
  late Jogador jogador;
  late bool trucoPediu;

  CartaNaMesa(this.carta, this.jogador,{this.trucoPediu = false});

 
  @override
   @override
  String toString() {
    return "Carta: $carta - Jogador: ${jogador.nome}, Equipe: ${jogador.equipe}";
  }
}