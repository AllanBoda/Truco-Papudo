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
      width: 50, // Largura menor para as cartas
      height: 70, // Altura menor para as cartas
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: showFace
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cardModel.value.toString(),
                    style: TextStyle(fontSize: 14), // Tamanho de fonte menor
                  ),
                  SizedBox(height: 3), // Espaçamento menor entre o valor e o naipe
                  Text(
                    _getSuitIcon(cardModel.naipe),
                    style: TextStyle(fontSize: 14), // Tamanho de fonte menor
                  ),
                ],
              )
            : null, // Se showFace for falso, não mostra nada no centro
      ),
    );
  }

  String _getSuitIcon(int naipe) {
    switch (naipe) {
      case 1:
        return '♦'; // Ouros
      case 2:
        return '♠'; // Espadas
      case 3:
        return '♥'; // Copas
      case 4:
        return '♣'; // Paus
      default:
        return ''; // Nenhum naipe conhecido
    }
  }
}
