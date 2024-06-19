import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Class/playerPosition.dart';

class PlayerModel {
 late String nome;
  late int id;
  late int equipe;
  late List<CardModel> maoJogador = [];
  late int pontos;
   late PlayerPosition position;

  
  PlayerModel.vazio();

   PlayerModel(this.nome, this.id, this.equipe,this.position,[List<CardModel>? maoJogador]) {
    pontos = 0; // Definindo os pontos como zero
    if (maoJogador != null) {
      this.maoJogador = maoJogador;
    }
  }

   List<CardModel> getMaoJogador(List<CardModel> mao){
    return maoJogador = mao;
  }

  String SetNome(){
    return nome;
  }
}


