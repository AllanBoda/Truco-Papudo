import 'package:flutter/material.dart'; // Importação do pacote Flutter Material
import 'package:truco_full/Model/CardModel.dart'; // Importação do modelo CardModel

/// Widget que representa uma carta de truco.
class TrucoCard extends StatelessWidget {
  final CardModel cardModel; // Modelo de dados da carta
  final bool showFace; // Flag para mostrar a face da carta

  /// Construtor de TrucoCard.
  ///
  /// [cardModel] - O modelo de dados da carta.
  /// [showFace] - Opcional. Define se a face da carta deve ser mostrada (padrão: false).
  const TrucoCard({
    super.key,
    required this.cardModel,
    this.showFace = false,
  });

   /// Construtor vazio de TrucoCard para representar um estado sem carta.
  TrucoCard.vazio()
      : cardModel = CardModel.vazio(), // Cria um CardModel vazio
        showFace = false; // Mostra a face da carta como false

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, // Largura menor para as cartas
      height: 70, // Altura menor para as cartas
      margin: const EdgeInsets.all(5), // Margem ao redor do contêiner
      decoration: BoxDecoration(
        color: Colors.white, // Cor de fundo branca
        borderRadius: BorderRadius.circular(10), // Borda arredondada
      ),
      child: Center(
        child: showFace
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cardModel.value.toString(), // Valor da carta convertido para string
                    style: const TextStyle(fontSize: 14), // Tamanho de fonte menor
                  ),
                  const SizedBox(height: 3), // Espaçamento menor entre o valor e o naipe
                  Text(
                    getSuitIcon(cardModel.naipe), // Ícone do naipe da carta
                    style: const TextStyle(fontSize: 14), // Tamanho de fonte menor
                  ),
                ],
              )
            : null, // Se showFace for falso, não mostra nada no centro
      ),
    );
  }

  /// Método privado para obter o ícone do naipe da carta.
  ///
  /// [naipe] - Número que representa o naipe da carta.
  String getSuitIcon(int naipe) {
    switch (naipe) {
      case 1:
        return '♦'; // Retorna o ícone para Ouros
      case 2:
        return '♠'; // Retorna o ícone para Espadas
      case 3:
        return '♥'; // Retorna o ícone para Copas
      case 4:
        return '♣'; // Retorna o ícone para Paus
      default:
        return ''; // Retorna vazio se o naipe não for reconhecido
    }
  }
}
