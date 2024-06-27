import 'package:truco_full/model/cardModel.dart';

class CartasServise {
  List<int> valores = [3, 2, 1, 10, 11, 12, 7, 6, 5, 4];
  List<int> naipes = [1, 2, 3, 4];
  List<CardModel> todasCartas = [];


 int encontrarProximoValor(List<int> list, int cartaVirada) {
  // Encontrar o índice da carta virada na lista
  int index = list.indexOf(cartaVirada);
  // Verificar se a carta virada é a última na lista
  if (index == list.length - 1) {
    return list[0]; // Retorna o primeiro elemento da lista se for o último
  } else {
    return list[index + 1]; // Retorna o próximo elemento na lista
  }
}

  List<CardModel> ajustarForcaCartas(CardModel cartaVirada) {
    // Encontrar o próximo valor após a carta virada
    int cartaValor = encontrarProximoValor(valores, cartaVirada.value);
    // Encontrar o índice da carta virada nas listas de valores e naipes
    int valorIndex = valores.indexOf(cartaValor);

    if (valorIndex != -1) {
      // Remover a carta virada das listas
      valores.removeAt(valorIndex);

      // Inserir a próxima carta na posição da carta virada
      int nextValorIndex = 0;
      // Inserir a próxima carta na posição da carta virada
      valores.insert(nextValorIndex, cartaValor);
    }

    // Adicionar todas as cartas deste naipe na lista
    for (int naipe in naipes) {
      for (int valor in valores) {
        todasCartas.add(CardModel.cards(value: valor, naipe: naipe));
      }
    }
    return todasCartas;
  }

}
