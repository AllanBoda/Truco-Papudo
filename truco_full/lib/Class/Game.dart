
import 'package:truco_full/Class/CartaNaMesa.dart';
import 'Baralho.dart';
import 'Jogador.dart';
import 'Cartas.dart';

class Game {
  Baralho baralho = Baralho();
  Jogador? jogadorAtual;
  Jogador? jogadorQueTrucou;
  Jogador? jogadorQueAceitou;
  int? valorTruco;
  int equipe1 = 0;
  int equipe2 = 0;
  int rodada = 0; // Controle de rodada
  bool trucoAceito = false;
  bool sairJogo = false;
  bool jogarNovamente = false;
  bool vencedorRodada = false;
  Jogador jogador = Jogador.Vazio();
  Cartas cartas = Cartas.vazio();
  Cartas manilha = Cartas.vazio();

  void iniciarJogo() {
    baralho.inicializar();
    definirManilha();
    //jogadorAtual = baralho.listaJogador.isNotEmpty ? baralho.listaJogador.first : null;
    //CartasNaMesa();
  }

  void escolherCartaDaJogada(int indiceCarta, Jogador jogador, {bool pediuTruco = false}) {
    if (indiceCarta >= 0 && indiceCarta < jogador.maoJogador.length) {
        Cartas carta = jogador.maoJogador[indiceCarta];
        baralho.cartasNaMesa.add(CartaNaMesa(carta, jogador, trucoPediu: pediuTruco));
        jogador.maoJogador.remove(carta);
    }
}


  void CartasNaMesa({int? indiceCartaEscolhida}) {
   
    if (!vencedorRodada) {
      for (int j = 0; j < 4; j++) {
        if (jogadorAtual != null) {
          escolherCartaDaJogada(indiceCartaEscolhida!, jogadorAtual!);
          jogadorAtual = proximoJogador();
        }
      }
      
      baralho.imprimeMaoJogador();
      var forcaCarta = retornarListaDeForca();
      
      if (jogadorQueTrucou != null && jogadorQueAceitou != null) {
        trucoAceito = true;
      }
      
      if (baralho.cartasNaMesa.isNotEmpty) {
        definirGanhadorRodada(forcaCarta, baralho.cartasNaMesa, trucoAceito);
      }
    } else {
      rodada = 0;
      vencedorRodada = false;
      baralho.inicializar();
      CartasNaMesa();
    }
  }

  void definirGanhadorRodada(List<Cartas> forcaCartas, List<CartaNaMesa> cartasNaMesa, bool trucou) {
    int posicaoMaisAlta = 0;
    int jogadorVencedor = -1;
    int menorDiferenca = forcaCartas.length;
    
    while (rodada < 3) {
      if (cartasNaMesa[0].jogador.pontos <= 12 || cartasNaMesa[1].jogador.pontos <= 12) {
        cartasNaMesa = verificarCartasIguais(forcaCartas, cartasNaMesa);
        
        for (int i = 0; i < cartasNaMesa.length; i++) {
          CartaNaMesa cartaNaMesa = cartasNaMesa[i];
          Cartas? cartaJogada = cartaNaMesa.carta;
          
          if (cartaJogada == null) {
            continue;
          } else {
            int posicaoCarta = forcaCartas.indexWhere((carta) => carta.valor == cartaJogada.valor);
            
            if (posicaoCarta != -1) {
              int diferenca = (posicaoMaisAlta - posicaoCarta).abs();

              if (diferenca < menorDiferenca) {
                menorDiferenca = diferenca;
                jogadorVencedor = cartaNaMesa.jogador.equipe;
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
            
            for (Jogador jogador in baralho.listaJogador) {
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

  List<CartaNaMesa> verificarCartasIguais(List<Cartas> forcaCartas, List<CartaNaMesa> cartasNaMesa){
    List<Cartas> cartasIguais = [];
    for (int i = 1; i < cartasNaMesa.length; i++) {
      CartaNaMesa cartaNaMesa = cartasNaMesa[i];
      Cartas? cartaJogada = cartaNaMesa.carta;
      if (cartaJogada != null) {
        for (int j = 0; j < i; j++) {
          Cartas cartaJogador = cartasNaMesa[j].carta!;
          if (cartaJogador.valor == cartaJogada.valor) {
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

    Cartas? cartaPerdedora;
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

  List<Cartas> retornarListaDeForca(){
    Cartas cartas = baralho.cartaVirada;
    var forcaCartas = cartas.ajustarForcaCartas(cartas);
    return [cartas]; // Assuming ajustarForcaCartas modifies cartas in place and returns it
  }

 void definirManilha() {
  Cartas cartaVirada = baralho.cartaVirada;
  cartaVirada.ajustarForcaCartas(cartaVirada);
  print("A manilha é: $cartaVirada");
  this.manilha = cartaVirada; // Adiciona a carta de manilha à variável manilha da classe Game
}


  bool trucar(Jogador jogador) {
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

  void aumentarTruco(Jogador jogador) {
    if (jogadorQueTrucou != null && jogador == jogadorQueTrucou && valorTruco! < 12) {
      valorTruco = valorTruco! * 2;
      print("${jogador.nome} aumentou o truco para $valorTruco!");
      jogadorAtual = proximoJogador();
    } else {
      print("Não é possível aumentar o truco neste momento!");
    }
  }

  void aceitarTruco(Jogador jogador) {
    if (jogadorQueTrucou != null && jogadorQueTrucou != jogador) {
      jogadorQueAceitou = jogador;
      trucoAceito = true;
      print("${jogador.nome} aceitou o truco!");
      jogadorAtual = proximoJogador();
    } else {
      print("Não há truco para ser aceito!");
    }
  }

  void desistirTruco(Jogador jogador) {
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

  Jogador? proximoJogador() {
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
      Jogador? vencedor = baralho.listaJogador.reduce((a, b) => a.pontos > b.pontos ? a : b);
      print("O jogador ${vencedor.nome} venceu a rodada com ${vencedor.pontos} pontos!");
    } else {
      print("Não houve truco nesta rodada.");
    }
  }
}
