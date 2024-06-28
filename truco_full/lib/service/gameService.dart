import 'package:truco_full/model/cardModel.dart';
import 'package:truco_full/model/cartasNaMesa.dart';
import 'package:truco_full/model/playerModel.dart';
import 'package:truco_full/service/cartasServise.dart';
import 'definicaoCartasBaralhoService.dart';

/// A classe `Game` gerencia a lógica do jogo de truco, incluindo o baralho,
/// as rodadas, os jogadores e a pontuação.
class Game {
  final DefinicaoCartasBaralho definicaCartasBaralho = DefinicaoCartasBaralho();
  late PlayerModel jogadorAtual;
  PlayerModel? jogadorQueTrucou;
  PlayerModel? jogadorQueAceitou;
  PlayerModel? jogadorQueAumentouTruco;
  int? valorTruco = 3;
  int? valorTrucoAtual = 3;
  int equipe1 = 0;
  int equipe2 = 0;
  int rodada = 1;
  bool trucoAceito = false;
  bool vencedorRodada = false;
  CardModel cartas = CardModel.vazio();
  PlayerModel? jogadorUltimoVencedor;
  bool? trucoPedindo;
  List<CardModel> listForcaCartas = [];
  final CartasServise cartasServise = CartasServise();
  String mensagemFinalDeJogo = "";
  int empachou = 0;
  int ultimovencedor = 0;

  /// Inicia o jogo de truco. Define o baralho, a manilha e o jogador atual.
  void iniciarJogo() {
    definicaCartasBaralho.inicializar();
    definirJogadorAtual();
  }

  /// Define o jogador atual baseado no vencedor da última rodada ou o primeiro jogador da lista.
  void definirJogadorAtual() {
    jogadorAtual = jogadorUltimoVencedor ?? definicaCartasBaralho.listaJogador.first;
  }

  /// Escolhe uma carta da mão do jogador para jogá-la na mesa.
  ///
  /// @param indiceCarta O índice da carta na mão do jogador.
  /// @param jogador O jogador que está jogando a carta.
  /// @param pediuTruco Indica se o jogador pediu truco ao jogar a carta.
  void escolherCartaDaJogada(int indiceCarta, PlayerModel jogador, {bool pediuTruco = false}) {
    if (indiceCarta >= 0 && indiceCarta < jogador.maoJogador.length) {
      CardModel carta = jogador.maoJogador[indiceCarta];
      definicaCartasBaralho.cartasNaMesa.add(CartaNaMesa(carta, jogador, trucoPediu: pediuTruco));
      jogador.maoJogador.remove(carta);
    }
  }

  /// Inicia uma nova rodada. Define o próximo jogador e ajusta a força das cartas.
  void iniciarRodada() {
    jogadorAtual = proximoJogador()!;
    listForcaCartas = cartasServise.ajustarForcaCartas(definicaCartasBaralho.cartaVirada);
    definirGanhadorRodada(listForcaCartas, definicaCartasBaralho.cartasNaMesa, trucoAceito);
  }

