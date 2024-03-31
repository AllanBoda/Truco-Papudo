import 'Baralho.dart';
import 'Cartas.dart';


// Fluxo principal do jogo
 void main(){
  Baralho baralho = Baralho();
Cartas cartas =Cartas.vazio();


baralho.viraCarta();
print("VIRA");
 print("Naipe:${baralho.cartaVirada.naipe} - Valor:${baralho.cartaVirada.valor}");  
 print("");
baralho.MaoJogadorPosJogada();
cartas.ajustarForcaCartas(baralho.cartaVirada);
print("${cartas.naipes}");
print(cartas.valores);
}