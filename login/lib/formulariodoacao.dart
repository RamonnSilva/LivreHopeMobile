import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// 'dart:io' removido pois não funciona no Flutter Web
import 'doacaosucesso.dart';

class DonationFormPage extends StatefulWidget {
  const DonationFormPage({super.key});

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  String nome = '';
  String titulo = '';
  String genero = '';
  String autor = '';
  String descricao = '';
  String email = ''; // novo campo email
  String? imagemBase64;

  XFile? pickedImage;

  final _formKey = GlobalKey<FormState>();

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImage = image;
      });

      final bytes = await image.readAsBytes();
      imagemBase64 = base64Encode(bytes);
    }
  }

  void enviarDados() async {
    final url = Uri.parse('http://localhost:8080/doacao');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': nome,
        'titulo': titulo,
        'genero': genero,
        'autor': autor,
        'descricao': descricao,
        'email': email,               // enviando o email
        'imagem': imagemBase64,       // base64 sem prefixo
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DonationSuccessDialog()),
      );
    } else {
      print('Erro ao enviar dados: ${response.statusCode}');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Doe um Livro"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9BD6F2), Color(0xFF2D42D9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 20, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Nome", style: TextStyle(fontSize: 16)),
                TextFormField(
                  onChanged: (value) => nome = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                  decoration: const InputDecoration(
                    hintText: 'Nome do doador',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Email", style: TextStyle(fontSize: 16)),  // novo campo email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    // Validação simples de email
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Seu email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Título do livro", style: TextStyle(fontSize: 16)),
                TextFormField(
                  onChanged: (value) => titulo = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                  decoration: const InputDecoration(
                    hintText: 'Título do livro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Gênero", style: TextStyle(fontSize: 16)),
                TextFormField(
                  onChanged: (value) => genero = value,
                  decoration: const InputDecoration(
                    hintText: 'Gênero do livro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Autor", style: TextStyle(fontSize: 16)),
                TextFormField(
                  onChanged: (value) => autor = value,
                  decoration: const InputDecoration(
                    hintText: 'Autor do livro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Descrição", style: TextStyle(fontSize: 16)),
                TextFormField(
                  onChanged: (value) => descricao = value,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Descrição do livro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                pickedImage == null
                    ? const Text('Nenhuma imagem selecionada')
                    : FutureBuilder(
                        future: pickedImage!.readAsBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData) {
                            return Image.memory(
                              snapshot.data!,
                              height: 200,
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Erro ao carregar imagem');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),

                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Selecionar imagem"),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      enviarDados();
                    }
                  },
                  child: const Text("Doar livro"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
