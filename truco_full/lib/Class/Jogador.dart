import 'Cartas.dart';

class Jogador {
  final String nome;
  final int id;
  final int time;
  int pontos;
  List<Cartas> maoJogador;

  Jogador(this.nome, this.id, this.time, this.pontos, this.maoJogador);

  @override
  String toString() {
    return '$nome (Time $time): ${maoJogador.join(', ')}';
  }

  String SetNome() {
    return nome;
  }
}
