

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
  int equipe1 = 0;
  int equipe2 = 0;
  int rodada = 0; // Controle de rodada
  bool trucoAceito = false;
  bool sairJogo = false;
  bool jogarNovamente = false;
  bool vencedorRodada = false;
  Jogador jogador = Jogador.Vazio();
  Cartas cartas = Cartas.vazio();

  void iniciarJogo() {
    baralho.inicializar();
    definirManilha();
    jogadorAtual = baralho
        .listaJogador.first; // Define o primeiro jogador como o jogador atual
    CartasNaMesa();
  }

  void escolherCartaDaJogada(int indiceCarta, Jogador jogador, {bool pediuTruco = false}) {
    // Verifica se o índice fornecido é válido
    if (indiceCarta >= 0 && indiceCarta < jogador.maoJogador.length) {
        Cartas carta = jogador.maoJogador[indiceCarta];
    
    // Adiciona a carta jogada com informações do jogador à lista de cartas na mesa
    baralho.cartasNaMesa.add(CartaNaMesa(carta, jogador, trucoPediu: pediuTruco));
     // Remove a carta da mão do jogador
    jogador.maoJogador.remove(carta);
    }

  }
  // apenas para testes
  void CartasNaMesa() {
    // sera pego da imagem escolhida pelo jogador na tela
      int indiceCartaEscolhida =  indiceCarta(0);
    for (int j = 0; j < 4; j++) { 
      escolherCartaDaJogada(indiceCartaEscolhida, jogadorAtual!); 
      jogadorAtual = proximoJogador();
    }
     // Ajustar a força das cartas com base na carta virada
   baralho.imprimeMaoJogador();
  var forcaCarta = retornarListaDeForca(); 
  if(jogadorQueTrucou != null && jogadorQueAceitou != null){
    trucoAceito = true;
  }
  if(!vencedorRodada){
    if(baralho.cartasNaMesa.length > 0){
    definirGanhadorRodada(forcaCarta, baralho.cartasNaMesa, trucoAceito);
  }
  else{
    rodada = 0;
    baralho.inicializar();
    CartasNaMesa();
    }
  }
}

void definirGanhadorRodada(List<Cartas> forcaCartas, List<CartaNaMesa> cartasNaMesa, bool trucou ) {
  int posicaoMaisAlta = 0;
    int jogadorVencedor = -1;
    int menorDiferenca = forcaCartas.length;
  
  while (rodada < 3) {
      if(cartasNaMesa[0].jogador.pontos <= 12 || cartasNaMesa[1].jogador.pontos <= 12){
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
      // Adiciona um ponto à equipe vencedora e verifica se alguém ganhou a mão
      if (jogadorVencedor != -1) {
            if(trucou){
              if(jogadorVencedor == 1){
                 equipe1 = valorTruco!;
              }else{
                equipe2 = valorTruco!;
              }
            }else{
              if(jogadorVencedor == 1){
                equipe1++; 
              }else{
                equipe2++;
              }
               
            }   
            if (equipe1 == 2 || equipe2 == 2) {
              // A equipe venceu duas rodadas, ganhou a mão
              print("A equipe $jogadorVencedor ganhou a mão!");
               for (Jogador jogador in baralho.listaJogador) {
                if (jogador.equipe == jogadorVencedor) {
                  if(trucou){
                    jogador.pontos = valorTruco!; //Incrementa os pontos atribuido ao valorTruco apenas para a equipe vencedora
                  }else{
                    jogador.atualizarPontos(jogador.pontos++); // Incrementa um ponto apenas para a equipe vencedora
                  }      
                }
               }
              vencedorRodada = true;
              valorTruco = null;
              break;
            }
            print("A equipe $jogadorVencedor venceu a rodada e recebeu um ponto!");
      }
    }
    else{
      if(sairJogo){
        encerrarJogo();
      }else{
        jogaNovamente();
      }
    }
       
    rodada++; // Passa para a próxima rodada
    cartasNaMesa.clear();
    valorTruco = null;
    CartasNaMesa();
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


  bool trucar(Jogador jogador) {
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
    return true;
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
 
 //Defenir como sair do jogo ainda.....
  bool encerrarJogo(){
    return sairJogo;
  }

  bool jogaNovamente(){
    iniciarJogo();
    return jogarNovamente;
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

