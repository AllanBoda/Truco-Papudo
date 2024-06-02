import 'package:flutter/material.dart';
import 'TrucoCard.dart';
import 'CardModel.dart';

class PlayerHand extends StatefulWidget {
  final List<CardModel> hand;
  final bool showHand;
  final bool vertical;
  final Function(int) onTapCard;
  final bool isCurrentPlayer; // Novo parâmetro

  const PlayerHand({
    Key? key,
    required this.hand,
    this.showHand = false,
    this.vertical = false,
    required this.onTapCard,
    this.isCurrentPlayer = false, // Inicializa como falso
  }) : super(key: key);

  @override
  _PlayerHandState createState() => _PlayerHandState();
}

class _PlayerHandState extends State<PlayerHand> {
  late List<bool> _tappedIndices; // Lista para rastrear se a carta foi tocada ou não

  @override
  void initState() {
    super.initState();
    _tappedIndices = List.generate(widget.hand.length, (index) => false); // Inicializa a lista com false para cada carta
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.isCurrentPlayer
            ? Border.all(color: Colors.yellow, width: 5)
            : null, // Adiciona contorno se for o jogador atual
        boxShadow: widget.isCurrentPlayer
            ? [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.8),
                  spreadRadius: 5,
                  blurRadius: 20,
                ),
              ]
            : [], // Adiciona sombra para efeito de glow
      ),
      child: widget.vertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildCards(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildCards(),
            ),
    );
  }

  List<Widget> _buildCards() {
    return widget.hand.asMap().entries.map((entry) {
      int index = entry.key;
      CardModel card = entry.value;
      return GestureDetector(
        onTap: () {
          setState(() {
            _tappedIndices = List.generate(widget.hand.length, (index) => false); // Reseta todos os índices tocados
            _tappedIndices[index] = true; // Define o índice da carta tocada como verdadeiro
          });
          widget.onTapCard(index);
        },
        child: _buildCard(card, index),
      );
    }).toList();
  }

  Widget _buildCard(CardModel card, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: _tappedIndices[index]
          ? EdgeInsets.symmetric(vertical: 0, horizontal: 2)
          : EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: TrucoCard(cardModel: card, showFace: widget.showHand),
    );
  }
}
