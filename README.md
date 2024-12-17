# Truco Papudo
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FAllanBoda%2FTruco-Papudo.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FAllanBoda%2FTruco-Papudo?ref=badge_shield)


## Documento Técnico do Projeto Truco Online

###  Visão Geral

#### Introdução ao Jogo de Truco
O truco é um jogo de cartas popular no Brasil, jogado por duas equipes de dois jogadores cada. O objetivo é acumular 12 pontos antes da equipe adversária. Este projeto visa desenvolver uma versão online do truco, utilizando a linguagem Dart e o framework Flutter, permitindo partidas em tempo real entre jogadores.

#### Objetivos do Projeto
- Desenvolver uma versão online do truco.
- Permitir partidas em tempo real entre jogadores.
- Criar uma experiência de usuário fluida e intuitiva.

#### Público-Alvo
- Entusiastas do truco.
- Jogadores casuais e competitivos.
- Usuários de plataformas web, mobile e desktop.

### Arquitetura do Sistema

#### Estrutura do Diagrama
- **Jogadores (Front-end)**:
  - Representação de jogadores interagindo com a aplicação Flutter.
- **Lógica do Jogo (Back-end)**:
  - Implementação da lógica do jogo em Dart dentro da aplicação Flutter.
- **Serviço de WebSocket**:
  - Gerenciamento da comunicação em tempo real entre os jogadores.


#### Componentes Principais

- **Front-end e Back-end**
  - **Tecnologia**: Flutter com Dart
  - **Descrição**: Interface do usuário e lógica do jogo integradas em uma única aplicação, rodando tanto no cliente quanto no servidor.

- **Comunicação em Tempo Real**
  - **Tecnologia**: WebSocket
  - **Descrição**: Para permitir a comunicação em tempo real entre os jogadores, utilizaremos WebSockets para troca de mensagens.

### Detalhes Técnicos

#### Tecnologias Utilizadas
- **Framework**: Flutter
- **Linguagem de Programação**: Dart
- **Comunicação em Tempo Real**: WebSocket

#### Estrutura do Código

```bash
/lib
  /ENUN
    - playerPosition.dart
  /model
    - CardModel.dart
    - CartasNaMesa.dart
    - DeckModel.dart
  /services
    - websocket_service.dart
    - cartasService.dart
    - definirCartasBaralho.dart
    - game.dart
  /screens
    - boardPage.dart
    - loginScreen.dart
    - registerPage.dart
  /screensService
    - boardService.dart
    - playHard.dart
    - trucoCard.dart
  main.dart
```

#### Descrição dos Arquivos e Diretórios
- **enum:** Define um conjunto de valores nomeados.
- **model:** Define as classes de dados.
- **service:** Serviços para comunicação com WebSockets e a lógica do jogo.
- **screens:** Contém as diferentes telas da aplicação.
- **screensService:** É responsável por conter serviços relacionados à lógica de funcionamento da tela (screens) da aplicação.

### Desenvolvimento

#### Configuração do Ambiente de Desenvolvimento
- **Pré-requisitos:** Flutter SDK, Dart SDK
- **Clonando o Repositório:** https://github.com/AllanBoda/Truco-Papudo

- **Instalando Dependências:**
```bash
sh
Copiar código
flutter pub get
```
**Rodando o Aplicativo:
```bash
sh
- **Copiar código**
```bash
flutter run
```
- **Estrutura de Pastas**
```bash
markdown
Copiar código
/lib
  /ENUN
  /model
  /services
  /screens
  /screensService
