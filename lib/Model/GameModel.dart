import './CardModel.dart';
import './PlayerModel.dart';
import './TeamModel.dart';

class gameModel {
  List<playerModel> jogadorAtual;
  List<playerModel> jogadorQueTrucou;
  List<playerModel> jogadorQueAceitou;
  List<playerModel> jogador;
  List<cardModel> cartas;
  List<cardModel> manilha;
  List<teamModel> equipe1;
  List<teamModel> equipe2;
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
