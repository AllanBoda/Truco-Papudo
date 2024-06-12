

import 'package:truco_full/Model/PlayerModel.dart';

class TeamModel {
  String nome;
  int id;
  List<PlayerModel> jogadores;
  int pontos;

  TeamModel({
    required this.nome,
    required this.id,
    List<PlayerModel>? jogadores,
    this.pontos = 0,
  }) : jogadores = jogadores ?? [];
}
