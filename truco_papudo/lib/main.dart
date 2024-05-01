import 'Game.dart';

void main() {
  // Criando uma instância do jogo
  Game jogo = Game();
  // Iniciando o jogo
  jogo.iniciarJogo();

  
  // Trucando um jogador
  jogo.trucar(jogo.baralho.listaJogador[0]);

  // Aumentando o truco
  jogo.aumentarTruco(jogo.baralho.listaJogador[1]);

  // Aceitando o truco
  jogo.aceitarTruco(jogo.baralho.listaJogador[2]);

  // Calculando a pontuação
 jogo.calcularPontuacao();
}
