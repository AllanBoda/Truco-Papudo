
import 'Baralho.dart';
import 'Cartas.dart';

class Jogador {
  late String nome;
  late int id;
  late int equipe;
  late List<Cartas> maoJogador = [];
  late int pontos;
  late List<Jogador> listaJogador = [];
  Baralho baralho = Baralho();
 
  Jogador.Vazio();
   Jogador(this.nome, this.id, this.equipe,[List<Cartas>? maoJogador]) {
    this.pontos = 0; // Definindo os pontos como zero
    if (maoJogador != null) {
      this.maoJogador = maoJogador;
    }
  }

  void atualizarPontos(int novosPontos) {
    this.pontos = novosPontos;
  }
  
  int SetPontos(){
    return pontos;
  }
  String SetNome(){
    return nome;
  }

  List<Cartas> getMaoJogador(List<Cartas> mao){
    return maoJogador = mao;
  }

  
  @override
  String toString(){
    return "$nome-$id,Equipe:$equipe,Pontos:$pontos/r Mão:${maoJogador}";
  }

}
