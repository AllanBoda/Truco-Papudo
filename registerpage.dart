import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nome de Usuário',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Senha',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // em desenvolvimento
              },
              child: const Text('Confirmar Cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
