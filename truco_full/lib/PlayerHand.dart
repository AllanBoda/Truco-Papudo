import 'package:flutter/material.dart';
import 'TrucoCard.dart';
import 'CardModel.dart';

class PlayerHand extends StatelessWidget {
  final List<CardModel> hand;
  final bool showHand;
  final bool vertical;

  const PlayerHand({
    Key? key,
    required this.hand,
    this.showHand = false,
    this.vertical = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = hand
        .map((card) => TrucoCard(cardModel: card, showFace: showHand))
        .toList();

    return vertical
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards,
          );
  }
}
