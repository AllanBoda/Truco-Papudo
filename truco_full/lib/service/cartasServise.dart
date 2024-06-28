import 'package:truco_full/model/cardModel.dart';

class CartasServise {
  List<int> naipes = [1, 2, 3, 4];
  List<CardModel> todasCartas = [];


 int encontrarProximoValor(int cartaVirada) {
  List<int> valoresPorOrdemNumerica = [1, 2, 3, 4, 5, 6, 7, 10, 11, 12];
  // Encontrar o índice da carta virada na lista
  int index = valoresPorOrdemNumerica.indexOf(cartaVirada);
  // Verificar se a carta virada é a última na lista
  if (index == valoresPorOrdemNumerica.length - 1) {
    return valoresPorOrdemNumerica[0]; // Retorna o primeiro elemento da lista se for o último
  } else {
    return valoresPorOrdemNumerica[index + 1]; // Retorna o próximo elemento na lista
  }
}

  List<CardModel> ajustarForcaCartas(CardModel cartaVirada) {
    List<int> valoresPorOrdemDeForca = [3, 2, 1, 12, 11, 10, 7, 6, 5, 4];
    // Encontrar o próximo valor após a carta virada
    int valorCartaManilha = encontrarProximoValor(cartaVirada.value);
    // Encontrar o índice da carta virada nas listas de valores e naipes
    int indexManilha = valoresPorOrdemDeForca.indexOf(valorCartaManilha);


    // Remover a carta virada das listas
    valoresPorOrdemDeForca.removeAt(indexManilha);

    // Inserir a próxima carta na posição da carta virada
    int nextValorIndex = 0;
    // Inserir a próxima carta na posição da carta virada
    valoresPorOrdemDeForca.insert(nextValorIndex, valorCartaManilha);


    // Adicionar todas as cartas deste naipe na lista
    for (int naipe in naipes) {
      for (int valor in valoresPorOrdemDeForca) {
        todasCartas.add(CardModel.cards(value: valor, naipe: naipe));
      }
    }
    return todasCartas;
  }

}
