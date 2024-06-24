/// A classe `CardModel` representa um modelo de carta no jogo de truco.
class CardModel {
  late String faceValue;
  late int value;
  late int naipe;
  late String faceUrl;

  /// Construtor padrão da classe `CardModel`.
  /// 
  /// @param faceValue O valor da face da carta (ex.: "A", "2", "K").
  /// @param value O valor numérico da carta.
  /// @param naipe O naipe da carta (ex.: 1 para ouros, 2 para espadas).
  /// @param faceUrl A URL da imagem da face da carta.
  CardModel({
    required this.faceValue,
    required this.value,
    required this.naipe,
    required this.faceUrl,
  });

  /// Construtor alternativo para a classe `CardModel`, que inicializa uma carta com valor e naipe, 
  /// mas sem definir faceValue e faceUrl.
  /// 
  /// @param value O valor numérico da carta.
  /// @param naipe O naipe da carta.
  CardModel.cards({
    required this.value,
    required this.naipe,
  })  : faceUrl = "",
        faceValue = "";

  /// Construtor vazio para a classe `CardModel`, utilizado para 
  /// inicializar uma carta sem valores definidos.
  CardModel.vazio();
}
