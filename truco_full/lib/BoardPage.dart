import 'package:flutter/material.dart';

import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Class/CartaNaMesa.dart';
import 'package:truco_full/Model/PlayerModel.dart';
import 'package:truco_full/TrucoCard.dart';
import 'PlayerHand.dart';
import './Class/Game.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final Game game = Game(); // Instância da classe Game para gerenciar a lógica do jogo
  int jogadoresQueJogaram = 0; // Variável de controle para acompanhar quantos jogadores jogaram suas cartas
  bool cartaTocada = false; // Flag para monitorar se a carta foi tocada
 // Variáveis de estado para controlar a visibilidade dos botões
  bool trucoRequested = false;
  bool trucoAccepted = false;
  bool trucoIncreased = false;

  @override
  void initState() {
    super.initState();
    game.iniciarJogo(); // Inicializa o jogo ao criar a tela
  }

  // Função para jogar uma carta ao tocar em uma carta na mão do jogador
  void _jogarCarta(int index, PlayerModel jogador) {
    setState(() {
      if (cartaTocada && jogadoresQueJogaram <= 2 && jogador == game.jogadorAtual) { 
        game.escolherCartaDaJogada(index, jogador); // Chama o método escolherCartaDaJogada da classe Game passando o índice clicado
        jogadoresQueJogaram++; // Incrementa o contador de jogadores que jogaram suas cartas
        cartaTocada = false; // Reinicia a flag de toque na carta

        // Define o próximo jogador
        game.jogadorAtual = game.proximoJogador()!;

        // Verifica se todos os jogadores já jogaram
        if (jogadoresQueJogaram == 2) {
          game.iniciarRodada();
          jogadoresQueJogaram = 0; // Reinicia o contador de jogadores que jogaram
        }
      }
    });
  }
PreferredSizeWidget _buildAppBar() {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 4, 97, 1),
    centerTitle: true, // Mantém centralização do conteúdo
    actions: [
      Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${game.baralho.listaJogador.first.nome}: ${game.baralho.listaJogador.first.pontos}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 1),
              Text(
                '${game.baralho.listaJogador[1].nome}: ${game.baralho.listaJogador[1].pontos}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


  // Converte a lista de cartas do jogador para uma lista de modelos de cartas exibíveis
  List<CardModel> converterCartasParaString(List<CardModel> cartas) {
    return cartas.map((carta) {
      return CardModel(
        faceValue: '${carta.value} de ${carta.naipe}',
        value: carta.value,
        naipe: carta.naipe,
        faceUrl: "",
      );
    }).toList();
  }

  // Converte a lista de cartas na mesa para uma lista de modelos de cartas exibíveis
  List<CardModel> converterCartasNaMesaParaString(List<CartaNaMesa> cartasNaMesa) {
    return cartasNaMesa.map((cartaNaMesa) {
      return CardModel(
        faceValue: '${cartaNaMesa.carta?.value} de ${cartaNaMesa.carta?.naipe}',
        value: cartaNaMesa.carta?.value ?? 0,
        naipe: cartaNaMesa.carta?.naipe ?? 0,
        faceUrl: "",
      );
    }).toList();
  }

  // Função para resetar o estado dos botões de truco
void resetTrucoState() {
  trucoRequested = false;
  trucoAccepted = false;
  trucoIncreased = false;
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    backgroundColor: Colors.green,
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Exibe a carta de manilha na tela
          Text(
            'Manilha: ${game.manilha}',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          //  Defenir botões de truco do jogador 1
          if (game.rodada <= 3)
          if (game.jogadorAtual == game.baralho.listaJogador[0])
            Padding(
              padding: const EdgeInsets.only(top: 8.0), // Ajuste de espaçamento entre a mesa e os botões
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        game.trucar(game.jogadorAtual, game.valorTruco!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Jogador trucou com 3 pontos!')),
                        );
                      });
                    },
                    child: const Text('Trucar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (game.jogadorQueTrucou != null) {
                          game.aceitarTruco(game.jogadorAtual);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Jogador ${game.jogadorQueAceitou} aceitou o truco! Partida vale ${game.valorTruco} pontos.')),
                          );
                        }
                      });
                    },
                    child: const Text('Aceitar Truco'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (game.jogadorQueAceitou != game.jogadorAtual) {
                          game.aumentarTruco(game.jogadorAtual);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Jogador ${game.jogadorQueAumentouTruco} aumentou o truco para ${game.valorTruco} pontos!')),
                          );
                        }
                      });
                    },
                    child: const Text('Aumentar Truco'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (game.jogadorQueAceitou != null) {
                          game.desistirTruco(game.jogadorAtual);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Jogador ${game.jogadorAtual} desistiu do truco')),
                          );
                        }
                      });
                    },
                    child: const Text('Desistir'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mão do jogador 1 (Jessica - Topo)
                PlayerHand(
                  hand: converterCartasParaString(
                      game.baralho.listaJogador.first.maoJogador),
                  showHand: true,
                  onTapCard: (index) {
                    cartaTocada = true; // Define a flag de toque na carta
                    _jogarCarta(index, game.baralho.listaJogador.first);
                  },
                  isCurrentPlayer: game.baralho.listaJogador.first == game.jogadorAtual,
                  playerName: game.baralho.listaJogador.first.nome,
                ),
                // Exibe as cartas na mesa
                Wrap(
                  alignment: WrapAlignment.center,
                  children: converterCartasNaMesaParaString(game.baralho.cartasNaMesa).map((cardModel) {
                    return TrucoCard(
                      cardModel: cardModel,
                      showFace: true, // Para mostrar a face da carta
                    );
                  }).toList(),
                ),
                // Espaço vazio
                Expanded(child: Container()), // Preenchimento para centralizar o jogador Gabriel

                // Mão do jogador 2 (Gabriel - Abaixo e Centralizado)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PlayerHand(
                    hand: converterCartasParaString(
                        game.baralho.listaJogador[1].maoJogador),
                    showHand: true,
                    onTapCard: (index) {
                      cartaTocada = true; // Define a flag de toque na carta
                      _jogarCarta(index, game.baralho.listaJogador[1]);
                    },
                    isCurrentPlayer: game.baralho.listaJogador[1] == game.jogadorAtual,
                    playerName: game.baralho.listaJogador[1].nome,
                  ),
                ),
              ],
            ),
          ),
           // Defenir botões de truco do jogador 2
          if (game.rodada <= 3)
           if (game.jogadorAtual == game.baralho.listaJogador[1])
            Padding(
              padding: const EdgeInsets.only(top: 8.0), // Ajuste de espaçamento entre a mesa e os botões
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        game.trucar(game.jogadorAtual, game.valorTruco!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Jogador trucou com 3 pontos!')),
                        );
                      });
                    },
                    child: const Text('Trucar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (game.jogadorQueTrucou != null) {
                          game.aceitarTruco(game.jogadorAtual);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Jogador ${game.jogadorQueAceitou} aceitou o truco! Partida vale ${game.valorTruco} pontos.')),
                          );
                        }
                      });
                    },
                    child: const Text('Aceitar Truco'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (game.jogadorQueAceitou != game.jogadorAtual) {
                          game.aumentarTruco(game.jogadorAtual);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Jogador ${game.jogadorQueAumentouTruco} aumentou o truco para ${game.valorTruco} pontos!')),
                          );
                        }
                      });
                    },
                    child: const Text('Aumentar Truco'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (game.jogadorQueAceitou != null) {
                          game.desistirTruco(game.jogadorAtual);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Jogador ${game.jogadorAtual} desistiu do truco')),
                          );
                        }
                      });
                    },
                    child: const Text('Desistir'),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
}