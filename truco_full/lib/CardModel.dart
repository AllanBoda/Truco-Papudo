class CardModel {
  String faceValue;
  int value;
  int naipe;
  String faceUrl;

 // Construtor vazio
  CardModel.vazio()
      : faceValue = '',
        value = 0,
        naipe = 0,
        faceUrl = '';
  CardModel.cards({
    required this.value,
    required this.naipe
  }): faceUrl =  "", faceValue = "";


  CardModel({
    required this.faceValue,
    required this.value,
    required this.naipe,
    required this.faceUrl,
  });

   @override
  String toString() {
    return 'Valor $value, Naipe: $naipe';
  }

  
}

