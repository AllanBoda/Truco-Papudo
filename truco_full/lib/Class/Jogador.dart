import 'package:truco_full/Model/cardModel.dart';

import 'baralho.dart';


class Jogador {
  late String nome;
  late int id;
  late int equipe;
  late List<cardModel> maoJogador = [];
  late int pontos;
  late List<Jogador> listaJogador = [];
  Baralho baralho = Baralho();
 
  Jogador.Vazio();
   Jogador(this.nome, this.id, this.equipe,[List<cardModel>? maoJogador]) {
    this.pontos = 0; // Definindo os pontos como zero
    if (maoJogador != null) {
      this.maoJogador = maoJogador;
    }
  }

  void atualizarPontos(int novosPontos) {
    this.pontos = novosPontos;
  }

  String SetNome(){
    return nome;
  }

  List<cardModel> getMaoJogador(List<cardModel> mao){
    return maoJogador = mao;
  }

  
  @override
  String toString(){
    return "$nome-$id,Equipe:$equipe,Pontos:$pontos/r Mão:${maoJogador}";
  }

}