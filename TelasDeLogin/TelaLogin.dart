import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppController(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Controlador principal do app
class AppController extends StatefulWidget {
  createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  bool isLoggedIn = false;
  String userName = '';
  String userEmail = '';

  // Função para fazer login
  void login(String email, String name) {
    setState(() {
      isLoggedIn = true;
      userEmail = email;
      userName = name;
    });
  }

  // Função para fazer logout
  void logout() {
    setState(() {
      isLoggedIn = false;
      userName = '';
      userEmail = '';
    });
  }

  Widget build(BuildContext context) {
    // Se estiver logado, mostra página inicial, senão mostra login
    return isLoggedIn 
      ? HomePage(
          userName: userName,
          userEmail: userEmail,
          onLogout: logout,
        )
      : LoginPage(onLogin: login);
  }
}

class LoginPage extends StatefulWidget {
  final Function(String email, String name) onLogin;
  
  LoginPage({required this.onLogin});
  
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool hidePassword = true;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 20),
              
              // Título
              Text(
                isLogin ? 'Login' : 'Cadastro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              SizedBox(height: 30),
              
              // Campo Nome (só no cadastro)
              if (!isLogin)
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              
              // Campo Email
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              // Campo Senha
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              // Botão Principal
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLogin ? Colors.blue : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isLogin ? 'ENTRAR' : 'CRIAR CONTA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Botão Alternar
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    clearFields();
                  });
                },
                child: Text(
                  isLogin 
                    ? 'Não tem conta? Cadastre-se aqui'
                    : 'Já tem conta? Faça login aqui',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSubmit() {
    if (isLogin) {
      // Simular login e chamar função de callback
      String name = extractNameFromEmail(emailController.text);
      widget.onLogin(emailController.text, name);
    } else {
      // Mostrar sucesso do cadastro e voltar para login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Conta criada!'),
          content: Text('Sua conta foi criada com sucesso!\nFaça login para continuar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLogin = true;
                  // Manter email para facilitar o login
                  String email = emailController.text;
                  clearFields();
                  emailController.text = email;
                });
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
  
  String extractNameFromEmail(String email) {
    if (email.isEmpty) return 'Usuário';
    return email.split('@')[0].replaceAll('.', ' ').toUpperCase();
  }
}

// PÁGINA INICIAL
class HomePage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;
  
  HomePage({
    required this.userName, 
    required this.userEmail, 
    required this.onLogout
  });

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Página Inicial'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove botão voltar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com saudação
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, $userName! 👋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userEmail,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Cards de funcionalidades
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: buildFeatureCard(
                          'Perfil',
                          Icons.person,
                          Colors.purple,
                          'Gerenciar conta',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: buildFeatureCard(
                          'Configurações',
                          Icons.settings,
                          Colors.orange,
                          'Personalizar app',
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: buildFeatureCard(
                          'Notificações',
                          Icons.notifications,
                          Colors.red,
                          'Ver alertas',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: buildFeatureCard(
                          'Relatórios',
                          Icons.analytics,
                          Colors.green,
                          'Ver estatísticas',
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Card de status
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status da Conta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Conta ativa e funcionando',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Último login: Agora mesmo',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Botão de teste para voltar ao login
                  Container(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => showLogoutDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 18),
                          SizedBox(width: 8),
                          Text('Sair da Conta'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeatureCard(String title, IconData icon, Color color, String subtitle) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sair da conta'),
        content: Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onLogout(); // Chama função de logout
            },
            child: Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}