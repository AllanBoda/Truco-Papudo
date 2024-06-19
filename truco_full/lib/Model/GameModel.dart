
import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Model/PlayerModel.dart';

import './TeamModel.dart';

class gameModel {
  List<PlayerModel> jogadorAtual;
  List<PlayerModel> jogadorQueTrucou;
  List<PlayerModel> jogadorQueAceitou;
  List<PlayerModel> jogador;
  List<CardModel> cartas;
  List<CardModel> manilha;
  List<TeamModel> equipe1;
  List<TeamModel> equipe2;
  int? valorTruco;
  int rodada;
  bool trucoAceito;
  bool sairJogo;
  bool jogarNovamente;
  bool vencedorRodada;

  gameModel({
    required this.jogadorAtual,
    required this.jogadorQueTrucou,
    required this.jogadorQueAceitou,
    required this.jogador,
    required this.cartas,
    required this.manilha,
    required this.equipe1,
    required this.equipe2,
    required this.valorTruco,
    required this.rodada,
    required this.trucoAceito,
    required this.sairJogo,
    required this.jogarNovamente,
    required this.vencedorRodada,
  });
}
