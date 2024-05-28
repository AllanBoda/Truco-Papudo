import 'dart:math';
import './Cartas.dart';
import 'Jogador.dart';
import 'package:flutter/material.dart';

class Baralho {
  List<Cartas> cartasNoBaralho = [];
  List<List<Cartas>> maoJogador = [];
  List<Cartas> cartaRemovidaMao = [];
  late List<Jogador> listaJogador;

  Cartas cartaVirada = Cartas.vazio();

  void inicializar() {
    Baralhos();
    distribuirCartas();
    viraCarta();
    listaJogador = adicionarListaJogador();
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

  List<Jogador> adicionarListaJogador() {
    List<Jogador> listaJogadores = [];
    for (int i = 0; i < maoJogador.length; i++) {
      listaJogadores.add(Jogador(
          "Jogador ${i + 1}", // Nome do jogador
          i + 1, // ID do jogador
          (i % 2) + 1, // Time do jogador (alternando entre 1 e 2)
          0, // Placar inicial
          maoJogador[i])); // Mão do jogador
    }
    return listaJogadores;
  }

  List<List<Cartas>> CartasRemovidaMao() {
    List<List<Cartas>> novaMaoJogador = [];
    for (int j = 0; j < 4; j++) {
      var cartaRemovida = maoJogador[j].removeLast();
      cartaRemovidaMao.add(cartaRemovida);
      // Para testes
      debugPrint(
          "${listaJogador[j].SetNome()}: ${cartaRemovidaMao.last.toString()}");
    }
    imprimeMaoJogador();
    return novaMaoJogador;
  }

  void imprimeMaoJogador() {
    // Exibe os jogadores com suas cartas
    for (int i = 0; i < listaJogador.length; i++) {
      debugPrint("Jogador ${i + 1}: ${listaJogador[i]}");
    }
  }
}
