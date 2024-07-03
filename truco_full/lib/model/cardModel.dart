/// A classe `CardModel` representa um modelo de carta no jogo de truco.
class CardModel {
  late String faceValue;
  late int value;
  late int naipe;
  late String faceUrl;
  late int cardOwner;

  /// Construtor padrão da classe `CardModel`.
  CardModel({
    required this.faceValue,
    required this.value,
    required this.naipe,
    required this.faceUrl,
    required this.cardOwner,
  });

  /// Construtor alternativo para a classe `CardModel`, que inicializa uma carta com valor e naipe, 
  /// mas sem definir faceValue e faceUrl.
  CardModel.cards({
    required this.value,
    required this.naipe,
  })  : faceUrl = "",
        faceValue = "";


  /// Construtor vazio para a classe `CardModel`, utilizado para 
  /// inicializar uma carta sem valores definidos.
  CardModel.vazio() : value = 0, naipe = 0, faceUrl = "", faceValue = "", cardOwner = 0;

  /// Método para retornar uma string representativa da instância
  @override
  String toString() {
    return 'valor: $value - naipe: $naipe';
  }
}
