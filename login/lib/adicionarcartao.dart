import 'package:flutter/material.dart';
import 'confirmacaopagamento.dart';

class AdicionarCartaoScreen extends StatefulWidget {
  const AdicionarCartaoScreen({super.key});

  @override
  State<AdicionarCartaoScreen> createState() => _AdicionarCartaoScreenState();
}

class _AdicionarCartaoScreenState extends State<AdicionarCartaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();
  final _cvcController = TextEditingController();
  final _dataController = TextEditingController();
  final _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Adicionar Cartão"),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/cartao.png',
                    width: 200,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text("Erro ao carregar imagem", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  _textField(
                    controller: _numeroController,
                    label: "Número do cartão",
                    hint: "Ex: 1234 1234 1234 1234",
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Digite o número do cartão";
                      if (value.replaceAll(' ', '').length != 16) return "Número inválido";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          controller: _cvcController,
                          label: "CVC",
                          hint: "Ex: 123",
                          validator: (value) {
                            if (value == null || value.isEmpty) return "CVC obrigatório";
                            if (value.length != 3) return "CVC inválido";
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _textField(
                          controller: _dataController,
                          label: "Data expirada",
                          hint: "Ex: 12/34",
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Digite a validade";
                            final regex = RegExp(r"^(0[1-9]|1[0-2])\/\d{2}$");
                            if (!regex.hasMatch(value)) return "Formato inválido (MM/AA)";
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    controller: _nomeController,
                    label: "Nome do cartão",
                    hint: "Ex: João da Silva",
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Digite o nome do cartão";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ConfirmacaoPagamentoScreen()),
                        );
                      }
                    },
                    child: const Text("Concluir"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
