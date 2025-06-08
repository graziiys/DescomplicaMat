import 'package:flutter/material.dart';
import 'dart:async';
import 'package:collection/collection.dart'; // Para groupBy

void main() {
  runApp(const MyApp());
}

// --- Modelos de Dados Simplificados (Substituir por um backend real) ---
class User {
  String id;
  String name;
  String email;
  String password; // Em um app real, não armazenar senha em texto puro
  String schoolYear;
  bool isAdmin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.schoolYear,
    this.isAdmin = false,
  });

  // Método para converter para JSON (para simulação de armazenamento)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'schoolYear': schoolYear,
        'isAdmin': isAdmin,
      };

  // Método para criar de JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        schoolYear: json['schoolYear'],
        isAdmin: json['isAdmin'] ?? false,
      );
}

class Challenge {
  String id;
  String title;
  String description;
  String category;
  List<String> questions; // Simplificado: lista de perguntas
  List<User> participants; // Usuários que "fizeram" o desafio

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.questions = const [],
    this.participants = const [],
  });

  // Método para converter para JSON (para simulação de armazenamento)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'questions': questions,
        'participants': participants.map((p) => p.toJson()).toList(),
      };

  // Método para criar de JSON
  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        category: json['category'],
        questions: List<String>.from(json['questions'] ?? []),
        participants: (json['participants'] as List<dynamic>?)
                ?.map((p) => User.fromJson(p as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

// --- Simulação de Banco de Dados em Memória ---
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  AppDatabase._internal();

  final List<User> _users = [
    User(
      id: 'user1',
      name: 'João Silva',
      email: 'joao@example.com',
      password: '123',
      schoolYear: '8º Ano',
    ),
    User(
      id: 'user2',
      name: 'Maria Souza',
      email: 'maria@example.com',
      password: '123',
      schoolYear: '1º Ano EM',
    ),
    // Usuário administrador
    User(
      id: 'admin1',
      name: 'Admin',
      email: 'admin@descomplicamat.com',
      password: 'admin',
      schoolYear: 'Ensino Superior',
      isAdmin: true,
    ),
  ];

  final List<Challenge> _challenges = [
    Challenge(
      id: 'ch1',
      title: 'Álgebra Básica',
      description: 'Introdução à álgebra com equações simples.',
      category: 'Álgebra',
      questions: ['2x + 5 = 15', '3y - 7 = 8'],
      participants: [],
    ),
    Challenge(
      id: 'ch2',
      title: 'Geometria Plana',
      description: 'Cálculo de áreas e perímetros.',
      category: 'Geometria',
      questions: ['Área de um quadrado', 'Perímetro de um círculo'],
      participants: [],
    ),
    Challenge(
      id: 'ch3',
      title: 'Raciocínio Lógico',
      description: 'Desafios para testar sua lógica.',
      category: 'Lógica',
      questions: ['Sequência de números', 'Charadas lógicas'],
      participants: [],
    ),
  ];

  List<User> get users => List.unmodifiable(_users);
  List<Challenge> get challenges => List.unmodifiable(_challenges);

  void addUser(User user) {
    _users.add(user);
  }

  void removeUser(String userId) {
    _users.removeWhere((user) => user.id == userId);
  }

  void addChallenge(Challenge challenge) {
    _challenges.add(challenge);
  }

  void updateChallenge(Challenge updatedChallenge) {
    int index = _challenges.indexWhere((c) => c.id == updatedChallenge.id);
    if (index != -1) {
      _challenges[index] = updatedChallenge;
    }
  }

  void deleteChallenge(String challengeId) {
    _challenges.removeWhere((challenge) => challenge.id == challengeId);
  }

  void addParticipantToChallenge(String challengeId, User user) {
    final challenge =
        _challenges.firstWhereOrNull((c) => c.id == challengeId);
    if (challenge != null &&
        !challenge.participants.any((p) => p.id == user.id)) {
      challenge.participants.add(user);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DescomplicaMat',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---
// Tela de Splash com animação
// ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeIn),
    );

    _controller!.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation!.value,
              child: FadeTransition(
                opacity: _fadeAnimation!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.calculate,
                        size: 80,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'DescomplicaMat',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Aprendendo matemática de forma divertida!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontFamily: 'Open Sans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---
// Tela de Autenticação (Login e Cadastro)
// ---
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Controladores para Login
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Controladores para Cadastro
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();

  bool _obscurePasswordLogin = true;
  bool _obscurePasswordRegister = true;
  bool _obscureConfirmPasswordRegister = true;

  bool _isLoadingLogin = false;
  bool _isLoadingRegister = false;

  final List<String> schoolYears = const [
    '1º Ano',
    '2º Ano',
    '3º Ano',
    '4º Ano',
    '5º Ano',
    '6º Ano',
    '7º Ano',
    '8º Ano',
    '9º Ano',
    '1º Ano EM',
    '2º Ano EM',
    '3º Ano EM',
    'Ensino Superior',
    'Outros'
  ];
  String? selectedSchoolYear;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.calculate,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DescomplicaMat',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Faça login ou crie sua conta para começar!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFF2E7D32),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                tabs: const [
                  Tab(text: 'Login'),
                  Tab(text: 'Criar Conta'),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLoginTab(),
                  _buildRegisterTab(),
                ],
              ),
            ),

            // Botão "Entrar como Administrador"
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextButton(
                onPressed: () {
                  _showAdminLoginDialog(context);
                },
                child: const Text(
                  'Entrar como Administrador',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),

            Text(
              'Fazer Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Email Field
            TextFormField(
              controller: _loginEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon:
                    Icon(Icons.email_outlined, color: Color(0xFF2E7D32)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Por favor, insira um email válido';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password Field
            TextFormField(
              controller: _loginPasswordController,
              obscureText: _obscurePasswordLogin,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon:
                    const Icon(Icons.lock_outlined, color: Color(0xFF2E7D32)),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePasswordLogin ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePasswordLogin = !_obscurePasswordLogin;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua senha';
                }
                return null;
              },
            ),

            const SizedBox(height: 8),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento')),
                  );
                },
                child: const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Login Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoadingLogin ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: _isLoadingLogin
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),

            Text(
              'Criar Uma Conta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Name Field
            TextFormField(
              controller: _registerNameController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon:
                    Icon(Icons.person_outlined, color: Color(0xFF2E7D32)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu nome';
                }
                if (value.length < 2) {
                  return 'Nome deve ter pelo menos 2 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email Field
            TextFormField(
              controller: _registerEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon:
                    Icon(Icons.email_outlined, color: Color(0xFF2E7D32)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Por favor, insira um email válido';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // School Year Dropdown
            DropdownButtonFormField<String>(
              value: selectedSchoolYear,
              decoration: const InputDecoration(
                labelText: 'Ano de Escolaridade',
                prefixIcon:
                    Icon(Icons.school_outlined, color: Color(0xFF2E7D32)),
              ),
              items: schoolYears.map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSchoolYear = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecione seu ano de escolaridade';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password Field
            TextFormField(
              controller: _registerPasswordController,
              obscureText: _obscurePasswordRegister,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon:
                    const Icon(Icons.lock_outlined, color: Color(0xFF2E7D32)),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePasswordRegister ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePasswordRegister = !_obscurePasswordRegister;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Confirm Password Field
            TextFormField(
              controller: _registerConfirmPasswordController,
              obscureText: _obscureConfirmPasswordRegister,
              decoration: InputDecoration(
                labelText: 'Confirmar senha',
                prefixIcon:
                    const Icon(Icons.lock_outlined, color: Color(0xFF2E7D32)),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureConfirmPasswordRegister ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPasswordRegister =
                          !_obscureConfirmPasswordRegister;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, confirme sua senha';
                }
                if (value != _registerPasswordController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Register Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoadingRegister ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                ),
                child: _isLoadingRegister
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Criar Conta',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoadingLogin = true;
      });

      // Simular delay de requisição
      await Future.delayed(const Duration(seconds: 1));

      // Verificar se o usuário existe na nossa "base de dados"
      final user = AppDatabase().users.firstWhereOrNull(
            (u) =>
                u.email == _loginEmailController.text &&
                u.password == _loginPasswordController.text,
          );

      if (mounted) {
        setState(() {
          _isLoadingLogin = false;
        });

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login realizado com sucesso!'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );

          // Navegar para a página inicial
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                userName: user.name,
                userLevel: user.schoolYear,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email ou senha inválidos.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _handleRegister() async {
    if (_registerFormKey.currentState!.validate()) {
      setState(() {
        _isLoadingRegister = true;
      });

      // Simular delay de requisição
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoadingRegister = false;
        });

        // Simular criação de ID único para o novo usuário
        final newUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _registerNameController.text,
          email: _registerEmailController.text,
          password: _registerPasswordController.text, // Em um app real, hash a senha
          schoolYear: selectedSchoolYear!,
          isAdmin: false, // Novo usuário não é admin por padrão
        );

        // Verificar se já existe um usuário com o mesmo email
        if (AppDatabase().users.any((u) => u.email == newUser.email)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Este email já está em uso.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        AppDatabase().addUser(newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );

        // Navegar para a página inicial
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: newUser.name,
              userLevel: newUser.schoolYear,
            ),
          ),
        );
      }
    }
  }

  void _showAdminLoginDialog(BuildContext context) {
    final TextEditingController adminEmailController = TextEditingController();
    final TextEditingController adminPasswordController =
        TextEditingController();
    bool _obscureAdminPassword = true;

    final TextEditingController newAdminNameController = TextEditingController();
    final TextEditingController newAdminEmailController = TextEditingController();
    final TextEditingController newAdminPasswordController = TextEditingController();
    final TextEditingController newAdminConfirmPasswordController = TextEditingController();
    bool _obscureNewAdminPassword = true;
    bool _obscureNewAdminConfirmPassword = true;

    bool _isLoginMode = true; // Controla se é modo de login ou cadastro de admin

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(_isLoginMode ? 'Login de Administrador' : 'Cadastrar Novo Administrador'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoginMode) ...[
                      TextField(
                        controller: adminEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Email do Administrador',
                          prefixIcon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: adminPasswordController,
                        obscureText: _obscureAdminPassword,
                        decoration: InputDecoration(
                          labelText: 'Senha do Administrador',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureAdminPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureAdminPassword = !_obscureAdminPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      TextField(
                        controller: newAdminNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Administrador',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: newAdminEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Email do Administrador',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: newAdminPasswordController,
                        obscureText: _obscureNewAdminPassword,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureNewAdminPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureNewAdminPassword = !_obscureNewAdminPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: newAdminConfirmPasswordController,
                        obscureText: _obscureNewAdminConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureNewAdminConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureNewAdminConfirmPassword = !_obscureNewAdminConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                if (_isLoginMode)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginMode = false;
                      });
                    },
                    child: const Text('Cadastrar Novo Admin'),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (_isLoginMode) {
                      // Lógica de Login de Admin
                      if (adminEmailController.text == 'admin@descomplicamat.com' &&
                          adminPasswordController.text == 'admin') {
                        Navigator.of(dialogContext).pop(); // Fecha o dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login de administrador realizado!'),
                            backgroundColor: Color(0xFF2E7D32),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminPanelScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email ou senha de administrador inválidos.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      // Lógica de Cadastro de Admin
                      if (newAdminNameController.text.isEmpty ||
                          newAdminEmailController.text.isEmpty ||
                          newAdminPasswordController.text.isEmpty ||
                          newAdminConfirmPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, preencha todos os campos.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (newAdminPasswordController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('A senha deve ter pelo menos 6 caracteres.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (newAdminPasswordController.text !=
                          newAdminConfirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('As senhas não coincidem.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(newAdminEmailController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, insira um email válido.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      // Verificar se o email já existe
                      if (AppDatabase().users.any((u) => u.email == newAdminEmailController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Este email já está cadastrado.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }


                      final newAdmin = User(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: newAdminNameController.text,
                        email: newAdminEmailController.text,
                        password: newAdminPasswordController.text, // Em um app real, hash a senha
                        schoolYear: 'Ensino Superior', // Admins geralmente não têm ano de escolaridade
                        isAdmin: true,
                      );

                      AppDatabase().addUser(newAdmin);

                      Navigator.of(dialogContext).pop(); // Fecha o dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Novo administrador cadastrado com sucesso!'),
                          backgroundColor: Color(0xFF2E7D32),
                        ),
                      );
                      // Você pode optar por ir para o painel do admin ou de volta para a tela de login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPanelScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(_isLoginMode ? 'Entrar' : 'Cadastrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ---
// Tela Inicial do Usuário (HomePage) - Mockup simples
// ---
class HomePage extends StatelessWidget {
  final String userName;
  final String userLevel;

  const HomePage({super.key, required this.userName, required this.userLevel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DescomplicaMat - Desafios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo(a), $userName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nível: $userLevel',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Desafios Disponíveis:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: AppDatabase().challenges.length,
              itemBuilder: (context, index) {
                final challenge = AppDatabase().challenges[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        challenge.category[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      challenge.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      '${challenge.description}\nCategoria: ${challenge.category}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Iniciando desafio: ${challenge.title} (Funcionalidade em desenvolvimento)')),
                      );
                      // Implementar navegação para a tela do desafio real
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---
// Painel de Administração (AdminPanelScreen) - Mockup simples
// ---
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gerenciar Desafios',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: AppDatabase().challenges.length,
                itemBuilder: (context, index) {
                  final challenge = AppDatabase().challenges[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            challenge.description,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Categoria: ${challenge.category}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue),
                                onPressed: () {
                                  _showEditChallengeDialog(context, challenge);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  _showDeleteChallengeDialog(
                                      context, challenge);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddChallengeDialog(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Novo Desafio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Usuários Cadastrados',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: AppDatabase().users.length,
                itemBuilder: (context, index) {
                  final user = AppDatabase().users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Email: ${user.email}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Ano: ${user.schoolYear}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Admin: ${user.isAdmin ? 'Sim' : 'Não'}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddChallengeDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController questionsController = TextEditingController(); // Para perguntas

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar Novo Desafio'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
                TextField(
                  controller: questionsController,
                  decoration: const InputDecoration(
                      labelText: 'Perguntas (separadas por ;)'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    categoryController.text.isNotEmpty) {
                  final newChallenge = Challenge(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    description: descriptionController.text,
                    category: categoryController.text,
                    questions: questionsController.text.split(';').map((e) => e.trim()).toList(),
                  );
                  AppDatabase().addChallenge(newChallenge);
                  setState(() {}); // Atualiza a lista de desafios na tela
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Desafio adicionado com sucesso!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, preencha todos os campos.')),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditChallengeDialog(BuildContext context, Challenge challenge) {
    final TextEditingController titleController =
        TextEditingController(text: challenge.title);
    final TextEditingController descriptionController =
        TextEditingController(text: challenge.description);
    final TextEditingController categoryController =
        TextEditingController(text: challenge.category);
    final TextEditingController questionsController =
        TextEditingController(text: challenge.questions.join('; ')); // Para perguntas

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Editar Desafio'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
                 TextField(
                  controller: questionsController,
                  decoration: const InputDecoration(
                      labelText: 'Perguntas (separadas por ;)'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    categoryController.text.isNotEmpty) {
                  final updatedChallenge = Challenge(
                    id: challenge.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    category: categoryController.text,
                    questions: questionsController.text.split(';').map((e) => e.trim()).toList(),
                    participants: challenge.participants, // Mantém participantes existentes
                  );
                  AppDatabase().updateChallenge(updatedChallenge);
                  setState(() {}); // Atualiza a lista de desafios na tela
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Desafio atualizado com sucesso!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, preencha todos os campos.')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteChallengeDialog(BuildContext context, Challenge challenge) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text(
              'Tem certeza que deseja excluir o desafio "${challenge.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                AppDatabase().deleteChallenge(challenge.id);
                setState(() {}); // Atualiza a lista de desafios na tela
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Desafio excluído com sucesso!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
