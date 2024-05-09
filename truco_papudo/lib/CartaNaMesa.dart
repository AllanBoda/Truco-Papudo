import 'Cartas.dart';
import 'Jogador.dart';

class CartaNaMesa {
  late Cartas? carta;
  late Jogador jogador;
  late bool truco;
  late bool aceitouTruco;
  late bool aumentouTruco;
  late bool disistiuTruco;
  late bool trucoPediu;

  CartaNaMesa(this.carta, this.jogador,{this.trucoPediu = false});

  //ainda falta defenir a logica ....
  bool setTruco(){
    return truco;
  }

  bool setAceitouTruco(){
    return aceitouTruco;
  }

  bool setAumentouTruco(){
    return aumentouTruco;
  }

  bool setDisistiuTruco(){
    return disistiuTruco;
  }

  @override
   @override
  String toString() {
    return "Carta: $carta - Jogador: ${jogador.nome}, Equipe: ${jogador.equipe}";
  }
}
