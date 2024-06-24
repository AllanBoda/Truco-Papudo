import 'dart:math';
import 'package:truco_full/ENUM/playerPosition.dart';
import 'package:truco_full/Model/CardModel.dart';
import 'package:truco_full/Model/CartasNaMesa.dart';
import 'package:truco_full/Model/PlayerModel.dart';

/// A classe `DefinicaoCartasBaralho` gerencia o baralho, define as mãos dos 
/// jogadores e a lista de jogadores para um jogo de truco.

class DefinicaoCartasBaralho {
  List<CardModel> cartasNoBaralho = [];
  List<List<CardModel>> maoJogador = [];
  List<CardModel> cartaRemovidaMao = [];
  List<CartaNaMesa> cartasNaMesa = [];
  List<PlayerModel> listaJogador = [];

  CardModel cartaVirada = CardModel.vazio();

  /// Inicializa o jogo. Define a lista de jogadores, prepara o baralho, 
  /// distribui as cartas e define as mãos dos jogadores.
  void inicializar() {
    // Verifica se a lista está vazia antes de definir a lista de jogadores
    if (listaJogador.isEmpty) {
      definirListaJogadores();
    }
    // Se não estiver vazia, sinaliza que é uma segunda rodada, 
    //assim a lista permanece com os dados da primeira partida
    definirCartasBaralho();
    distribuirCartas();
    viraCarta();
    defenirMaoJogadores();
  }

  /// Prepara o baralho com as cartas necessárias para o jogo e embaralha as cartas.
  void definirCartasBaralho() {
    for (int naipe = 1; naipe < 4; naipe++) {
      for (int valor = 1; valor <= 7; valor++) {
        cartasNoBaralho.add(CardModel.cards(value: valor, naipe: naipe));
      }
    }
    for (int naipe = 1; naipe < 4; naipe++) {
      for (int valor = 10; valor <= 12; valor++) {
        cartasNoBaralho.add(CardModel.cards(value: valor, naipe: naipe));
      }
    }
    embaralharBaralho(cartasNoBaralho);
  }

  /// Vira a última carta do baralho para determinar a carta virada.
  void viraCarta() {
    cartaVirada = cartasNoBaralho.removeLast();
    cartasNoBaralho.add(cartaVirada);
    cartasNoBaralho.remove(cartaVirada);
  }

  /// Embaralha as cartas do baralho usando o algoritmo de Fisher-Yates.
  /// 
  /// @param cartas A lista de cartas a serem embaralhadas.
  void embaralharBaralho(List<CardModel> cartas) {
    final random = Random();
    for (var i = cartas.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = cartas[i];
      cartas[i] = cartas[j];
      cartas[j] = temp;
    }
  }

  /// Distribui as cartas para os jogadores.
  /// 
  /// @return Uma lista contendo as mãos dos jogadores.
  List<List<CardModel>> distribuirCartas() {
    maoJogador = List.generate(2, (_) => []);
    var cartas = 3;
    for (int i = 0; i < cartas; i++) {
      for (var jogador = 0; jogador < 2; jogador++) {
        maoJogador[jogador].add(cartasNoBaralho.removeLast());
      }
    }
    return maoJogador;
  }

  /// Define a lista de jogadores com nomes e posições fixas.
  void definirListaJogadores() {
    // Os nomes vão ser pegos nos campos que os jogadores irão inseri-los
    List<String> nomesJogadores = ["Jessica", "Gabriel"];
    
    // Adicionando jogadores com nomes da lista e posições corretas
    listaJogador.add(PlayerModel(nomesJogadores[0], 1, 1, PlayerPosition.top));
    listaJogador.add(PlayerModel(nomesJogadores[1], 2, 2, PlayerPosition.bottom));
  }

  /// Define a mão de cada jogador.
  void defenirMaoJogadores() {
    for (int i = 0; i < 2; i++) {
      listaJogador[i].getMaoJogador(maoJogador[i]);
    }
  }

  /// Remove uma carta da mão de cada jogador e retorna a nova mão.
  /// 
  /// @return Uma lista contendo as novas mãos dos jogadores.
  List<List<CardModel>> CartasRemovidaMao() {
    List<List<CardModel>> novaMaoJogador = [];
    for (int j = 0; j < 2; j++) {
      var cartaRemovida = maoJogador[j].removeLast();
      cartaRemovidaMao.add(cartaRemovida);
    }
    imprimeMaoJogador();
    return novaMaoJogador;
  }

  /// Exibe as mãos dos jogadores.
  void imprimeMaoJogador() {
    for (int i = 0; i < listaJogador.length; i++) {
      print("Jogador ${i + 1}: ${listaJogador[i]}");
    }
  }
}
