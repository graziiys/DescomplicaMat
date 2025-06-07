import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:math'; // Não está sendo usado, pode ser removido

void main() {
  runApp(const MyApp()); // Adicionado const para otimização
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Adicionado const constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DescomplicaMat',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32), // Verde matemático
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Garante que a fonte seja aplicada
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0, // AppBar sem sombra para um look mais flat
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
            borderSide: BorderSide.none, // Borda inicial sem linha
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
      home: const SplashScreen(), // Adicionado const
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---
// Tela de Splash com animação
// ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Adicionado const constructor

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
      if (mounted) { // Verifica se o widget ainda está montado antes de navegar
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()), // Adicionado const
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
  const AuthScreen({super.key}); // Adicionado const constructor

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

  bool _obscurePasswordLogin = true; // Senha do Login
  bool _obscurePasswordRegister = true; // Senha do Cadastro
  bool _obscureConfirmPasswordRegister = true; // Confirmação de Senha do Cadastro

  bool _isLoadingLogin = false;
  bool _isLoadingRegister = false;

  final List<String> schoolYears = const [
    '1º Ano', '2º Ano', '3º Ano', '4º Ano', '5º Ano',
    '6º Ano', '7º Ano', '8º Ano', '9º Ano',
    '1º Ano EM', '2º Ano EM', '3º Ano EM',
    'Ensino Superior', 'Outros'
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
                prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF2E7D32)),
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
                prefixIcon: const Icon(Icons.lock_outlined, color: Color(0xFF2E7D32)),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePasswordLogin ? Icons.visibility : Icons.visibility_off),
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
                    const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
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
                prefixIcon: Icon(Icons.person_outlined, color: Color(0xFF2E7D32)),
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
                prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF2E7D32)),
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
                prefixIcon: Icon(Icons.school_outlined, color: Color(0xFF2E7D32)),
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
                prefixIcon: const Icon(Icons.lock_outlined, color: Color(0xFF2E7D32)),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePasswordRegister ? Icons.visibility : Icons.visibility_off),
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
                prefixIcon: const Icon(Icons.lock_outlined, color: Color(0xFF2E7D32)),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPasswordRegister ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPasswordRegister = !_obscureConfirmPasswordRegister;
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

      if (mounted) { // Verifica se o widget ainda está montado
        setState(() {
          _isLoadingLogin = false;
        });

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
              userName: _loginEmailController.text.split('@')[0],
              userLevel: 'Estudante', // Valor padrão, pode ser aprimorado com dados reais
            ),
          ),
        );
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

      if (mounted) { // Verifica se o widget ainda está montado
        setState(() {
          _isLoadingRegister = false;
        });

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
              userName: _registerNameController.text,
              userLevel: selectedSchoolYear ?? 'Estudante',
            ),
          ),
        );
      }
    }
  }
}

// ---
// Página inicial com seleção de atividades
// ---
class HomePage extends StatefulWidget {
  // Alterado para 'late String' para permitir que o nome seja atualizado pelo ProfilePage
  String userName;
  final String userLevel;

