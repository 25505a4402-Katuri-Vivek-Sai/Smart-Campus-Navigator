import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/register_screen.dart';
import 'screens/help_screen.dart';
import 'screens/docs_screen.dart';
import 'screens/facilities_screen.dart';

// --- Global Session State ---
class UserSession extends ChangeNotifier {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  String userName = 'Vivek Sai';
  String email = 'viveksai@pvpsit.ac.in';
  String department = 'Data Science';
  
  double _fontSize = 14.0;
  String _fontStyle = 'Default';
  int _selectedAvatarIndex = -1;

  double get fontSize => _fontSize;
  String get fontStyle => _fontStyle;
  int get selectedAvatarIndex => _selectedAvatarIndex;

  void updateProfile(String name, String mail, String dept) {
    userName = name;
    email = mail;
    department = dept;
    notifyListeners();
  }

  void updateSettings(double size, String font) {
    _fontSize = size;
    _fontStyle = font;
    notifyListeners();
  }

  void updateAvatar(int index) {
    _selectedAvatarIndex = index;
    notifyListeners();
  }
}

final userSession = UserSession();

// --- Auth State ---
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _currentUserRole;
  bool _isLoggedIn = false;

  String? get currentUserRole => _currentUserRole;
  bool get isLoggedIn => _isLoggedIn;

  void login(String role) {
    _currentUserRole = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _currentUserRole = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}

final authService = AuthService();

void main() {
  runApp(const SmartCampusNavigator());
}

class SmartCampusNavigator extends StatelessWidget {
  const SmartCampusNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([authService, userSession]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Smart Campus Navigator',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xFF2F80ED),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2F80ED),
              primary: const Color(0xFF2F80ED),
              surface: const Color(0xFFFAFAFA),
              brightness: Brightness.light,
            ),
            fontFamily: userSession.fontStyle == 'Default' ? 'Poppins' : 'Georgia',
            textTheme: TextTheme(
              bodyMedium: TextStyle(fontSize: userSession.fontSize),
              bodySmall: TextStyle(fontSize: userSession.fontSize - 2),
              bodyLarge: TextStyle(fontSize: userSession.fontSize + 2),
            ),
          ),
          themeMode: ThemeMode.light,
          initialRoute: '/',
          builder: (context, child) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: child,
              ),
            );
          },
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => _protectedRoute(const HomeScreen()),
            '/map': (context) => _protectedRoute(const MapScreen()),
            '/search': (context) => _protectedRoute(const SearchScreen()),
            '/profile': (context) => _protectedRoute(const ProfileScreen()),
            '/emergency': (context) => _protectedRoute(const EmergencyScreen()),
            '/help': (context) => _protectedRoute(const HelpScreen()),
            '/docs': (context) => _protectedRoute(const DocsScreen()),
            '/facilities': (context) => _protectedRoute(const FacilitiesScreen()),
          },
        );
      }
    );
  }

  Widget _protectedRoute(Widget child) {
    return authService.isLoggedIn ? child : const LoginScreen();
  }
}
