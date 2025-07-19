import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pix.dart';
import 'boleto.dart';
import 'adicionarcartao.dart';

class ContributionScreen extends StatefulWidget {
  const ContributionScreen({super.key});

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  final TextEditingController _valorController = TextEditingController();

  Future<void> enviarContribuicao(String metodo) async {
    final valorTexto = _valorController.text.replaceAll('R\$', '').replaceAll(',', '.').trim();
    final double? valor = double.tryParse(valorTexto);

    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite um valor válido")),
      );
      return;
    }

    final url = Uri.parse('http://localhost:8080/contribuicao');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'valor': valor,
        'metodoPagamento': metodo,
      }),
    );

    if (response.statusCode == 201) {
      print("Contribuição enviada: ${response.body}");

      // Navegar para a tela correta
      Widget destino;
      if (metodo == 'pix') {
        destino = const PixScreen();
      } else if (metodo == 'boleto') {
        destino = const BoletoScreen();
      } else {
        destino = const AdicionarCartaoScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destino),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar contribuição")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Qual o valor da contribuição?",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _valorController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "R\$00,00",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Qual a forma de contribuir?",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => enviarContribuicao('pix'),
                    icon: const Icon(Icons.pix, color: Colors.green),
                    label: const Text("Pagar com Pix"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => enviarContribuicao('boleto'),
                    icon: const Icon(Icons.receipt_long),
                    label: const Text("Pagar com Boleto"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => enviarContribuicao('cartao'),
                    icon: const Icon(Icons.credit_card),
                    label: const Text("Adicionar Cartão"),
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
