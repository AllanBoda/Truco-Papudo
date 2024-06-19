import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Class/CartaNaMesa.dart';
import 'package:truco_full/Model/PlayerModel.dart';
import 'package:truco_full/Service/CartasServise.dart';
import 'Baralho.dart';


class Game {
  Baralho baralho = Baralho();
  PlayerModel? jogadorAtual;
  PlayerModel? jogadorQueTrucou;
  PlayerModel? jogadorQueAceitou;
  int? valorTruco;
  int equipe1 = 0;
  int equipe2 = 0;
  int rodada = 0; // Controle de rodada
  bool trucoAceito = false;
  bool sairJogo = false;
  bool jogarNovamente = false;
  bool vencedorRodada = false;
  CardModel cartas = CardModel.vazio();
  CardModel? manilha = new CardModel.vazio();

  void iniciarJogo() {
    baralho.inicializar();
    definirManilha();
    jogadorAtual = baralho.listaJogador.isNotEmpty ? baralho.listaJogador.first : null;
    //CartasNaMesa();
  }

  void escolherCartaDaJogada(int indiceCarta, PlayerModel jogador, {bool pediuTruco = false}) {
    if (indiceCarta >= 0 && indiceCarta < jogador.maoJogador.length) {
        CardModel carta = jogador.maoJogador[indiceCarta];
        baralho.cartasNaMesa.add(CartaNaMesa(carta, jogador, trucoPediu: pediuTruco));
        jogador.maoJogador.remove(carta);
    }
}


 void CartasNaMesa({int? indiceCartaEscolhida}) {
  // Verifica se a rodada foi vencida
  if (vencedorRodada) {
    // Reinicia a rodada
    rodada = 0;
    vencedorRodada = false;
    baralho.inicializar();
    definirManilha();
    jogadorAtual = baralho.listaJogador.first;
    return;
  }

  // Escolhe a carta da jogada atual
  if (indiceCartaEscolhida != null && jogadorAtual != null) {
    escolherCartaDaJogada(indiceCartaEscolhida, jogadorAtual!);
  }

  // Define o próximo jogador
  jogadorAtual = proximoJogador();

  // Verifica se todos os jogadores jogaram suas cartas na rodada atual
  if (baralho.cartasNaMesa.length == 4) {
    var forcaCartas = retornarListaDeForca();
    definirGanhadorRodada(forcaCartas, baralho.cartasNaMesa, trucoAceito);

    // Limpa as cartas da mesa para a próxima rodada
    baralho.cartasNaMesa.clear();
    rodada++;

    // Se três rodadas foram completadas, reinicia o jogo
    if (rodada >= 3) {
      definirManilha();
      rodada = 0;
    }
  }
}


  void definirGanhadorRodada(List<CardModel> forcaCartas, List<CartaNaMesa> cartasNaMesa, bool trucou) {
    int posicaoMaisAlta = 0;
    int jogadorVencedor = -1;
    int menorDiferenca = forcaCartas.length;
    
    while (rodada < 3) {
      if (cartasNaMesa[0].jogador.pontos <= 12 || cartasNaMesa[1].jogador.pontos <= 12) {
        cartasNaMesa = verificarCartasIguais(forcaCartas, cartasNaMesa);
        
        for (int i = 0; i < cartasNaMesa.length; i++) {
          CartaNaMesa cartaNaMesa = cartasNaMesa[i];
          CardModel? cartaJogada = cartaNaMesa.carta;
          
          if (cartaJogada == null) {
            continue;
          } else {
            int posicaoCarta = forcaCartas.indexWhere((carta) => carta.value == cartaJogada.value);
            
            if (posicaoCarta != -1) {
              int diferenca = (posicaoMaisAlta - posicaoCarta).abs();

              if (diferenca < menorDiferenca) {
                menorDiferenca = diferenca;
                jogadorVencedor = cartaNaMesa.jogador.id;
                posicaoMaisAlta = posicaoCarta;
              }
            }
          }
        }
        
        if (jogadorVencedor != -1) {
          if (trucou) {
            jogadorVencedor == 1 ? equipe1 = valorTruco! : equipe2 = valorTruco!;
          } else {
            jogadorVencedor == 1 ? equipe1++ : equipe2++;
          }
          
          if (equipe1 == 2 || equipe2 == 2) {
            print("A equipe $jogadorVencedor ganhou a mão!");
            
            for (PlayerModel jogador in baralho.listaJogador) {
              if (jogador.equipe == jogadorVencedor) {
                jogador.pontos += trucou ? valorTruco! : 1;
              }
            }
        
            vencedorRodada = true;
            valorTruco = null;
            equipe1 = 0;
            equipe2 = 0;
            jogadorAtual = baralho.listaJogador.firstWhere((jogador) => jogador.equipe == jogadorVencedor);
            CartasNaMesa();
            return;
          }
          
          print("A equipe $jogadorVencedor venceu a rodada");
        }
      }
      
      rodada++;
      cartasNaMesa.clear();
      valorTruco = null;
      CartasNaMesa();
    }
  }

