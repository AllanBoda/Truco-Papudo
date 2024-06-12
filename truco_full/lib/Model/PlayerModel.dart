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
}
