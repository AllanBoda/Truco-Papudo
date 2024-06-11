import 'PlayerModel.dart';

class teamModel {
  String nome;
  int id;
  List<playerModel> jogadores;
  int pontos;

  teamModel({
    required this.nome,
    required this.id,
    List<playerModel>? jogadores,
    this.pontos = 0,
  }) : jogadores = jogadores ?? [];
}
