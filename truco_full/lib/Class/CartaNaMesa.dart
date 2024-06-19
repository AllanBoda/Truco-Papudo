import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Model/PlayerModel.dart';

class CartaNaMesa {
  late CardModel? carta;
  late PlayerModel jogador;
  late bool trucoPediu;

  CartaNaMesa(this.carta, this.jogador,{this.trucoPediu = false});

 
  @override
   @override
  String toString() {
    return "Carta: $carta - Jogador: ${jogador.nome}, Equipe: ${jogador.equipe}";
  }
}
