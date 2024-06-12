class CardModel {
  late String faceValue;
  late int value;
  late int naipe;
  late String faceUrl;

  CardModel({
    required this.faceValue,
    required this.value,
    required this.naipe,
    required this.faceUrl,
  });

   CardModel.cards({
    required this.value,
    required this.naipe
  }): faceUrl = "" , faceValue = "";
  
  CardModel.vazio();
}