  /// Define o vencedor da rodada com base na força das cartas jogadas e atualiza a pontuação.
  ///
  /// @param forcaCartas A lista de cartas ordenadas por força.
  /// @param cartasNaMesa As cartas jogadas na mesa.
  /// @param trucou Indica se houve pedido de truco na rodada.
  void definirGanhadorRodada(List<CardModel> forcaCartas, List<CartaNaMesa> cartasNaMesa, bool trucou) {
    int posicaoCartaPrimeiroJogador = forcaCartas.length;
    int posicaoCartaSegundoJogador = forcaCartas.length;
    int primeiroJogador = -1;
    int segundoJogador = -1;
    // Determinar o vencedor da rodada
    int jogadorVencedor = -1;
    int posicaoCarta = 0;

    // Determinar quem é o primeiro e o segundo jogador
    if (cartasNaMesa[0].jogador.equipe == 1) {
      primeiroJogador = 1;
      segundoJogador = 2;
    } else {
      primeiroJogador = 2;
      segundoJogador = 1;
    }


    // Criar uma nova lista com os primeiros 9 elementos de forcaCartas
    List<CardModel> primeiraParteForcaCartas = forcaCartas.take(10).toList();

    // Laço para determinar a posição das cartas jogadas por cada jogador
    for (int i = 0; i < cartasNaMesa.length; i++) {
      CartaNaMesa cartaNaMesa = cartasNaMesa[i];
      CardModel cartaJogada = cartaNaMesa.carta!;

      posicaoCarta = primeiraParteForcaCartas.indexWhere((carta) => carta.value == cartaJogada.value);

      if (cartaNaMesa.jogador.id == primeiroJogador) {
        posicaoCartaPrimeiroJogador = posicaoCarta;
      } else if (cartaNaMesa.jogador.id == segundoJogador) {
        posicaoCartaSegundoJogador = posicaoCarta;
      }
    }

    if (posicaoCartaPrimeiroJogador == posicaoCartaSegundoJogador) {
      empachou++;
    }

    if (posicaoCartaPrimeiroJogador < posicaoCartaSegundoJogador) {
      jogadorVencedor = primeiroJogador;
    }
    if (posicaoCartaSegundoJogador < posicaoCartaPrimeiroJogador) {
      jogadorVencedor = segundoJogador;
    }

    // Incrementar pontos da equipe vencedora
    if (jogadorVencedor == 1) {
      equipe1++;
      ultimovencedor = 1;
    } else if (jogadorVencedor == 2) {
      equipe2++;
      ultimovencedor = 2;
    }

    if (trucou) {
      if (equipe1 == 2 || equipe2 == 2) {
        defenirPontosComTruco(jogadorVencedor);
      }
    }
    if (equipe1 == 2 || equipe2 == 2) {
      defenirPontosSemTrucar(jogadorVencedor);
    }
    // Definir pontos se trucou e teve dois empates
    if (trucou) {
      if (empachou == 2) {
        defenirPontosComTruco(jogadorVencedor);
      }
      if (rodada == 3 && empachou == 1) {
        // Adiciona 1 ponto aos jogadores da equipe vencedora da mão
        defenirPontosComTruco(ultimovencedor);
      }
    }
    if (!trucou) {
      if (rodada == 3 && empachou == 1) {
        // Adiciona 1 ponto aos jogadores da equipe vencedora da mão
        defenirPontosSemTrucar(ultimovencedor);
      }
      if (empachou == 2) {
        defenirPontosSemTrucar(jogadorVencedor);
      }
    }

    if (definicaCartasBaralho.listaJogador[0].pontos == 12 || definicaCartasBaralho.listaJogador[1].pontos == 12) {
      mensagemFinalDeJogo = ("Vitória de $jogadorUltimoVencedor!! Você é o verdadeiro mestre do truco! Vamos ver se você consegue manter o título?");
      definicaCartasBaralho.cartasNaMesa.clear();
      return;
    }
    if (vencedorRodada) {
      definicaCartasBaralho.cartasNaMesa.clear();
      listForcaCartas.clear();
      iniciarJogo();
      rodada = 1;
      vencedorRodada = false;
    } else {
      rodada++;
      definicaCartasBaralho.cartasNaMesa.clear();
      listForcaCartas.clear();
    }
  }

  void defenirPontosSemTrucar(int jogadorVencedor) {
    // Adiciona 1 ponto aos jogadores da equipe vencedora da mão
    for (PlayerModel jogador in definicaCartasBaralho.listaJogador) {
      if (jogador.equipe == jogadorVencedor) {
        jogador.pontos += 1;
      }
    }
    // Define que houve um vencedor na rodada
    defenirCampeao(jogadorVencedor);
  }

  void defenirPontosComTruco(int jogadorVencedor) {
    for (PlayerModel jogador in definicaCartasBaralho.listaJogador) {
      if (jogador.equipe == jogadorVencedor) {
        jogador.pontos += valorTrucoAtual!;
      }
      // Reinicia o truco para a próxima rodada
      valorTruco = 3;
      trucoAceito = false;
    }
    // Define que houve um vencedor na rodada
    defenirCampeao(jogadorVencedor);
  }

