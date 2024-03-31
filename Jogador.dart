import 'Cartas.dart';

class Jogador {
  late String nome;
  late int numero;
  late int equipe;
 
  Jogador.Vazio();
  Jogador(this.nome, this.numero, this.equipe);

List<Cartas> cartaRemovidaMao = [];


//Método para inserir os 4 jogadores no jogo
List<Jogador> adicionarListaJogador()
{
Jogador jogador1= Jogador("Jessica", 1, 1);
Jogador jogador2 = Jogador("Emily", 2, 1);
Jogador jogador3 = Jogador("Natan", 3, 2);
Jogador jogador4 = Jogador("Gabriel", 4, 2);
  List<Jogador> listaJogadores = [jogador1,jogador2,jogador3,jogador4];
  return listaJogadores;
}


   

  @override
  String toString(){
    return "$nome-$numero,Equipe:$equipe";
  }
}
