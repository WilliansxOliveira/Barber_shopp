import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/views/home/home_page.dart';
import 'package:myapp/views/register/register_page.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _navigateToHome(context, 'Bem-vindo de volta!');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          _showErrorSnackbar(context, 'Senha incorreta.');
        } else {
          _showErrorSnackbar(context, e.message ?? 'Erro ao fazer login');
        }
      }
    }
  }

  void _navigateToHome(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget loginForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B1F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF26272B),
          width: 2,
        ),
      ),
      width: double.infinity,
      height: 350,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Login na sua Conta",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                height: 70,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail:',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o e-mail';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                height: 70,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                color: const Color.fromRGBO(99, 47, 47, 1),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => _login(context),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  "Não tem uma conta? Registre-se",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF141518),
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(top: 20.0),
          child: Image.asset(
            'assets/images/Tittle.png',
            height: 90,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF141518),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/Barber-Logo.png',
                height: 200,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: loginForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}