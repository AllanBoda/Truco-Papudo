import 'package:truco_full/Model/CardModel.dart';
import 'package:truco_full/Model/CartasNaMesa.dart';
import 'package:truco_full/Model/PlayerModel.dart';
import 'package:truco_full/Service/CartasServise.dart';
import 'definicaoCartasBaralho.dart';

/// A classe `Game` gerencia a lógica do jogo de truco, incluindo o baralho,
///  as rodadas, os jogadores e a pontuação.
class Game {
  DefinicaoCartasBaralho definicaCartasBaralho = DefinicaoCartasBaralho();
  late PlayerModel jogadorAtual;
  PlayerModel? jogadorQueTrucou;
  PlayerModel? jogadorQueAceitou;
  PlayerModel? jogadorQueAumentouTruco;
  int? valorTruco = 3;
  int? valorTrucoAtual = 3;
  int equipe1 = 0;
  int equipe2 = 0;
  int rodada = 0;
  bool trucoAceito = false;
  bool vencedorRodada = false;
  CardModel cartas = CardModel.vazio();
  CardModel? manilha = CardModel.vazio();
  PlayerModel? jogadorUltimoVencedor;
  bool? trucoPedindo;
  List<CardModel> listForcaCartas = [];
  CartasServise cartasServise = CartasServise();

  /// Inicia o jogo de truco. Define o baralho, a manilha e o jogador atual.
  void iniciarJogo() {
    definicaCartasBaralho.inicializar();
    definirManilha();
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
    int empate = 0;

    // Determinar quem é o primeiro e o segundo jogador
    if (cartasNaMesa[0].jogador.equipe == 1) {
      primeiroJogador = 1;
      segundoJogador = 2;
    } else {
      primeiroJogador = 2;
      segundoJogador = 1;
    }

    // Laço para determinar a posição das cartas jogadas por cada jogador
    for (int i = 0; i < cartasNaMesa.length; i++) {
      CartaNaMesa cartaNaMesa = cartasNaMesa[i];
      CardModel cartaJogada = cartaNaMesa.carta!;

      int posicaoCarta = forcaCartas.indexWhere((carta) => carta.value == cartaJogada.value);

      if (cartaNaMesa.jogador.id == primeiroJogador) {
        posicaoCartaPrimeiroJogador = posicaoCarta;
      } else if (cartaNaMesa.jogador.id == segundoJogador) {
        posicaoCartaSegundoJogador = posicaoCarta;
      }
    }

    // Determinar o vencedor da rodada
    int jogadorVencedor = -1;

    if (posicaoCartaPrimeiroJogador == posicaoCartaSegundoJogador) {
      empate++;
      cartasNaMesa.clear();
      rodada++;
      return; // Empate
    }
    if (posicaoCartaPrimeiroJogador < posicaoCartaSegundoJogador) {
      jogadorVencedor = primeiroJogador;
    } else {
      jogadorVencedor = segundoJogador;
    }

    // Incrementar pontos da equipe vencedora
    if (jogadorVencedor == 1) {
      equipe1++;
    } else if (jogadorVencedor == 2) {
      equipe2++;
    }

    if (trucou) {
      if (equipe1 == 2 || equipe2 == 2) {
        // Atualiza apenas as informações relacionadas ao truco
        for (PlayerModel jogador in definicaCartasBaralho.listaJogador) {
          if (jogador.equipe == jogadorVencedor) {
            jogador.pontos += valorTrucoAtual!;
            // Reinicia o truco para a próxima rodada
            valorTruco = 3;
            trucoAceito = false;
          }
        }
        // Define que houve um vencedor na rodada
        defenirCampeao(jogadorVencedor);
      }
    }
    if (!trucou && (equipe1 == 2 || equipe2 == 2)) {
      // Adiciona 1 ponto aos jogadores da equipe vencedora da mão
      for (PlayerModel jogador in definicaCartasBaralho.listaJogador) {
        if (jogador.equipe == jogadorVencedor) {
          jogador.pontos += 1;
        }
      }
      // Define que houve um vencedor na rodada
      defenirCampeao(jogadorVencedor);
    }
    if (vencedorRodada) {
      definicaCartasBaralho.cartasNaMesa.clear();
      iniciarJogo();
      rodada = 0;
      vencedorRodada = false;
    } else {
      rodada++;
      definicaCartasBaralho.cartasNaMesa.clear();
    }
    if (empate == 2 && trucou) {
      for (PlayerModel jogador in definicaCartasBaralho.listaJogador) {
        jogador.pontos += valorTrucoAtual!;
        // Reinicia o truco para a próxima rodada
        valorTruco = 3;
        trucoAceito = false;
      }
      // Define que houve um vencedor na rodada
      defenirCampeao(jogadorVencedor);
    } else if (empate == 2 && !trucou) {
      // Adiciona 1 ponto aos jogadores da equipe vencedora da mão
      for (PlayerModel jogador in definicaCartasBaralho.listaJogador) {
        if (jogador.equipe == jogadorVencedor) {
          jogador.pontos += 1;
        }
      }
      // Define que houve um vencedor na rodada
      defenirCampeao(jogadorVencedor);
    }
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
  }

  void definirManilha() {
    CardModel cartaVirada = definicaCartasBaralho.cartaVirada;
    cartasServise.ajustarForcaCartas(cartaVirada);
    print("A manilha é: $cartaVirada");
    this.manilha =
        cartaVirada; // Adiciona a carta de manilha à variável manilha da classe Game
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
      valorTrucoAtual = valorTruco! * 2;
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
      jogadorAtual = proximoJogador()!;
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

  /// Reinicia as variáveis de truco.
  void reniciarVariaveisTruco() {
    jogadorQueTrucou = null;
    jogadorQueAceitou = null;
    valorTruco = null;
    valorTrucoAtual = null;
    trucoAceito = false;
    trucoPedindo = false;
    jogadorAtual = proximoJogador()!;
  }

  /// Reinicia o jogo.
  void jogarNovamente() {
    iniciarJogo();
  }
}
