import 'Baralho.dart';
import 'CartaNaMesa.dart';
import 'Jogador.dart';
import 'Cartas.dart';

class Game {
  Baralho baralho = Baralho();
  Jogador? jogadorAtual;
  Jogador? jogadorQueTrucou;
  Jogador? jogadorQueAceitou;
  int? valorTruco;
  bool trucoAceito = false;
  Jogador jogador = Jogador.Vazio();
  Cartas cartas = Cartas.vazio();

  void iniciarJogo() {
    baralho.inicializar();
    definirManilha();
    jogadorAtual = baralho
        .listaJogador.first; // Define o primeiro jogador como o jogador atual
    CartasNaMesa();
  }

  void escolherCartaDaJogada(int indiceCarta, Jogador jogador) {
    // Verifica se o índice fornecido é válido
    if (indiceCarta >= 0 && indiceCarta < jogador.maoJogador.length) {
        Cartas carta = jogador.maoJogador[indiceCarta];
    
    // Adiciona a carta jogada com informações do jogador à lista de cartas na mesa
    baralho.cartasNaMesa.add(CartaNaMesa(carta, jogador));
     // Remove a carta da mão do jogador
    jogador.maoJogador.remove(carta);
    }

  }
  // apenas para testes
  int indice = 0;
  void CartasNaMesa() {
    // sera pego da imagem escolhida pelo jogador na tela
      int indiceCartaEscolhida =  indiceCarta(indice);
    for (int j = 0; j < 4; j++) { 
      escolherCartaDaJogada(indiceCartaEscolhida, jogadorAtual!); 
      jogadorAtual = proximoJogador();
    }
    indice = indice + 1;
     // Ajustar a força das cartas com base na carta virada
   baralho.imprimeMaoJogador();
  var forcaCarta = retornarListaDeForca(); 
   definirGanhadorRodada(forcaCarta, baralho.cartasNaMesa);
  }

void definirGanhadorRodada(List<Cartas> forcaCartas, List<CartaNaMesa> cartasNaMesa) {
  int rodada = 1; // Controle de rodada
  int posicaoMaisAlta = 0;
    int jogadorVencedor = -1;
    int menorDiferenca = forcaCartas.length;
    bool vencedor = false;
    bool empate = false; // Flag para verificar empate na rodada atual

  while (rodada <= 3) {
    if(!vencedor){
         
    cartasNaMesa = verificarCartasIguais(forcaCartas, cartasNaMesa);

    for (int i = 0; i < cartasNaMesa.length; i++) {
      CartaNaMesa cartaNaMesa = cartasNaMesa[i];
      Cartas? cartaJogada = cartaNaMesa.carta;
      if(cartaJogada == null){
        continue;
      }
      else {
        int posicaoCarta = -1;
        for (int j = 0; j < forcaCartas.length; j++) {
          if (forcaCartas[j].valor == cartaJogada.valor) {
            posicaoCarta = j;
            break;
          }
        }
        int diferenca = (posicaoMaisAlta - posicaoCarta).abs();

        if (diferenca < menorDiferenca) {
          menorDiferenca = diferenca;
          jogadorVencedor = cartaNaMesa.jogador.equipe;
          posicaoMaisAlta = posicaoCarta; // Atualiza a posição mais alta
        
        }
      }
    }
    
    if (!empate) {
      // Adiciona um ponto à equipe vencedora e verifica se alguém ganhou a mão
      if (jogadorVencedor != -1) {
        for (Jogador jogador in baralho.listaJogador) {
          if (jogador.equipe == jogadorVencedor) {
            jogador.pontos++; // Incrementa o ponto apenas para a equipe vencedora
          }
        }
            if (baralho.listaJogador[0].pontos == 2 || baralho.listaJogador[1].pontos == 2) {
              // A equipe venceu duas rodadas, ganhou a mão
              print("A equipe $jogadorVencedor ganhou a mão!");
              vencedor = true;
              break;
            }
            print("A equipe $jogadorVencedor venceu a rodada e recebeu um ponto!");
        
      }
    // ignore: dead_code
    } else {
      // Empate na rodada atual
      print("Empate na rodada $rodada!");
    }

    rodada++; // Passa para a próxima rodada
    cartasNaMesa.clear();
    CartasNaMesa();
  }
}

    
  // Após o loop de rodadas, verifica quem ganhou a mão em caso de empate em todas as rodadas
  int pontosEquipe1 = 0;
  int pontosEquipe2 = 0;
  jogadorVencedor = -1;
  for (Jogador jogador in baralho.listaJogador) {
    if (jogador.equipe == 1) {
      pontosEquipe1 += jogador.pontos;
    } else if (jogador.equipe == 2) {
      pontosEquipe2 += jogador.pontos;
    }
  }
  if (pontosEquipe1 == pontosEquipe2) {
    print("Houve um empate na mão!");
    // A equipe do mão vence
    jogadorVencedor = 0; // Equipe do mão
  } else {
    jogadorVencedor = pontosEquipe1 > pontosEquipe2 ? 1 : 2;
  }

  // Adiciona um ponto à equipe vencedora da mão
  if (jogadorVencedor != 0) {
    for (Jogador jogador in baralho.listaJogador) {
      if (jogador.equipe == jogadorVencedor) {
        jogador.pontos++; // Incrementa o ponto apenas para a equipe vencedora
        print("A equipe $jogadorVencedor ganhou a mão!");
      }
    }
  }
}

    
List<CartaNaMesa> verificarCartasIguais(List<Cartas> forcaCartas, List<CartaNaMesa> cartasNaMesa){
  List<Cartas> cartasIguais = []; // Lista para armazenar as cartas iguais
  // Verifica as cartas na mesa e atribui pontos com base na força das cartas
  for (int i = 1; i < cartasNaMesa.length; i++) { // Começa da segunda carta
    CartaNaMesa cartaNaMesa = cartasNaMesa[i];
    Cartas? cartaJogada = cartaNaMesa.carta;
    if (cartaJogada != null) {
      for (int j = 0; j < i; j++) { // Compara com as cartas anteriores
      
        Cartas cartaJogador = cartasNaMesa[j].carta!;
        if (cartaJogador.valor == cartaJogada.valor) {
          // Adiciona as cartas iguais na lista
          cartasIguais.add(cartaJogada);
          cartasIguais.add(cartaJogador);
        }
      }
    }
  }
 // Verifica se todas as cartas iguais têm o mesmo naipe
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

  // Se todas as cartas.valor iguais têm o mesmo naipe, retorne a lista de cartasNaMesa como está
  if (mesmoNaipe) {
    return cartasNaMesa;
  }

   // Remove a carta com o maior valor da lista de cartas iguais
   // ignore: unused_local_variable
   Cartas? cartaPerdedora;
  if (cartasIguais.isNotEmpty) {
    cartasIguais.sort((a, b) => b.naipe.compareTo(a.naipe));
  cartaPerdedora = cartasIguais[0];
  }

  if (cartaPerdedora != null) {
    for (int i = 0; i < cartasNaMesa.length; i++) {
    if (cartasNaMesa[i].carta == cartaPerdedora) {
      cartasNaMesa[i].carta = null; // Remove a carta do jogador perdedor
      break; // Para após remover a carta perdedora
    }
    }
  }
   return cartasNaMesa;
}

