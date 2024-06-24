import 'package:flutter/material.dart'; // Importação do pacote Flutter Material
import 'package:truco_full/Model/CardModel.dart'; // Importação do modelo CardModel
import 'TrucoCard.dart'; // Importação do widget TrucoCard

/// Widget que representa a mão de cartas de um jogador.
class PlayerHand extends StatefulWidget {
  final List<CardModel> hand; // Lista de cartas na mão do jogador
  final bool showHand; // Indica se a mão do jogador deve ser mostrada
  final bool vertical; // Indica se as cartas devem ser exibidas verticalmente
  final Function(int) onTapCard; // Função a ser chamada quando uma carta é tocada
  final bool isCurrentPlayer; // Indica se este jogador é o jogador atual
  final String playerName; // Nome do jogador

  /// Construtor de PlayerHand.
  ///
  /// [hand] - Lista de cartas na mão do jogador.
  /// [showHand] - Opcional. Indica se a mão do jogador deve ser visível (padrão: false).
  /// [vertical] - Opcional. Indica se as cartas devem ser exibidas verticalmente (padrão: false).
  /// [onTapCard] - Função a ser chamada quando uma carta é tocada.
  /// [isCurrentPlayer] - Indica se este jogador é o jogador atual (padrão: false).
  /// [playerName] - Nome do jogador.
  const PlayerHand({
    Key? key,
    required this.hand,
    this.showHand = false,
    this.vertical = false,
    required this.onTapCard,
    this.isCurrentPlayer = false,
    required this.playerName,
  }) : super(key: key);

  @override
  _PlayerHandState createState() => _PlayerHandState();
}

/// Estado associado ao widget PlayerHand.
class _PlayerHandState extends State<PlayerHand> {
  late List<bool> _tappedIndices; // Lista para rastrear quais cartas foram tocadas

  @override
  void initState() {
    super.initState();
    // Inicializa a lista _tappedIndices com false, indicando que nenhuma carta foi tocada
    _tappedIndices = List.generate(widget.hand.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Exibe o nome e a equipe do jogador
        Text(
          '${widget.playerName} ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.isCurrentPlayer ? Colors.black : Colors.white,
          ),
        ),
        Container(
          child: widget.vertical
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildCards(), // Constrói as cartas verticalmente
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildCards(), // Constrói as cartas horizontalmente
                ),
        ),
      ],
    );
  }

  // Método para construir os widgets de cartas na mão do jogador
  List<Widget> _buildCards() {
    return widget.hand.asMap().entries.map((entry) {
      int index = entry.key;
      CardModel card = entry.value;
      return GestureDetector(
        onTap: () {
          setState(() {
            // Reseta o estado de _tappedIndices e define a carta atual como tocada
            _tappedIndices = List.generate(widget.hand.length, (i) => i == index);
          });
          widget.onTapCard(index); // Chama a função onTapCard passando o índice da carta tocada
        },
        child: _buildCard(card, index), // Constrói o widget da carta
      );
    }).toList();
  }

  // Método para construir o widget de uma carta
  Widget _buildCard(CardModel card, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Animação para o container da carta
      margin: (index < _tappedIndices.length && _tappedIndices[index])
          ? const EdgeInsets.only(left: 5.0) // Margem se a carta foi tocada
          : const EdgeInsets.symmetric(vertical: 0, horizontal: 0), // Sem margem se a carta não foi tocada
      decoration: BoxDecoration(
        border: widget.isCurrentPlayer
            ? Border.all(color: Colors.deepOrange, width: 3.0) // Borda laranja se for o jogador atual
            : Border.all(color: Colors.transparent, width: 3.0), // Borda transparente se não for o jogador atual
        borderRadius: BorderRadius.circular(8.0), // Borda arredondada
      ),
      child: TrucoCard(cardModel: card, showFace: widget.showHand), // Widget da carta
    );
  }
}
