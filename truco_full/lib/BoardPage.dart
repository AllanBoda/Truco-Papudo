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

  @override
  void initState() {
    super.initState();
    game.iniciarJogo(); // Inicializa o jogo ao criar a tela
  }

  // Função para jogar uma carta ao tocar em uma carta na mão do jogador
  void _jogarCarta(int index, PlayerModel jogador) {
    setState(() {
      if (cartaTocada && jogadoresQueJogaram <= 4 && jogador == game.jogadorAtual) { // Verifica se a carta foi tocada, se ainda não foram jogadas as cartas de todos os jogadores e se é a vez do jogador
        game.escolherCartaDaJogada(index, jogador); // Chama o método escolherCartaDaJogada da classe Game passando o índice clicado
        jogadoresQueJogaram++; // Incrementa o contador de jogadores que jogaram suas cartas
        cartaTocada = false; // Reinicia a flag de toque na carta

        // Define o próximo jogador
        game.jogadorAtual = game.proximoJogador();

        // Verifica se todos os jogadores já jogaram
        if (jogadoresQueJogaram == 4) {
          // Chama o método para definir o ganhador da rodada
          game.definirGanhadorRodada(
            game.retornarListaDeForca(),
            game.baralho.cartasNaMesa,
            game.trucoAceito,
          );
          jogadoresQueJogaram = 0; // Reinicia o contador de jogadores que jogaram
        }
      }
    });
  }

  // Converte a lista de cartas do jogador para uma lista de modelos de cartas exibíveis
  List<CardModel> converterCartasParaString(List<CardModel> cartas) {
    return cartas.map((carta) {
      return CardModel(
        faceValue: '${carta.value} de ${carta.naipe}',
        value: carta.value,
        naipe: carta.naipe,
        faceUrl: ""
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
        faceUrl: ""
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Exibe a carta de manilha na tela
            Text(
              'Manilha: ${game.manilha}', // Supondo que você tenha uma representação de string adequada para a carta de manilha
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    playerTeam: game.baralho.listaJogador.first.equipe,
                  ),
                  // Mão do jogador 2 (Gabriel - Esquerda)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PlayerHand(
                        hand: converterCartasParaString(
                            game.baralho.listaJogador[1].maoJogador),
                        vertical: true,
                        showHand: true,
                        onTapCard: (index) {
                          cartaTocada = true; // Define a flag de toque na carta
                          _jogarCarta(index, game.baralho.listaJogador[1]);
                        },
                        isCurrentPlayer: game.baralho.listaJogador[1] == game.jogadorAtual,
                        playerName: game.baralho.listaJogador[1].nome,
                        playerTeam: game.baralho.listaJogador[1].equipe,
                      ),
                      const Spacer(flex: 5),
                      // Mão do jogador 4 (Natan - Direita)
                      PlayerHand(
                        hand: converterCartasParaString(
                            game.baralho.listaJogador[3].maoJogador),
                        vertical: true,
                        showHand: true,
                        onTapCard: (index) {
                          cartaTocada = true; // Define a flag de toque na carta
                          _jogarCarta(index, game.baralho.listaJogador[3]);
                        },
                        isCurrentPlayer: game.baralho.listaJogador[3] == game.jogadorAtual,
                        playerName: game.baralho.listaJogador[3].nome,
                        playerTeam: game.baralho.listaJogador[3].equipe,
                      ),
                    ],
                  ),
                  // Mão do jogador 3 (Emily - Baixo)
                  PlayerHand(
                    hand: converterCartasParaString(
                        game.baralho.listaJogador[2].maoJogador),
                    showHand: true,
                    onTapCard: (index) {
                      cartaTocada = true; // Define a flag de toque na carta
                      _jogarCarta(index, game.baralho.listaJogador[2]);
                    },
                    isCurrentPlayer: game.baralho.listaJogador[2] == game.jogadorAtual,
                    playerName: game.baralho.listaJogador[2].nome,
                    playerTeam: game.baralho.listaJogador[2].equipe,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
