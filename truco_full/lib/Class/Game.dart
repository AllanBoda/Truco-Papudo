import 'package:truco_full/CardModel.dart';
import 'package:truco_full/Class/CartaNaMesa.dart';
import 'package:truco_full/Model/PlayerModel.dart';
import 'package:truco_full/Service/CartasServise.dart';
import 'Baralho.dart';

class Game {
  Baralho baralho = Baralho();
  late PlayerModel jogadorAtual ;
  PlayerModel? jogadorQueTrucou;
  PlayerModel? jogadorQueAceitou;
  PlayerModel? jogadorQueAumentouTruco;
  int? valorTruco = 3;
  int? valorTrucoAtual =3;
  int equipe1 = 0;
  int equipe2 = 0;
  int rodada = 0;
  bool trucoAceito = false;
  bool vencedorRodada = false;
  CardModel cartas = CardModel.vazio();
  CardModel? manilha = CardModel.vazio();
 PlayerModel? jogadorUltimoVencedor;
  bool? trucoPedindo;
  List<CardModel> listForcaCartas = [];
  CartasServise cartasServise = CartasServise();

  void iniciarJogo() {
    baralho.inicializar();
    definirManilha();
    definirJogadorAtual();
  }

  void definirJogadorAtual() {
    jogadorAtual = jogadorUltimoVencedor ?? baralho.listaJogador.first;
  }

  void escolherCartaDaJogada(int indiceCarta, PlayerModel jogador, {bool pediuTruco = false}) {
    if (indiceCarta >= 0 && indiceCarta < jogador.maoJogador.length) {
      CardModel carta = jogador.maoJogador[indiceCarta];
      baralho.cartasNaMesa.add(CartaNaMesa(carta, jogador, trucoPediu: pediuTruco));
      jogador.maoJogador.remove(carta);
    }
  }

  void iniciarRodada() {
    jogadorAtual = proximoJogador()!;
    listForcaCartas = cartasServise.ajustarForcaCartas(baralho.cartaVirada);
    definirGanhadorRodada(listForcaCartas, baralho.cartasNaMesa, trucoAceito);     
  }

  void definirGanhadorRodada(List<CardModel> forcaCartas, List<CartaNaMesa> cartasNaMesa, bool trucou) {
  int posicaoCartaPrimeiroJogador = forcaCartas.length;
  int posicaoCartaSegundoJogador = forcaCartas.length;
  int primeiroJogador = -1;
  int segundoJogador = -1;

  // Determinar quem é o primeiro e o segundo jogador
  if (cartasNaMesa[0].jogador.equipe == 1) {
    primeiroJogador = 1;
    segundoJogador = 2;
  } else {
    primeiroJogador = 2;
    segundoJogador = 1;
  }

  // Laço para determinar a posição das cartas jogadas por cada jogador
  for (int i = 0; i < cartasNaMesa.length; i++) {
    CartaNaMesa cartaNaMesa = cartasNaMesa[i];
    CardModel cartaJogada = cartaNaMesa.carta!;

    int posicaoCarta = forcaCartas.indexWhere((carta) => carta.value == cartaJogada.value);

    if (cartaNaMesa.jogador.id == primeiroJogador) {
      posicaoCartaPrimeiroJogador = posicaoCarta;
    } else if (cartaNaMesa.jogador.id == segundoJogador) {
      posicaoCartaSegundoJogador = posicaoCarta;
    }
  }

  // Determinar o vencedor da rodada
  int jogadorVencedor = -1;
  if(posicaoCartaPrimeiroJogador == posicaoCartaSegundoJogador){
    cartasNaMesa.clear();
    rodada ++;
    return;// Empate
  }
  if (posicaoCartaPrimeiroJogador < posicaoCartaSegundoJogador) {
    jogadorVencedor = primeiroJogador;
  } else {
    jogadorVencedor = segundoJogador;
  }

  // Incrementar pontos da equipe vencedora
  if (jogadorVencedor == 1) {
    equipe1++;
  } else if (jogadorVencedor == 2) {
    equipe2++;
  }

  if (trucou) { 
    if(equipe1 == 2 || equipe2 == 2){
    // Atualiza apenas as informações relacionadas ao truco
     for (PlayerModel jogador in baralho.listaJogador) {
        if (jogador.equipe == jogadorVencedor) {
          jogador.pontos += valorTrucoAtual!;
           // Reinicia o truco para a próxima rodada
          valorTruco = 3;
          trucoAceito = false;
          }
      }
      // Define que houve um vencedor na rodada
      defenirCampeao(jogadorVencedor);
  }
    }
    if(!trucou && equipe1 == 2 || equipe2 == 2 ){ 
       // Adiciona 1 ponto aos jogadores da equipe vencedora da mão
      for (PlayerModel jogador in baralho.listaJogador) {
        if (jogador.equipe == jogadorVencedor) {
            jogador.pontos += 1;
          }
        }
        // Define que houve um vencedor na rodada
        defenirCampeao(jogadorVencedor);
     }
     if (vencedorRodada) {
        baralho.cartasNaMesa.clear();
        iniciarJogo();
        rodada = 0;
        vencedorRodada = false;
      }
      else{
        rodada ++;
        baralho.cartasNaMesa.clear();
        
      }
  }
  void defenirCampeao(int jogadorVencedor){
     // Define que houve um vencedor na rodada e resetar as variaveis
        vencedorRodada = true;
        equipe1 = 0;
        equipe2 = 0;
        jogadorAtual = baralho.listaJogador.firstWhere((jogador) => jogador.equipe == jogadorVencedor);
        jogadorUltimoVencedor = jogadorAtual;
        jogadorQueTrucou = null;
        jogadorQueAceitou = null;
        jogadorQueAumentouTruco = null;
        valorTruco = 3;
        valorTrucoAtual = null;
        trucoAceito = false;
        trucoPedindo = false;
        rodada = 0;
  }
  
 
  void definirManilha() {
    var cartaVirada = baralho.cartaVirada;
    var cartasServise = CartasServise();
    var manilha = cartasServise.ajustarForcaCartas(cartaVirada).first;
    this.manilha = manilha;
  }