  int indiceCarta(int indice){
    return indice;
  }

 List<Cartas> retornarListaDeForca(){
    // Pegar a carta virada do baralho
    Cartas cartas = baralho.cartaVirada;
    // Ajustar a força das cartas com base na carta virada
    var forcaCartas = cartas.ajustarForcaCartas(cartas);
    return forcaCartas;
  }
  void definirManilha() {
    // Pegar a carta virada do baralho
    Cartas cartaVirada = baralho.cartaVirada;
    // Ajustar a força das cartas com base na carta virada

      print(cartaVirada);

  }

  void trucar(Jogador jogador) {
    // Verifica se já existe uma negociação de truco em andamento
    if (jogadorQueTrucou == null) {
      jogadorQueTrucou = jogador; // Define o jogador que trucou
      valorTruco = 3; // Define o valor inicial do truco
      print("${jogador.nome} trucou!");
      jogadorAtual =
          proximoJogador(); // Define o próximo jogador como o jogador atual
    } else {
      print("Já há uma negociação de truco em andamento!");
    }
  }

  void aumentarTruco(Jogador jogador) {
    if (jogadorQueTrucou != null &&
        jogador == jogadorQueTrucou &&
        valorTruco! < 12) {
      valorTruco = valorTruco! * 2; // Dobra o valor do truco
      print("${jogador.nome} aumentou o truco para $valorTruco!");
      jogadorAtual =
          proximoJogador(); // Define o próximo jogador como o jogador atual
    } else {
      print("Não é possível aumentar o truco neste momento!");
    }
  }

  void aceitarTruco(Jogador jogador) {
    if (jogadorQueTrucou != null && jogadorQueTrucou != jogador) {
      jogadorQueAceitou = jogador; // Define o jogador que aceitou o truco
      trucoAceito = true; // Define o truco como aceito
      print("${jogador.nome} aceitou o truco!");
      jogadorAtual =
          proximoJogador(); // Define o próximo jogador como o jogador atual
    } else {
      print("Não há truco para ser aceito!");
    }
  }

  void desistirTruco(Jogador jogador) {
    if (jogadorQueTrucou != null) {
      jogadorQueTrucou = null; // Reseta o jogador que trucou
      jogadorQueAceitou = null; // Reseta o jogador que aceitou o truco
      valorTruco = null; // Reseta o valor do truco
      trucoAceito = false; // Reseta o truco como não aceito
      print("${jogador.nome} desistiu do truco!");
      jogadorAtual =
          proximoJogador(); // Define o próximo jogador como o jogador atual
    } else {
      print("Não há truco em andamento para desistir!");
    }
  }

  Jogador? proximoJogador() {
    int indexAtual = baralho.listaJogador.indexOf(jogadorAtual!);
    if (indexAtual < baralho.listaJogador.length - 1) {
      return baralho
          .listaJogador[indexAtual + 1]; // Retorna o próximo jogador na lista
    } else {
      return baralho.listaJogador
          .first; // Retorna o primeiro jogador da lista se chegar ao final
    }
  }

  void calcularPontuacao() {
    // Verifica se o truco foi aceito
    if (trucoAceito) {
      // Determina o jogador vencedor com base na pontuação
      Jogador? vencedor =
          baralho.listaJogador.reduce((a, b) => a.pontos > b.pontos ? a : b);
      print(
          "O jogador ${vencedor.nome} venceu a rodada com ${vencedor.pontos} pontos!");
    } else {
      print("Não houve truco nesta rodada.");
    }
  }
}

