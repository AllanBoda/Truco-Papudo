
class Cartas{
  late int valor; //1ouros, 2espadas, 3copas e 4paus.
  late int naipe; //4, 5, 6, 7, Q (Dama), J (Valete), K (Rei), Ás, 2, 3
  List<int> valores = [3, 2, 1, 13, 11, 12, 7, 6, 5 ,4];
  List<int> naipes = [1,2,3,4];

  Cartas.vazio();

  Cartas(this.naipe, this.valor);
   int encontrarProximoValor(List<int> list, int cartaVirada){
      int index = list.indexOf(cartaVirada);
        if (index == list.length - 1){
          return list[0];//se o numero for  ultimo da lista
        }else{
          return list[index + 1];
        }
   }

void ajustarForcaCartas(Cartas cartaVirada) {
  //Ver qual a próxima da lista depois da carta virada
  int cartaValor = encontrarProximoValor(valores,cartaVirada.valor);
  // Encontrar a posição da carta virada nas listas de valores e naipes
  int valorIndex = valores.indexOf(cartaValor);
  int naipeIndex = naipes.indexOf(cartaVirada.naipe);

  if (valorIndex != -1 && naipeIndex != -1) {
    // Remover a carta virada das listas
   valores.removeAt(valorIndex);
   naipes.removeAt(naipeIndex);

    // Inserir a próxima carta na posição da carta virada
   int nextValorIndex = 0;
   int nextNaipeIndex = 0;
   // Inserir a próxima carta na posição da carta virada
   valores.insert(nextValorIndex, cartaValor);
   naipes.insert(nextNaipeIndex, cartaVirada.naipe);
  }

 
}

@override
String toString(){
  return "Naipe:$naipe - Valor:$valor ";
  }  
}