  List<CartaNaMesa> verificarCartasIguais(List<CardModel> forcaCartas, List<CartaNaMesa> cartasNaMesa){
    List<CardModel> cartasIguais = [];
    for (int i = 1; i < cartasNaMesa.length; i++) {
      CartaNaMesa cartaNaMesa = cartasNaMesa[i];
      CardModel? cartaJogada = cartaNaMesa.carta;
      if (cartaJogada != null) {
        for (int j = 0; j < i; j++) {
          CardModel cartaJogador = cartasNaMesa[j].carta!;
          if (cartaJogador.value == cartaJogada.value) {
            cartasIguais.add(cartaJogada);
            cartasIguais.add(cartaJogador);
          }
        }
      }
    }

    bool mesmoNaipe = true;
    if (cartasIguais.isNotEmpty) {
      int naipePrimeiraCarta = cartasIguais.first.naipe;
      for (int i = 1; i < cartasIguais.length; i++) {
        if (cartasIguais[i].naipe != naipePrimeiraCarta) {
          mesmoNaipe = false;
          break;
        }
      }
    }

    if (mesmoNaipe) {
      return cartasNaMesa;
    }

    CardModel? cartaPerdedora;
    if (cartasIguais.isNotEmpty) {
      cartasIguais.sort((a, b) => b.naipe.compareTo(a.naipe));
      cartaPerdedora = cartasIguais[0];
    }

    if (cartaPerdedora != null) {
      for (int i = 0; i < cartasNaMesa.length; i++) {
        if (cartasNaMesa[i].carta == cartaPerdedora) {
          cartasNaMesa[i].carta = null;
          break;
        }
      }
    }
    
    return cartasNaMesa;
  }

  int indiceCarta(int indice) {
    return indice;
  }

  List<CardModel> retornarListaDeForca() {
    // Acesse a carta virada do baralho
    var cartaVirada = baralho.cartaVirada;

    // Crie uma instância de CartasServise
    var cartasServise = CartasServise();

    // Ajuste a força das cartas com base na carta virada
    var forcaCartas = cartasServise.ajustarForcaCartas(cartaVirada);

    // Retorne a lista de cartas ajustadas
    return forcaCartas;
  }

  void definirManilha() {
    // Acesse a carta virada do baralho
    var cartaVirada = baralho.cartaVirada;

    // Crie uma instância de CartasServise
    var cartasServise = CartasServise();

    // Ajuste a força da carta virada
    var manilha = cartasServise.ajustarForcaCartas(cartaVirada).first;

    // Imprima a manilha para depuração
    print("A manilha é: $manilha");

    // Defina a manilha na classe Game
    this.manilha = manilha;
  }

  bool trucar(PlayerModel jogador) {
    if (jogadorQueTrucou == null) {
      jogadorQueTrucou = jogador;
      valorTruco = 3;
      print("${jogador.nome} trucou!");
      jogadorAtual = proximoJogador();
    } else {
      print("Já há uma negociação de truco em andamento!");
    }
    return true;
  }

  void aumentarTruco(PlayerModel jogador) {
    if (jogadorQueTrucou != null && jogador == jogadorQueTrucou && valorTruco! < 12) {
      valorTruco = valorTruco! * 2;
      print("${jogador.nome} aumentou o truco para $valorTruco!");
      jogadorAtual = proximoJogador();
    } else {
      print("Não é possível aumentar o truco neste momento!");
    }
  }

  void aceitarTruco(PlayerModel jogador) {
    if (jogadorQueTrucou != null && jogadorQueTrucou != jogador) {
      jogadorQueAceitou = jogador;
      trucoAceito = true;
      print("${jogador.nome} aceitou o truco!");
      jogadorAtual = proximoJogador();
    } else {
      print("Não há truco para ser aceito!");
    }
  }

  void desistirTruco(PlayerModel jogador) {
    if (jogadorQueTrucou != null) {
      jogadorQueTrucou = null;
      jogadorQueAceitou = null;
      valorTruco = null;
      trucoAceito = false;
      print("${jogador.nome} desistiu do truco!");
      jogadorAtual = proximoJogador();
    } else {
      print("Não há truco em andamento para desistir!");
    }
  }

  PlayerModel? proximoJogador() {
    if (jogadorAtual != null) {
      int indexAtual = baralho.listaJogador.indexOf(jogadorAtual!);
      if (indexAtual < baralho.listaJogador.length - 1) {
        return baralho.listaJogador[indexAtual + 1];
      } else {
        return baralho.listaJogador.first;
      }
    }
    return null;
  }

  bool encerrarJogo() {
    return sairJogo;
  }

  bool jogaNovamente() {
    iniciarJogo();
    return jogarNovamente;
  }

  void calcularPontuacao() {
    if (trucoAceito) {
      PlayerModel? vencedor = baralho.listaJogador.reduce((a, b) => a.pontos > b.pontos ? a : b);
      print("O jogador ${vencedor.nome} venceu a rodada com ${vencedor.pontos} pontos!");
    } else {
      print("Não houve truco nesta rodada.");
    }
  }
}
