
import 'Cartas.dart';

class Jogador {
  late String nome;
  late int id;
  late int equipe;
  late List<Cartas> maoJogador = [];
  late int pontos;
 
  Jogador.Vazio();
   Jogador(this.nome, this.id, this.equipe, this.pontos, [List<Cartas>? maoJogador]) {
    if (maoJogador != null) {
      this.maoJogador = maoJogador;
    }
  }

  int SetPontos(){
    return pontos;
  }
  String SetNome(){
    return nome;
  }

  @override
  String toString(){
    return "$nome-$id,Equipe:$equipe,Pontos:$pontos/r Mão:${maoJogador}";
  }
}
