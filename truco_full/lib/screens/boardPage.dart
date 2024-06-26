import 'package:flutter/material.dart';
import 'package:truco_full/model/cardModel.dart'; // Importação do modelo de cartas
import 'package:truco_full/model/cartasNaMesa.dart'; // Importação do modelo de cartas na mesa
import 'package:truco_full/model/playerModel.dart'; // Importação do modelo de jogador
import 'package:truco_full/screensService/trucoCard.dart'; // Importação do serviço de cartas do Truco
import '../screensService/playerHand.dart'; // Importação do serviço da mão do jogador
import '../service/gameService.dart'; // Importação do serviço de lógica do jogo

/// Página principal do tabuleiro do jogo Truco.
class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  _BoardPageState createState() => _BoardPageState();
}

/// Estado da página do tabuleiro do jogo Truco.
class _BoardPageState extends State<BoardPage> {
  final Game game = Game(); // Instância da classe Game para gerenciar a lógica do jogo
  int jogadoresQueJogaram = 0; // Variável de controle para acompanhar quantos jogadores jogaram suas cartas
  bool cartaTocada = false; // Flag para monitorar se a carta foi tocada
  late TrucoCard trucoCard = TrucoCard.vazio();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    if (game.mensagemFinalDeJogo.isNotEmpty) {
      _showWinnerDialog(game.mensagemFinalDeJogo);
    }
  });
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

  /// Constrói o widget AppBar customizado para exibir os pontos dos jogadores.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 4, 97, 1), // Cor de fundo da barra de aplicativo
      centerTitle: true, // Mantém centralização do título
      actions: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Exibe o nome e pontos do primeiro jogador
                Text(
                  '${game.definicaCartasBaralho.listaJogador.first.nome}: ${game.definicaCartasBaralho.listaJogador.first.pontos}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 1), // Espaço entre os textos dos jogadores
                // Exibe o nome e pontos do segundo jogador
                Text(
                  '${game.definicaCartasBaralho.listaJogador[1].nome}: ${game.definicaCartasBaralho.listaJogador[1].pontos}',
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
        faceUrl: "", // URL da face da carta (vazio neste exemplo)
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
        faceUrl: "", // URL da face da carta (vazio neste exemplo)
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Barra de aplicativo personalizada
      backgroundColor: Colors.green, // Cor de fundo do corpo da página
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           // Exibe a manilha na tela
Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.white, // Cor da borda
      width: 1.0,          // Largura da borda em pixels
    ),
    borderRadius: BorderRadius.circular(8.0), // Opcional: borda arredondada
  ),
  child: RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 2, 37, 20)),
      children: [
        const TextSpan(text: 'Carta Virada: '),
        TextSpan(
          text: game.definicaCartasBaralho.cartaVirada.value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold), // Estilo para o valor da manilha
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              trucoCard.getSuitIcon(game.definicaCartasBaralho.cartaVirada.naipe), // Ícone do naipe da carta
              style: const TextStyle(fontSize: 20), // Tamanho de fonte menor
            ),
          ),
        ),
      ],
    ),
  ),
),

            // Botões de truco para o jogador 1 (se ainda estiver na rodada)
            if (game.rodada <= 3 &&
                game.jogadorAtual == game.definicaCartasBaralho.listaJogador[0])
              Padding(
                padding: const EdgeInsets.only(top: 8.0), // Espaçamento entre a mesa e os botões
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if(!cartaTocada){
                             game.trucar(game.jogadorAtual, game.valorTruco!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Jogador trucou com 3 pontos!')),
                          );
                          }
                         
                        });
                      },
                      child: const Text('Trucar'), // Texto do botão de trucar
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (game.jogadorQueTrucou != null) {
                            game.aceitarTruco(game.jogadorAtual);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Jogador ${game.definicaCartasBaralho.listaJogador[0].nome} aceitou o truco! Partida vale ${game.valorTruco} pontos.')),
                            );
                          }
                        });
                      },
                      child: const Text('Aceitar Truco'), // Texto do botão de aceitar truco
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if ( game.jogadorQueTrucou != null &&
                           game.jogadorQueAceitou != game.jogadorAtual) {
                            game.aumentarTruco(game.jogadorAtual);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Jogador ${game.definicaCartasBaralho.listaJogador[0].nome} aumentou o truco para ${game.valorTruco} pontos!')),
                            );
                          }
                        });
                      },
                      child: const Text('Aumentar Truco'), // Texto do botão de aumentar truco
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (game.jogadorQueTrucou != null) {
                            game.desistirTruco(game.jogadorAtual);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Jogador ${game.jogadorAtual} desistiu do truco')),
                            );
                          }
                        });
                      },
                      child: const Text('Desistir'), // Texto do botão de desistir
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
                        game.definicaCartasBaralho.listaJogador.first.maoJogador), // Converte as cartas do jogador 1 em modelos exibíveis
                    showHand: true,
                    onTapCard: (index) {
                      cartaTocada = true; // Define a flag
                      cartaTocada = true; // Define a flag de toque na carta
                      _jogarCarta(index, game.definicaCartasBaralho.listaJogador.first);
                    },
                    isCurrentPlayer: game.definicaCartasBaralho.listaJogador.first == game.jogadorAtual, // Verifica se é a vez do jogador 1
                    playerName: game.definicaCartasBaralho.listaJogador.first.nome, // Nome do jogador 1
                  ),

                  // Exibe as cartas na mesa
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: converterCartasNaMesaParaString(game.definicaCartasBaralho.cartasNaMesa).map((cardModel) {
                      return TrucoCard(
                        cardModel: cardModel,
                        showFace: true, // Mostra a face da carta
                      );
                    }).toList(),
                  ),

                  // Espaço vazio para centralizar o jogador 2 (Gabriel)
                  Expanded(child: Container()),

                  // Mão do jogador 2 (Gabriel - Abaixo e Centralizado)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PlayerHand(
                      hand: converterCartasParaString(
                          game.definicaCartasBaralho.listaJogador[1].maoJogador), // Converte as cartas do jogador 2 em modelos exibíveis
                      showHand: true,
                      onTapCard: (index) {
                        cartaTocada = true; // Define a flag de toque na carta
                        _jogarCarta(index, game.definicaCartasBaralho.listaJogador[1]);
                      },
                      isCurrentPlayer: game.definicaCartasBaralho.listaJogador[1] == game.jogadorAtual, // Verifica se é a vez do jogador 2
                      playerName: game.definicaCartasBaralho.listaJogador[1].nome, // Nome do jogador 2
                    ),
                  ),
                ],
              ),
            ),

            // Botões de truco para o jogador 2 (se ainda estiver na rodada)
            if (game.rodada <= 3 &&
                game.jogadorAtual == game.definicaCartasBaralho.listaJogador[1])
              Padding(
                padding: const EdgeInsets.only(top: 8.0), // Espaçamento entre a mesa e os botões
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          game.trucar(game.jogadorAtual, game.valorTruco!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Jogador 2 trucou com 3 pontos!')),
                          );
                        });
                      },
                      child: const Text('Trucar'), // Texto do botão de trucar
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (game.jogadorQueTrucou != null) {
                            game.aceitarTruco(game.jogadorAtual);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Jogador ${game.definicaCartasBaralho.listaJogador[1].nome} aceitou o truco! Partida vale ${game.valorTruco} pontos.')),
                            );
                          }
                        });
                      },
                      child: const Text('Aceitar Truco'), // Texto do botão de aceitar truco
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                           if ( game.jogadorQueTrucou != null &&
                           game.jogadorQueAceitou != game.jogadorAtual) {
                            game.aumentarTruco(game.jogadorAtual);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Jogador ${game.definicaCartasBaralho.listaJogador[1].nome} aumentou o truco para ${game.valorTruco} pontos!')),
                            );
                          }
                        });
                      },
                      child: const Text('Aumentar Truco'), // Texto do botão de aumentar truco
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (game.jogadorQueTrucou != null) {
                            game.desistirTruco(game.jogadorAtual);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Jogador 2 desistiu do truco')),
                            );
                          }
                        });
                      },
                      child: const Text('Desistir'), // Texto do botão de desistir
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
 
void _showWinnerDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Parabéns!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Sim'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Não'),
          ),
        ],
      );
    },
  );
}

void _resetGame() {
  setState(() {
    game.reset();
  });
}
}
