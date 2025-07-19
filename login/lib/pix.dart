import 'package:flutter/material.dart';
import 'confirmacaopagamento.dart';

class PixScreen extends StatelessWidget {
  const PixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Pagamento via Pix"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/pix_logo.png', width: 120),
                  const SizedBox(height: 20),
                  const Text(
                    "Pagar com Pix é fácil e rápido!",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/qr_pix.png', width: 200),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.copy),
                    label: const Text("Copiar código Pix"),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Código válido por 1 dia",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "1. Acesse seu app do banco\n2. Vá até a área Pix\n3. Escaneie o QR Code ou cole o código",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ConfirmacaoPagamentoScreen(),
                        ),
                      );
                    },
                    child: const Text("Já paguei"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

