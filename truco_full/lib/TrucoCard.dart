import 'package:flutter/material.dart';
import 'CardModel.dart';

class TrucoCard extends StatelessWidget {
  final CardModel cardModel;
  final bool showFace;

  const TrucoCard({
    Key? key,
    required this.cardModel,
    this.showFace = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      child: showFace
          ? Center(
              child: Text(
                cardModel.faceValue,
                style: const TextStyle(fontSize: 25),
              ),
            )
          : null,
    );
  }
}
