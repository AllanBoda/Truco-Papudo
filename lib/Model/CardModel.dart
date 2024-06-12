class cardModel {
 late String faceValue;
 late int value;
 late int naipe;
 late String faceUrl;

  cardModel({
    required this.faceValue,
    required this.value,
    required this.naipe,
    required this.faceUrl,
  });

  cardModel.vazio();

  cardModel.card({
  required this.value,
  required  this.naipe
  }): faceUrl = "", faceValue = "";
}
