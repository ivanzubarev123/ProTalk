import 'package:flutter/material.dart';
import 'package:protalk_frontend/frames/knowledgebase.dart' as kb;
import 'package:protalk_frontend/frames/test_screen.dart';
import 'package:protalk_frontend/frames/user_screen.dart';
import 'package:protalk_frontend/frames/test_history_screen.dart';
import 'package:protalk_frontend/frames/interview_screen.dart';
import 'package:protalk_frontend/services/auth_service.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String? _error;
  bool _softSelected = false;
  bool _hardSelected = false;
  String? _selectedMode;
  int? _selectedTheme;

  final List<String> _softThemes = ['Тема 1', 'Тема 2', 'Тема 3'];
  final List<String> _hardThemes = ['Тема A', 'Тема B', 'Тема C'];

  static const Color accentColor = Color.fromARGB(255, 127, 113, 179);
  static const Color accentLightColor = Color.fromARGB(255, 157, 144, 209);
  static const Color neutralColor = Color.fromARGB(255, 50, 40, 70);

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Требуется авторизация');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _selectSoft() {
    setState(() {
      _softSelected = true;
      _hardSelected = false;
      _selectedMode = 'Soft';
      _selectedTheme = null;
    });
  }

  void _selectHard() {
    setState(() {
      _softSelected = false;
      _hardSelected = true;
      _selectedMode = 'Hard';
      _selectedTheme = null;
    });
  }

  void _selectTheme(int themeIndex) {
    setState(() {
      _selectedTheme = themeIndex;
    });
  }

  void _navigateToTestScreen(int testNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestScreen(
          mode: _selectedMode!,
          theme: _softSelected
              ? _softThemes[_selectedTheme!]
              : _hardThemes[_selectedTheme!],
          testNumber: testNumber.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Войти'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD9CCB7),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBody(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Тесты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'База знаний',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Собеседование',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'История',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 127, 113, 179),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: // Тесты
        return _buildTestSelection();
      case 1: // База знаний
        return const kb.KnowledgeBaseScreen();
      case 2: // Собеседование
        return const InterviewScreen();
      case 3: // История
        return const TestHistoryScreen();
      case 4: // Профиль
        return const UserScreen();
      default:
        return const kb.KnowledgeBaseScreen();
    }
  }

  Widget _buildTestSelection() {
    return Scaffold(
      backgroundColor: const Color(0xFFD9CCB7),
      appBar: AppBar(
        title: const Text(
          'Выбор направления',
          style: TextStyle(
            fontFamily: 'Cuyabra',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 127, 113, 179),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Кнопка Soft
            ElevatedButton(
              onPressed: _selectSoft,
              style: ElevatedButton.styleFrom(
                backgroundColor: _softSelected ? accentLightColor : accentColor,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: Colors.black45,
              ),
              child: const Text(
                'Soft Skills',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),

            // Кнопка Hard
            ElevatedButton(
              onPressed: _selectHard,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hardSelected ? accentLightColor : accentColor,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: Colors.black45,
              ),
              child: const Text(
                'Hard Skills',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            if (_softSelected || _hardSelected)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: (_softSelected ? _softThemes : _hardThemes)
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final theme = entry.value;
                      final isSelected = _selectedTheme == index;

                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 5,
                            ),
                            child: ElevatedButton(
                              onPressed: () => _selectTheme(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? accentLightColor
                                    : neutralColor,
                                minimumSize: const Size(
                                  double.infinity,
                                  50,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                ),
                              ),
                              child: Text(
                                theme,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Column(
                              children: List.generate(3, (i) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 70,
                                    vertical: 5,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () => _navigateToTestScreen(
                                      i + 1,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      minimumSize: const Size(
                                        double.infinity,
                                        40,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Тест ${i + 1}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
