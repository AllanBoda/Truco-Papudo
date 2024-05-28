class Cartas {
  final int naipe;
  final int valor;
  int forca;

  Cartas(this.naipe, this.valor) : forca = valor;

  void ajustarForcaCartas(Cartas cartaVirada) {
    // Implementação da lógica para ajustar a força das cartas
    // baseado na carta virada.
    // Exemplo simples (pode variar dependendo das regras do seu jogo):
    if (valor == cartaVirada.valor + 1) {
      forca = 14; // A manilha tem força máxima
    }
  }

  @override
  String toString() {
    // Exemplo simples de como converter a carta para string
    return '$valor de $naipe';
  }

  Cartas.vazio()
      : naipe = 0,
        valor = 0,
        forca = 0;
}
