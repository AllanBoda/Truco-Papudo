import '../Class/Cartas.dart';

class playerModel {
  String nome;
  int ID;
  int equipe;
  List<Cartas> maoJogador = [];

  playerModel({
    required this.nome,
    required this.ID,
    required this.equipe,
    required this.maoJogador,
  });
}
