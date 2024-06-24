import 'package:flutter/material.dart'; // Importação do pacote Flutter Material

/// Página de registro de usuário.
class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'), // Título da barra de aplicativo
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Preenchimento interno
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nome de Usuário', // Rótulo do campo de texto
              ),
            ),
            const SizedBox(height: 20.0), // Espaçamento entre campos
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha', // Rótulo do campo de senha
              ),
            ),
            const SizedBox(height: 20.0), // Espaçamento entre campos
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha', // Rótulo do campo de confirmação de senha
              ),
            ),
            const SizedBox(height: 20.0), // Espaçamento entre campos
            const TextField(
              decoration: InputDecoration(
                labelText: 'E-mail', // Rótulo do campo de e-mail
              ),
            ),
            const SizedBox(height: 20.0), // Espaçamento entre campos
            ElevatedButton(
              onPressed: () {
                // em desenvolvimento
              },
              child: const Text('Confirmar Cadastro'), // Texto do botão de cadastro
            ),
          ],
        ),
      ),
    );
  }
}
