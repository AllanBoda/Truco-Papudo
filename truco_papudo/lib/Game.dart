import 'Baralho.dart';
import 'Jogador.dart';
import 'Cartas.dart';

class Game {
  Baralho baralho = Baralho();
  Jogador? jogadorAtual;
  Jogador? jogadorQueTrucou;
  Jogador? jogadorQueAceitou;
  int? valorTruco;
  bool trucoAceito = false;

  void iniciarJogo() {
    baralho.inicializar();
    definirManilha();
    jogadorAtual = baralho
        .listaJogador.first; // Define o primeiro jogador como o jogador atual
  }

  void definirManilha() {
    // Pegar a carta virada do baralho
    Cartas cartaVirada = baralho.cartaVirada;
    // Ajustar a força das cartas com base na carta virada
    for (var jogador in baralho.listaJogador) {
      for (var carta in jogador.maoJogador) {
        carta.ajustarForcaCartas(cartaVirada);
      }
    }
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
          "O jogador ${vencedor!.nome} venceu a rodada com ${vencedor.pontos} pontos!");
    } else {
      print("Não houve truco nesta rodada.");
    }
  }
}
