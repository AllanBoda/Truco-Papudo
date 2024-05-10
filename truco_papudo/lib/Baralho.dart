import 'dart:math';

import 'CartaNaMesa.dart';
import 'Cartas.dart';
import 'Jogador.dart';


class Baralho {
  List<Cartas> cartasNoBaralho = [];
  List<List<Cartas>> maoJogador = [];
  List<Cartas> cartaRemovidaMao = [];
  List<CartaNaMesa> cartasNaMesa = [];
  List<Jogador> listaJogador = [];

  Cartas cartaVirada = Cartas.vazio();

  void inicializar() {
  //verifica se a lista estar vazia antes de defenir a lista de jogadores
  if (listaJogador.isEmpty) {
    defenirListaJogadores();
  }
  // se não estiver vazia , sinaliza que é uma segunda rodada, assim a lista permanece com os dados da primeira partida
  Baralhos();
  distribuirCartas();
  viraCarta();
  defenirMaoJogadores();
}

  void Baralhos() {
    for (int naipe = 1; naipe <= 4; naipe++) {
      for (int valor = 1; valor <= 7; valor++) {
        cartasNoBaralho.add(Cartas(naipe, valor));
      }
    }
    for (int naipe = 1; naipe <= 4; naipe++) {
      for (int valor = 11; valor <= 13; valor++)
        cartasNoBaralho.add(Cartas(naipe, valor));
    }
    embaralharBaralho(cartasNoBaralho);
  }

  void viraCarta() {
    cartaVirada = cartasNoBaralho.removeLast();
    cartasNoBaralho.add(cartaVirada);
    cartasNoBaralho.remove(cartaVirada);
  }

  void embaralharBaralho(List<Cartas> cartas) {
    final random = Random();
    for (var i = cartas.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = cartas[i];
      cartas[i] = cartas[j];
      cartas[j] = temp;
    }
  }

  List<List<Cartas>> distribuirCartas() {
    maoJogador = List.generate(4, (_) => []);
    var cartas = 3;
    for (int i = 0; i < cartas; i++) {
      for (var jogador = 0; jogador < 4; jogador++) {
        maoJogador[jogador].add(cartasNoBaralho.removeLast());
      }
    }
    return maoJogador;
  }

   void defenirListaJogadores(){
  //Os nomes vão ser pegos nos campos que os jogadores irão inseri-los
  List<String> nomesJogadores = ["Jessica","Natan","Emily","Gabriel"];
  // Adicionando jogadores com nomes da lista
  for (int i = 0; i < nomesJogadores.length; i++) {
   listaJogador.add(Jogador(nomesJogadores[i], i + 1, (i % 2) + 1));
    }
  }

  void defenirMaoJogadores(){
  // Definir a mão de cada jogador
  for (int i = 0; i < 4; i++) {
   listaJogador[i].getMaoJogador(maoJogador[i]);
   }
  }

  List<List<Cartas>> CartasRemovidaMao() {
    List<List<Cartas>> novaMaoJogador = [];
    for (int j = 0; j < 4; j++) {
      var cartaRemovida = maoJogador[j].removeLast();
      cartaRemovidaMao.add(cartaRemovida);
      // Para testes
      print(
          "${listaJogador[j].SetNome()}: ${cartaRemovidaMao.last.toString()}");
    }
    imprimeMaoJogador();
    return novaMaoJogador;
  }

  void imprimeMaoJogador() {
    // Exibe os jogadores com suas cartas
    for (int i = 0; i < listaJogador.length; i++) {
      print("Jogador ${i + 1}: ${listaJogador[i]}");
    }
  }
}