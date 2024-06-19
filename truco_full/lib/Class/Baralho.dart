import 'dart:math';
import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Class/CartaNaMesa.dart';
import 'package:truco_full/Class/playerPosition.dart';
import 'package:truco_full/Model/PlayerModel.dart';



class Baralho {
  List<CardModel> cartasNoBaralho = [];
  List<List<CardModel>> maoJogador = [];
  List<CardModel> cartaRemovidaMao = [];
  List<CartaNaMesa> cartasNaMesa = [];
  List<PlayerModel> listaJogador = [];

  CardModel cartaVirada = CardModel.vazio();

  void inicializar() {
  //verifica se a lista estar vazia antes de defenir a lista de jogadores
  if (listaJogador.isEmpty) {
    definirListaJogadores();
  }
  // se não estiver vazia , sinaliza que é uma segunda rodada, assim a lista permanece com os dados da primeira partida
  Baralhos();
  distribuirCartas();
  viraCarta();
  defenirMaoJogadores();
}

  void Baralhos() {
    for (int naipe = 1; naipe < 4; naipe++) {
      for (int valor = 1; valor <= 7; valor++) {
        cartasNoBaralho.add(CardModel.cards(value: valor, naipe: naipe));
      }
    }
    for (int naipe = 1; naipe < 4; naipe++) {
      for (int valor = 11; valor <= 12; valor++)
        cartasNoBaralho.add(CardModel.cards(value: valor, naipe: naipe));
    }
    embaralharBaralho(cartasNoBaralho);
  }

  void viraCarta() {
    cartaVirada = cartasNoBaralho.removeLast();
    cartasNoBaralho.add(cartaVirada);
    cartasNoBaralho.remove(cartaVirada);
  }

  void embaralharBaralho(List<CardModel> cartas) {
    final random = Random();
    for (var i = cartas.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = cartas[i];
      cartas[i] = cartas[j];
      cartas[j] = temp;
    }
  }

  List<List<CardModel>> distribuirCartas() {
    maoJogador = List.generate(4, (_) => []);
    var cartas = 3;
    for (int i = 0; i < cartas; i++) {
      for (var jogador = 0; jogador < 4; jogador++) {
        maoJogador[jogador].add(cartasNoBaralho.removeLast());
      }
    }
    return maoJogador;
  }

  void definirListaJogadores() {
  // Os nomes vão ser pegos nos campos que os jogadores irão inseri-los
  List<String> nomesJogadores = ["Jessica", "Gabriel", "Emily", "Natan"];
  
  // Adicionando jogadores com nomes da lista e posições corretas
  listaJogador.add(PlayerModel(nomesJogadores[0], 1, 1, PlayerPosition.top));
  listaJogador.add(PlayerModel(nomesJogadores[1], 2, 2, PlayerPosition.left));
  listaJogador.add(PlayerModel(nomesJogadores[2], 3, 1, PlayerPosition.bottom));
  listaJogador.add(PlayerModel(nomesJogadores[3], 4, 2, PlayerPosition.right));
}

  void defenirMaoJogadores(){
  // Definir a mão de cada jogador
  for (int i = 0; i < 4; i++) {
   listaJogador[i].getMaoJogador(maoJogador[i]);
   }
  }

  List<List<CardModel>> CartasRemovidaMao() {
    List<List<CardModel>> novaMaoJogador = [];
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