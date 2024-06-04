import 'package:flutter/material.dart';
import 'TrucoCard.dart';
import 'CardModel.dart';

class PlayerHand extends StatefulWidget {
  final List<CardModel> hand;
  final bool showHand;
  final bool vertical;
  final Function(int) onTapCard;
  final bool isCurrentPlayer;
  final String playerName;
  final int playerTeam;

  const PlayerHand({
    Key? key,
    required this.hand,
    this.showHand = false,
    this.vertical = false,
    required this.onTapCard,
    this.isCurrentPlayer = false,
    required this.playerName,
    required this.playerTeam,
  }) : super(key: key);

  @override
  _PlayerHandState createState() => _PlayerHandState();
}

class _PlayerHandState extends State<PlayerHand> {
  late List<bool> _tappedIndices;

  @override
  void initState() {
    super.initState();
    _tappedIndices = List.generate(widget.hand.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Exibe o nome e a equipe do jogador
        Text(
          '${widget.playerName} (Equipe ${widget.playerTeam})',
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
                  children: _buildCards(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildCards(),
                ),
        ),
      ],
    );
  }

  List<Widget> _buildCards() {
    return widget.hand.asMap().entries.map((entry) {
      int index = entry.key;
      CardModel card = entry.value;
      return GestureDetector(
        onTap: () {
          setState(() {
            _tappedIndices = List.generate(widget.hand.length, (index) => false);
            _tappedIndices[index] = true;
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
          ? EdgeInsets.only(left: 5.0)
          : EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        border: widget.isCurrentPlayer
            ? Border.all(color: Colors.deepOrange, width: 3.0)
            : Border.all(color: Colors.transparent, width: 3.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TrucoCard(cardModel: card, showFace: widget.showHand),
    );
  }
}
