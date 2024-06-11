import './CardModel.dart';
import './PlayerModel.dart';

class CartasNaMesa {
  List<cardModel> carta;
  List<cardModel> manilha;
  List<playerModel> player;
  bool trucoPediu;

  CartasNaMesa({
    required this.carta,
    required this.manilha,
    required this.player,
    required this.trucoPediu,
  });
}
