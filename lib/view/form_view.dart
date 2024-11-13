import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integrade/provider/imgService.dart';
import 'package:integrade/provider/reqresService.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _descricaoController = TextEditingController();

  File? _foto1;
  File? _foto2;

  final picker = ImagePicker();
  final imgBBService = ImgBBService();
  final reqresService = ReqresService();

  Future<void> _selecionarImagem(int fotoNumero) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          if (fotoNumero == 1) {
            _foto1 = File(pickedFile.path);
          } else if (fotoNumero == 2) {
            _foto2 = File(pickedFile.path);
          }
        });
      } else {
        print("Nenhuma imagem selecionada.");
      }
    } catch (e) {
      print("Erro ao selecionar imagem: $e");
    }
  }

  Future<void> _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl1;
      String? imageUrl2;

      // Envia as imagens para o ImgBB
      if (_foto1 != null) {
        imageUrl1 = await imgBBService.uploadImage(_foto1!);
        print("URL Foto 1: $imageUrl1");
      }
      if (_foto2 != null) {
        imageUrl2 = await imgBBService.uploadImage(_foto2!);
        print("URL Foto 2: $imageUrl2");
      }

      // Envia os dados do formulário para o Reqres (sem as URLs das fotos)
      await reqresService.sendUserData(
        _nomeController.text,
        _emailController.text,
        _descricaoController.text,
      );

      print("Nome: ${_nomeController.text}");
      print("Email: ${_emailController.text}");
      print("Descrição: ${_descricaoController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _selecionarImagem(1),
                        child: const Text("Selecionar Foto 1"),
                      ),
                      _foto1 != null
                          ? Image.file(_foto1!, height: 100, width: 100)
                          : Container(),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _selecionarImagem(2),
                        child: const Text("Selecionar Foto 2"),
                      ),
                      _foto2 != null
                          ? Image.file(_foto2!, height: 100, width: 100)
                          : Container(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enviarFormulario,
                child: const Text("Enviar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