  bool trucar(PlayerModel jogador, int valorTruco) {
    if (jogadorQueTrucou == null) {
      jogadorQueTrucou = jogador;
      this.valorTruco = valorTruco;
      valorTrucoAtual = valorTruco;
      trucoPedindo = true;
      jogadorAtual = proximoJogador()!;
      return true;
    } else {
      print("Já há uma negociação de truco em andamento!");
      return false;
    }
  }

  void aumentarTruco(PlayerModel jogador) {
    if (jogadorQueTrucou != null && valorTrucoAtual! < 12) {
      jogadorQueAumentouTruco = jogador;
      valorTrucoAtual = valorTruco! * 2;
      valorTruco = valorTrucoAtual;
      jogadorAtual = proximoJogador()!;
    } 
  }

  void aceitarTruco(PlayerModel jogador) {
    if (jogadorQueTrucou != null) {
      jogadorQueAceitou = jogador;
      trucoAceito = true;
      jogadorAtual = proximoJogador()!;
    }
  }

  void desistirTruco(PlayerModel jogador){
    if (jogadorQueTrucou != null) {
      jogadorQueTrucou = null;
      jogadorQueAceitou = null;
      jogadorQueAumentouTruco = null;
      valorTruco = null;
      valorTrucoAtual = null;
      trucoAceito = false;
      trucoPedindo = false;
      print("${jogador.nome} desistiu do truco!");
      jogadorAtual = proximoJogador()!;
    } 
  }

  PlayerModel? proximoJogador(){
      int indexAtual = baralho.listaJogador.indexOf(jogadorAtual);
      if (indexAtual < baralho.listaJogador.length - 1) {
        return baralho.listaJogador[indexAtual + 1];
      } else {
        return baralho.listaJogador.first;
      }
    }
    

  void reniciarVariaveisTruco() {

      jogadorQueTrucou = null;
      jogadorQueAceitou = null;
      valorTruco = null;
      valorTrucoAtual = null;
      trucoAceito = false;
      trucoPedindo = false;
      jogadorAtual = proximoJogador()!;
  }

  void jogarNovamente() {
    iniciarJogo();
  }

}
