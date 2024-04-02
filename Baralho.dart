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
        cartaRemovidaMao.add(cartaRemovida);
        print("${listaJogador[j].SetNome()}: ${cartaRemovidaMao.last}");
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
     }
}


T MaoJogadorPosJogada<T>(){
 return CartasRemovidaMao(maoJogador); 
}

// Método para criar os jogadores e passar a mão de cada jogador
  List<Jogador> adicionarListaJogador() {
    Jogador jogador1 = Jogador("Jessica", 1, 1, 0, maoJogador[0]);
    Jogador jogador2 = Jogador("Emily", 2, 1, 0, maoJogador[1]);
    Jogador jogador3 = Jogador("Natan", 3, 2, 0, maoJogador[2]);
    Jogador jogador4 = Jogador("Gabriel", 4, 2, 0, maoJogador[3]);
    List<Jogador> listaJogadores = [jogador1, jogador2, jogador3, jogador4];
    return listaJogadores;
  }

//Método que distribui 3 cartas para cada jogador
 List<List<Cartas>> distribuirCartas() {
  maoJogador = List.generate(4, (_) => []);
  var cartas = 3;
  for (int i = 0; i < cartas; i++) {
    
    for (var jogador = 0; jogador < 4; jogador++) {
        maoJogador[jogador].add(cartasNoBaralho.removeLast());
       
      }
    }
    listaJogador = adicionarListaJogador();
    imprimeMaoJogador(maoJogador);
    return maoJogador;
  }

}


