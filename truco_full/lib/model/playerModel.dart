import 'package:truco_full/enum/playerPosition.dart'; // Importação da enumeração PlayerPosition
import 'package:truco_full/model/cardModel.dart'; // Importação do modelo CardModel

/// Classe que representa um jogador no jogo de truco.
class PlayerModel {
  late String nome; // Nome do jogador
  late int id; // Identificador único do jogador
  late int equipe; // Equipe à qual o jogador pertence
  late List<CardModel> maoJogador = []; // Lista de cartas na mão do jogador
  int pontos = 0; // Pontuação atual do jogador
  late PlayerPosition position; // Posição do jogador (ENUM PlayerPosition)

  /// Construtor vazio de PlayerModel.
  ///
  /// Usado para criar uma instância vazia de PlayerModel.
  PlayerModel.vazio();

  /// Construtor para inicializar um jogador com os parâmetros obrigatórios.
  ///
  /// [nome] - Nome do jogador.
  /// [id] - Identificador único do jogador.
  /// [equipe] - Equipe à qual o jogador pertence.
  /// [position] - Posição do jogador no jogo (ENUM PlayerPosition).
  /// [maoJogador] - Opcional. Lista de cartas na mão do jogador.
  PlayerModel(
    this.nome,
    this.id,
    this.equipe,
    this.position, {
    List<CardModel>? maoJogador,
  }) {
    pontos = 0; // Inicializa os pontos do jogador como zero
    if (maoJogador != null) {
      this.maoJogador = maoJogador;
    }
  }

  /// Método para definir a lista de cartas na mão do jogador.
  ///
  /// [mao] - Lista de cartas na mão do jogador.
  List<CardModel> getMaoJogador(List<CardModel> mao) {
    return maoJogador = mao;
  }

  /// Método para retornar o nome do jogador.
  String setNome() {
    return nome;
  }
}
