<<<<<<< HEAD
import 'package:truco_full/Model/cardModel.dart';


class PlayerModel {
 late String nome;
  late int id;
  late int equipe;
  late List<CardModel> maoJogador = [];
  late int pontos;

  
  PlayerModel.vazio();

   PlayerModel(this.nome, this.id, this.equipe,[List<CardModel>? maoJogador]) {
    pontos = 0; // Definindo os pontos como zero
    if (maoJogador != null) {
      this.maoJogador = maoJogador;
    }
  }

   List<CardModel> getMaoJogador(List<CardModel> mao){
    return maoJogador = mao;
  }
=======
class CardModel {
  late String faceValue;
  late int value;
  late int naipe;
  late String faceUrl;

  CardModel({
    required this.faceValue,
    required this.value,
    required this.naipe,
    required this.faceUrl,
  });

   CardModel.cards({
    required this.value,
    required this.naipe
  }): faceUrl = "" , faceValue = "";
  
  CardModel.vazio();
>>>>>>> 71f8a643218226bfdd4ab34cff6201c6fcc92e3a
}

