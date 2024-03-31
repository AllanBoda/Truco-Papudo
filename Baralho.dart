
import 'dart:math';
import 'Cartas.dart';
import 'Jogador.dart';

class Baralho{
Jogador jogador =Jogador.Vazio();
List<Cartas> cartasNoBaralho = [];// 40 cartas
List<List<Cartas>> maoJogador = [];// guarda a lista de cartas nas mãos dos jogadores

List<Cartas> cartaRemovidaMao = [];// lista de cartas jogadas na mesa pelos jogadores.
var listaJogador; // variavel global que recebe o método adicionarListaJogador da class Jogador

Cartas cartaVirada = Cartas.vazio(); 
Cartas carta = Cartas.vazio();

//Método contrutor 
Baralho(){
 
  Baralhos();
  distribuirCartas();
  viraCarta();

}


//forma as cartas do baralho com os naipes e valores
void Baralhos(){
  for (int naipe = 1; naipe <=4; naipe++){
    for(int valor = 1; valor  <= 7; valor ++){
      cartasNoBaralho.add(Cartas(naipe, valor));
    }
    
  }
    for(int naipe = 1; naipe <= 4; naipe++ ){
      for(int valor = 11; valor <= 13; valor ++ )
      cartasNoBaralho.add(Cartas(naipe, valor));
    }
  embaralharBaralho(cartasNoBaralho);
  }
 
 // Vira a carta da rodada
  void viraCarta(){
    cartaVirada = cartasNoBaralho.removeLast();
    cartasNoBaralho.add(cartaVirada);
    cartasNoBaralho.remove(cartaVirada);
  
  }

//Embaralha as 40 cartas 
  void embaralharBaralho(List<Cartas> cartas){
    final random = Random();
    for (var i = cartas.length - 1; i > 0; i--){
      final j = random.nextInt(i +1);
      final temp = cartas[i];
      cartas[i] = cartas[j];
      cartas[j] = temp;
    }
  }
  
  //Método para mostrar a carta jogada na mesa por cada jogador
   CartasRemovidaMao<T>(List<List<Cartas>> maoJogador){
    print("Cartas jogadas na mesa: ");
    for(int j = 0; j < 4; j++){
        var cartaRemovida = maoJogador[j].removeLast();
        jogador.cartaRemovidaMao.add(cartaRemovida);
        print("${listaJogador[j]}: ${jogador.cartaRemovidaMao.last}");
    }

    imprimeMaoJogador(maoJogador);
    return maoJogador;

  }

//Método que recebe List Genérica para mostrar as cartas dos jogadores
//tanto no inicio como depois de cada jogada
 imprimeMaoJogador<T>(List<T> list){
  //IMPRIME jOGADORES COM SUAS CARTAS
 for(int i = 0; i < listaJogador.length; i++){
          print("Jogador${i+1}:${listaJogador[i]}"); 
     for(var carta in maoJogador[i]){
       print("Naipe: ${carta.naipe}, Valor: ${carta.valor}");
     }
}

}

T MaoJogadorPosJogada<T>(){
 return CartasRemovidaMao(maoJogador); 
}

//Método que distribui 3 cartas para cada jogador
 List<List<Cartas>> distribuirCartas() {
  listaJogador =jogador.adicionarListaJogador();
  maoJogador = List.generate(listaJogador.length, (_) => []);
  var cartas = 3;
  for (int i = 0; i < cartas; i++) {
    
    for (var jogador = 0; jogador < 4; jogador++) {
        maoJogador[jogador].add(cartasNoBaralho.removeLast());
       
      }
    }
    imprimeMaoJogador(maoJogador);
    return maoJogador;
  }

}


