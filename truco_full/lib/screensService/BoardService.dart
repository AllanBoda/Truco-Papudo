import 'package:flutter/material.dart'; // Importação do pacote Flutter Material
import 'package:truco_full/Model/CardModel.dart'; // Importação do modelo CardModel
import 'package:truco_full/Model/CartasNaMesa.dart'; // Importação do modelo CartasNaMesa
import 'package:truco_full/Model/PlayerModel.dart'; // Importação do modelo PlayerModel
import '../Service/Game.dart'; // Importação do serviço Game

/// Classe responsável pela lógica do jogo Truco.
class GameLogic {
  final Game game; // Instância do jogo atual
  final BuildContext context; // Contexto do Build para exibição de dialogs
  int jogadoresQueJogaram = 0; // Quantidade de jogadores que já jogaram na rodada atual
  bool cartaTocada = false; // Indica se uma carta foi tocada

  /// Construtor de GameLogic.
  ///
  /// [game] - Instância do jogo.
  /// [context] - Contexto do Build para exibição de dialogs.
  GameLogic(this.game, this.context);

  /// Construtor vazio que inicializa um novo jogo.
  ///
  /// [defaultContext] - Contexto padrão para exibição de dialogs.
  GameLogic.empty(BuildContext defaultContext)
      : game = Game(), // Inicializa game com uma nova instância de Game
        context = defaultContext; // Inicializa context com null

  /// Método para jogar uma carta.
  ///
  /// [index] - Índice da carta na mão do jogador.
  /// [jogador] - Jogador que está jogando a carta.
  /// [atualizarEstado] - Função para atualizar o estado do jogo na interface.
  void jogarCarta(int index, PlayerModel jogador, Function atualizarEstado) {
    if (cartaTocada && jogadoresQueJogaram <= 2 && jogador == game.jogadorAtual) {
      game.escolherCartaDaJogada(index, jogador); // Escolhe a carta para a jogada
      jogadoresQueJogaram++;
      cartaTocada = false;
      game.jogadorAtual = game.proximoJogador()!;

      if (jogadoresQueJogaram == 2) {
        game.iniciarRodada(); // Inicia uma nova rodada após os jogadores jogarem
        jogadoresQueJogaram = 0;

        PlayerModel? vencedor = verificarCampeao();
        if (vencedor != null) {
          _mostrarCampeao(vencedor, atualizarEstado); // Mostra o diálogo de campeão
        }
      }
    } else {
      game.iniciarJogo(); // Inicia o jogo se as condições para jogar uma carta não forem atendidas
    }
    atualizarEstado(); // Atualiza o estado da interface do jogo
  }

  /// Verifica se há um vencedor com base nos pontos dos jogadores.
  ///
  /// Retorna o jogador vencedor ou null se nenhum jogador atingiu a pontuação necessária.
  PlayerModel? verificarCampeao() {
    for (var jogador in game.definicaCartasBaralho.listaJogador) {
      if (jogador.pontos >= 12) {
        return jogador; // Retorna o jogador que atingiu a pontuação de vitória
      }
    }
    return null; // Retorna null se nenhum jogador atingiu a pontuação de vitória
  }

  /// Mostra o diálogo com o campeão do jogo.
  ///
  /// [vencedor] - Jogador que venceu o jogo.
  /// [atualizarEstado] - Função para atualizar o estado do jogo na interface.
  void _mostrarCampeao(PlayerModel vencedor, Function atualizarEstado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Campeão!'),
          content: Text('${vencedor.nome} é o campeão com ${vencedor.pontos} pontos!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo de campeão
                _resetarPlacar(); // Reseta o placar dos jogadores
                game.iniciarJogo(); // Inicia um novo jogo
                atualizarEstado(); // Atualiza o estado da interface do jogo
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Reseta o placar dos jogadores para zero.
  void _resetarPlacar() {
    for (var jogador in game.definicaCartasBaralho.listaJogador) {
      jogador.pontos = 0; // Define os pontos de todos os jogadores como zero
    }
  }

  /// Converte a lista de cartas na mesa para uma lista de modelos de cartas exibíveis.
  ///
  /// [cartasNaMesa] - Lista de objetos CartaNaMesa.
  List<CardModel> converterCartasNaMesaParaString(List<CartaNaMesa> cartasNaMesa) {
    return cartasNaMesa.map((cartaNaMesa) {
      return CardModel(
        faceValue: '${cartaNaMesa.carta?.value} de ${cartaNaMesa.carta?.naipe}',
        value: cartaNaMesa.carta?.value ?? 0,
        naipe: cartaNaMesa.carta?.naipe ?? 0,
        faceUrl: ""
      );
    }).toList();
  }

  /// Converte a lista de cartas do jogador para uma lista de modelos de cartas exibíveis.
  ///
  /// [cartas] - Lista de objetos CardModel.
  List<CardModel> converterCartasParaString(List<CardModel> cartas) {
    return cartas.map((carta) {
      return CardModel(
        faceValue: '${carta.value} de ${carta.naipe}',
        value: carta.value,
        naipe: carta.naipe,
        faceUrl: ""
      );
    }).toList();
  }
}