  /// Define o campeão da rodada e reinicia as variáveis de truco e rodada.
  ///
  /// @param jogadorVencedor O ID do jogador vencedor.
  void defenirCampeao(int jogadorVencedor) {
    vencedorRodada = true;
    equipe1 = 0;
    equipe2 = 0;
    jogadorAtual = definicaCartasBaralho.listaJogador.firstWhere((jogador) => jogador.equipe == jogadorVencedor);
    jogadorUltimoVencedor = jogadorAtual;
    jogadorQueTrucou = null;
    jogadorQueAceitou = null;
    jogadorQueAumentouTruco = null;
    valorTruco = 3;
    valorTrucoAtual = null;
    trucoAceito = false;
    trucoPedindo = false;
    empachou = 0;
    rodada = 1;
    ultimovencedor = 0;
  }

  
  /// Solicita truco e define o valor do truco.
  ///
  /// @param jogador O jogador que está pedindo truco.
  /// @param valorTruco O valor do truco.
  /// @return true se o truco foi pedido com sucesso, caso contrário false.
  bool trucar(PlayerModel jogador, int valorTruco) {
    if (jogadorQueTrucou == null) {
      jogadorQueTrucou = jogador;
      this.valorTruco = valorTruco;
      valorTrucoAtual = valorTruco;
      trucoPedindo = true;
      jogadorAtual = proximoJogador()!;
      return true;
    } else {
      print("Já há uma negociação de truco em andamento!");
      return false;
    }
  }

  /// Aumenta o valor do truco.
  ///
  /// @param jogador O jogador que está aumentando o truco.
  void aumentarTruco(PlayerModel jogador) {
    if (jogadorQueTrucou != null && valorTrucoAtual! < 12) {
      jogadorQueAumentouTruco = jogador;
      valorTrucoAtual = valorTruco! + 3;
      valorTruco = valorTrucoAtual;
      jogadorAtual = proximoJogador()!;
    }
  }

  /// Aceita o pedido de truco.
  ///
  /// @param jogador O jogador que está aceitando o truco.
  void aceitarTruco(PlayerModel jogador) {
    if (jogadorQueTrucou != null) {
      jogadorQueAceitou = jogador;
      trucoAceito = true;
      jogadorAtual = proximoJogador()!;
    }
  }

  /// Desiste do truco e redefine as variáveis de truco.
  ///
  /// @param jogador O jogador que está desistindo do truco.
  void desistirTruco(PlayerModel jogador) {
    if (jogadorQueTrucou != null) {
      jogadorQueTrucou = null;
      jogadorQueAceitou = null;
      jogadorQueAumentouTruco = null;
      valorTruco = null;
      valorTrucoAtual = null;
      trucoAceito = false;
      trucoPedindo = false;
      if (jogadorAtual.id == 1) {
        definicaCartasBaralho.listaJogador[1].pontos += 1;
      } else {
        definicaCartasBaralho.listaJogador[0].pontos += 1;
      }
      definicaCartasBaralho.cartasNaMesa.clear();
      iniciarJogo();
      rodada = 0;
      vencedorRodada = false;
    }
  }

  /// Retorna o próximo jogador na lista.
  ///
  /// @return O próximo jogador.
  PlayerModel? proximoJogador() {
    int indexAtual = definicaCartasBaralho.listaJogador.indexOf(jogadorAtual);
    if (indexAtual < definicaCartasBaralho.listaJogador.length - 1) {
      return definicaCartasBaralho.listaJogador[indexAtual + 1];
    } else {
      return definicaCartasBaralho.listaJogador.first;
    }
  }

  /// Reinicia o jogo e todas as variáveis de estado.
  void reset() {
    definicaCartasBaralho.listaJogador[0].pontos = 0;
    definicaCartasBaralho.listaJogador[1].pontos = 0;
    jogadorUltimoVencedor = jogadorAtual;
    jogadorQueTrucou = null;
    jogadorQueAceitou = null;
    jogadorQueAumentouTruco = null;
    valorTruco = 3;
    valorTrucoAtual = null;
    trucoAceito = false;
    trucoPedindo = false;
    vencedorRodada = false;
    equipe1 = 0;
    equipe2 = 0;
    empachou = 0;
    ultimovencedor= 0;
    listForcaCartas.clear();
    definicaCartasBaralho.cartasNaMesa.clear();
    iniciarJogo();
  }
}