```
  
#### Convenções de Código
- **Estilo de Código:** Utilizar Dart Analysis para garantir boas práticas.
- **Commits:** Seguir o padrão de commits semânticos.

#### Implantação
#### Infraestrutura Necessária

- **Servidores:** Servidor com suporte a WebSocket para comunicação em tempo real.

- **Processo de Deploy**
- **Build do Aplicativo Flutter:**
```bash
sh
Copiar código
flutter build web
```
#### Deploy no Servidor:
- Ainda não temos.

#### Segurança
#### Medidas de Segurança Adotadas
- **HTTPS:**
- Todo o tráfego será criptografado.
- **Autenticação:**
- Métodos simples, como logins de convidado, para simplificar a experiência do usuário.

#### Manutenção e Suporte
- **Plano de Manutenção**
- **Atualizações:**
- Lançamento de atualizações a cada mês.
- **Backups:**
- Realização de backups semanais do código fonte.
- **Procedimentos de Suporte**
- **Canal de Suporte:**
- E-mail, chat ao vivo.
- **Tempo de Resposta:**
- Dentro de 24 horas.

#### Procedimentos de Deploy Detalhados
#### Configuração do Servidor

- **Instalar um Servidor HTTP:**
- Utilize um servidor HTTP como Nginx para servir os arquivos estáticos do aplicativo web.
- **Exemplo de configuração básica do Nginx para servir arquivos estáticos:**
```bash
nginx
Copiar código
server {
    listen 80;
    server_name exemplo.com www.exemplo.com;

    location / {
        root /caminho/para/build/web;
        index index.html;
    }
}
```
- **Configurar Suporte a WebSocket no Servidor:**
- Para suportar comunicação em tempo real entre os clientes e o servidor, configure o Nginx para proxy pass ao servidor WebSocket.
- **Exemplo de configuração para WebSocket no Nginx:**
```bash
nginx
Copiar código
location /websocket/ {
    proxy_pass http://localhost:3000;  # Substitua pela porta do servidor WebSocket
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_set_header Host $host;
}
```
- **Build e Deploy**
- **Build do Aplicativo Flutter:**
- **Execute o comando para gerar os arquivos de build do aplicativo web:**
```bash
sh
Copiar código
flutter build web
```
- Este comando compila e gera os arquivos estáticos do aplicativo na pasta build/web.
- **Deploy no Servidor:**
- **Transfira os arquivos de build gerados para o servidor utilizando SCP ou outro método de transferência seguro:**
- **Isso é apenas um exemplo**
```bash
sh
Copiar código
scp -r build/web/* user@server:/var/www/truco-online
```
- Isso copia todos os arquivos de build para o diretório de publicação no servidor.
**Configuração de Domínio e SSL**
**Configurar o Domínio para Apontar para o Servidor:**
- Configure os registros DNS do seu domínio para apontar para o endereço IP do servidor onde o aplicativo está hospedado.
**Configurar HTTPS Utilizando Let's Encrypt ou Outro Serviço de SSL:**
- Utilize Let's Encrypt ou outro serviço para configurar certificados SSL gratuitos e garantir que o tráfego entre os usuários e  - servidor seja criptografado.
- **Exemplo de configuração básica do Nginx para HTTPS com Let's Encrypt:**
```bash
nginx
Copiar código
server {
    listen 443 ssl;
    server_name exemplo.com www.exemplo.com;

    ssl_certificate /caminho/para/certificado/fullchain.pem;
    ssl_certificate_key /caminho/para/chave/privada.pem;

    location / {
        root /caminho/para/build/web;
        index index.html;
    }
}
```

#### Monitoramento e Manutenção
**Monitoramento:**
- Utilizar ferramentas como AWS CloudWatch ou Google Cloud Monitoring para monitorar a aplicação.
**Manutenção:**
- Agendar janelas de manutenção periódicas para atualizações e backups.

#### Planejamento de Escalabilidade
**Aumentar a Capacidade do Servidor Conforme a Base de Usuários Cresce**
- À medida que o número de jogadores e partidas simultâneas aumenta, é crucial dimensionar a capacidade do servidor para lidar com a carga adicional. Isso pode ser alcançado através de:
**Escalabilidade Vertical:**
- Upgrade dos recursos do servidor, como CPU e RAM, para suportar mais usuários e processamento de dados.
**Escalabilidade Horizontal:**
- Adição de mais instâncias de servidor conforme necessário, distribuindo a carga entre várias máquinas.
É importante monitorar regularmente a utilização dos recursos do servidor e planejar antecipadamente para escalonar vertical ou horizontalmente conforme necessário.
Utilizar Serviços de Balanceamento de Carga para Distribuir o Tráfego

**Para garantir alta disponibilidade e distribuição eficiente do tráfego entre os servidores, podemos implementar:**
**Balanceamento de Carga:**
- Utilização de serviços como AWS Elastic Load Balancing ou NGINX para distribuir o tráfego entre múltiplas instâncias do servidor.
**Algoritmos de Balanceamento:**
- Configurar algoritmos como Round Robin ou Least Connections para distribuir as requisições de forma equitativa.
Isso ajuda a prevenir sobrecargas em servidores individuais e melhora a capacidade de resposta da aplicação durante picos de tráfego.

-**Implementar Cache de Conteúdos Estáticos para Reduzir a Carga no Servidor
Para otimizar o desempenho e reduzir a carga nos servidores, podemos implementar estratégias de caching para conteúdos estáticos, como:**
-**Cache de Imagens e Recursos:**
- Utilização de CDNs (Content Delivery Networks) para armazenar e servir imagens, arquivos de áudio e outros recursos estáticos próximos aos usuários, reduzindo a latência.
- **Cache de Resultados de Consultas:**
- Utilização de memória cache (por exemplo, Redis) para armazenar resultados de consultas frequentes ao banco de dados, melhorando a velocidade de acesso e reduzindo a carga no banco de dados.
Ao implementar essas estratégias, a aplicação fica mais eficiente em termos de desempenho e escalabilidade, proporcionando uma experiência de usuário mais rápida e estável, mesmo com um aumento significativo na base de usuários.

#### Exemplo Prático
-**Sendo inicialmente o jogo suporta 1000 jogadores simultâneos. Conforme a base de usuários cresce e a demanda aumenta, podemos:**
-**Escalonar Verticalmente:**
- Aumentar a capacidade do servidor principal dobrando a capacidade de processamento e memória.
-**Escalonar Horizontalmente:**
- Implementar mais instâncias de servidor e configurar um balanceador de carga para distribuir uniformemente o tráfego entre essas instâncias.
- **Implementar Cache:**
- Utilizar um CDN para armazenar e servir imagens de cartas do jogo, reduzindo a carga no servidor principal e melhorando o tempo de resposta para os jogadores.

Essas práticas garantem que o jogo de truco online seja robusto, escalável e capaz de lidar com um crescimento orgânico na base de usuários, mantendo uma experiência de jogo fluida e estável.




## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FAllanBoda%2FTruco-Papudo.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FAllanBoda%2FTruco-Papudo?ref=badge_large)