  // Removido 'const' do construtor para permitir que userName seja alterado
  HomePage({Key? key, required this.userName, required this.userLevel}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Lista de desafios pré-definidos para o search
  final List<String> availableChallenges = const [
    'Álgebra Básica', 'Equações do Primeiro Grau', 'Funções Quadráticas',
    'Geometria Plana', 'Geometria Espacial', 'Trigonometria',
    'Raciocínio Lógico', 'Sequências Numéricas', 'Probabilidade',
    'Aritmética Básica', 'Frações e Decimais', 'Porcentagem'
  ];

  // Callback para atualizar o nome na HomePage vindo do ProfilePage
  void _updateUserName(String newName) {
    setState(() {
      widget.userName = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // A lista de páginas deve ser definida dentro do build ou ter um const constructor
    final List<Widget> pages = [
      _buildMainContent(),
      const RankingPage(), // Adicionado const
      // Passa a função de callback para o ProfilePage
      ProfilePage(userName: widget.userName, userLevel: widget.userLevel, onNameUpdated: _updateUserName),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('DescomplicaMat'),
        automaticallyImplyLeading: false, // Desativa o botão de voltar padrão
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChallengeSearchDelegate(availableChallenges),
              );
            },
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey[600], // Adicionado para consistência
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold), // Estilo para item selecionado
        items: const [ // Adicionado const
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header com boas-vindas
          Container(
            width: double.infinity,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${widget.userName}! 🎯',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pronto para descomplicar a matemática hoje?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço necessário
                    children: [
                      const Icon(Icons.school, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Nível: ${widget.userLevel}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desafios Matemáticos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolha um tema e teste seus conhecimentos!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Grid de desafios
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Impede scroll duplicado
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildChallengeCard(
                      context,
                      title: 'Álgebra',
                      subtitle: '15 desafios',
                      icon: Icons.functions,
                      color: const Color(0xFF2196F3),
                      onTap: () => _navigateToChallenge(context, 'Álgebra'),
                    ),
                    _buildChallengeCard(
                      context,
                      title: 'Geometria',
                      subtitle: '12 desafios',
                      icon: Icons.category,
                      color: const Color(0xFF9C27B0),
                      onTap: () => _navigateToChallenge(context, 'Geometria'),
                    ),
                    _buildChallengeCard(
                      context,
                      title: 'Lógica',
                      subtitle: '20 desafios',
                      icon: Icons.psychology,
                      color: const Color(0xFFFF9800),
                      onTap: () => _navigateToChallenge(context, 'Lógica'),
                    ),
                    _buildChallengeCard(
                      context,
                      title: 'Numéricos',
                      subtitle: '18 desafios',
                      icon: Icons.calculate,
                      color: const Color(0xFF4CAF50),
                      onTap: () => _navigateToChallenge(context, 'Numéricos'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Seção modo competitivo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5722), Color(0xFFFF8A65)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.bolt,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Modo Competitivo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enfrente outros jogadores em tempo real e suba no ranking!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Modo Competitivo em breve!'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Jogar Agora'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFFF5722),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToChallenge(BuildContext context, String challengeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando desafio de $challengeName...'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    // TODO: Implementar navegação real para a tela do desafio
  }
}

// ---
// Delegate de Pesquisa de Desafios
// ---
class ChallengeSearchDelegate extends SearchDelegate<String> {
  final List<String> challenges;

  ChallengeSearchDelegate(this.challenges);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> searchResults = challenges
        .where((challenge) => challenge.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (searchResults.isEmpty) {
      return Center(
        child: Text(
          'Nenhum desafio encontrado para "$query"',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]),
          onTap: () {
            close(context, searchResults[index]);
            // TODO: Implementar navegação para o desafio selecionado
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Você selecionou: ${searchResults[index]}'),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? challenges // Mostra todos os desafios se a query estiver vazia
        : challenges.where((challenge) => challenge.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query = suggestionList[index];
            showResults(context); // Exibe os resultados completos ao clicar na sugestão
          },
        );
      },
    );
  }
}

// ---
// Página de Ranking (exemplo)
// ---
class RankingPage extends StatelessWidget {
  const RankingPage({super.key}); // Adicionado const constructor

  final List<Map<String, dynamic>> rankingData = const [
    {'name': 'Alice', 'score': 1500, 'rank': 1},
    {'name': 'Bob', 'score': 1420, 'rank': 2},
    {'name': 'Charlie', 'score': 1380, 'rank': 3},
    {'name': 'Diana', 'score': 1250, 'rank': 4},
    {'name': 'Eduardo', 'score': 1100, 'rank': 5},
    {'name': 'Fernanda', 'score': 980, 'rank': 6},
    {'name': 'Gustavo', 'score': 850, 'rank': 7},
    {'name': 'Helena', 'score': 720, 'rank': 8},
    {'name': 'Igor', 'score': 600, 'rank': 9},
    {'name': 'Juliana', 'score': 550, 'rank': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ranking Global 🏆',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Veja quem está no topo e inspire-se para alcançar novos desafios!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListView.separated(
              shrinkWrap: true, // Para o ListView se ajustar ao conteúdo
              physics: const NeverScrollableScrollPhysics(), // Evita scroll aninhado
              itemCount: rankingData.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = rankingData[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Text(
                      user['rank'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  title: Text(
                    user['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '${user['score']} pts',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Botão para ver mais do ranking
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade de Ranking Completo em breve!'),
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('Ver Ranking Completo'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---
// Página de Perfil (Agora com funcionalidade de edição)
// ---
class ProfilePage extends StatefulWidget {
  final String userName;
  final String userLevel;
  // Adicionado um callback para notificar a HomePage sobre a atualização do nome
  final Function(String) onNameUpdated;

  const ProfilePage({
    Key? key,
    required this.userName,
    required this.userLevel,
    required this.onNameUpdated,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    setState(() {
      _isEditingName = false; // Sai do modo de edição
    });
    // Notifica o widget pai (HomePage) sobre a atualização do nome
    widget.onNameUpdated(_nameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nome atualizado para: ${_nameController.text}'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    // TODO: Adicionar lógica real para persistir o nome (ex: SharedPreferences, Firebase)
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              _nameController.text.isNotEmpty ? _nameController.text.substring(0, 1).toUpperCase() : '',
              style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          // Exibe o nome como texto ou campo de edição
          _isEditingName
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    decoration: InputDecoration(
                      hintText: 'Digite seu nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.check, color: Theme.of(context).primaryColor),
                        onPressed: _saveName,
                      ),
                    ),
                    onSubmitted: (_) => _saveName(), // Salva ao pressionar Enter
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _nameController.text, // Exibe o nome do controlador
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                      onPressed: () {
                        setState(() {
                          _isEditingName = true; // Entra no modo de edição
                        });
                      },
                    ),
                  ],
                ),
          const SizedBox(height: 8),
          Text(
            widget.userLevel,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildProfileInfoRow(Icons.email, 'Email', 'seu.email@example.com'), // Email fictício
                  const Divider(height: 24),
                  _buildProfileInfoRow(Icons.emoji_events, 'Pontuação Total', '1250 pontos'), // Pontuação fictícia
                  const Divider(height: 24),
                  _buildProfileInfoRow(Icons.military_tech, 'Conquistas', '5 concluídas'), // Conquistas fictícias
                  const Divider(height: 24),
                  _buildProfileInfoRow(Icons.update, 'Último Acesso', '07/06/2025'), // Data fictícia
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementar lógica de logout
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (Route<dynamic> route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Você foi desconectado.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair da Conta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ],
    );
  }
}
