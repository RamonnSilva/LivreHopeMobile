import 'package:flutter/material.dart';

class ConfirmacaoPagamentoScreen extends StatelessWidget {
  const ConfirmacaoPagamentoScreen({super.key});

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Pagamento efetuado", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 20),
                Text("Obrigado!", style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(height: 20),
                Icon(Icons.volunteer_activism, size: 80, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  "Sua doação ajuda a transformar vidas.\nAgradecemos profundamente!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
