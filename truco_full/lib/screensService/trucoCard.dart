import 'package:flutter/material.dart';
import 'package:truco_full/model/cardModel.dart';

/// Widget que representa uma carta de truco.
class TrucoCard extends StatelessWidget {
  final CardModel cardModel; // Modelo de dados da carta
  final bool isPlayerTurn; // Flag para indicar se é a vez do jogador


  /// Construtor de TrucoCard.
  ///
  /// [cardModel] - O modelo de dados da carta.
  /// [isPlayerTurn] - Define se é a vez do jogador atual.
  const TrucoCard({
    super.key,
    required this.cardModel,
    required this.isPlayerTurn,
  });

  /// Construtor vazio de TrucoCard para representar um estado sem carta.
  TrucoCard.vazio({super.key})
      : cardModel = CardModel.vazio(), // Cria um CardModel vazio
        isPlayerTurn = false; // Não é a vez de nenhum jogador

  @override
Widget build(BuildContext context) {
  return Container(
    width: 50, // Largura menor para as cartas
    height: 70, // Altura menor para as cartas
    margin: const EdgeInsets.all(5), // Margem ao redor do contêiner
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Borda arredondada
      color: !isPlayerTurn ? Colors.greenAccent : Colors.white, // Cor de fundo cinza se não for a vez do jogador, branca se for
    ),
    child: Center(
      child: isPlayerTurn
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
          : null, // Se não for a vez do jogador, mantém o container vazio
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
