import 'package:flutter/material.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Student';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<Map<String, dynamic>> roles = [
    {'name': 'Student', 'icon': Icons.school_rounded, 'color': Color(0xFF2F80ED)},
    {'name': 'Staff', 'icon': Icons.badge_rounded, 'color': Color(0xFF9B51E0)},
    {'name': 'Parent', 'icon': Icons.family_restroom_rounded, 'color': Color(0xFF27AE60)},
    {'name': 'Guest', 'icon': Icons.person_search_rounded, 'color': Color(0xFFF2994A)},
  ];

  void _handleLogin() {
    bool isCredentialRequired = (selectedRole == 'Student' || selectedRole == 'Staff');
    if (isCredentialRequired) {
      if (_formKey.currentState!.validate()) {
        if (_usernameController.text.isNotEmpty && _passwordController.text.length >= 6) {
          authService.login(selectedRole);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid username or password')));
        }
      }
    } else {
      authService.login(selectedRole);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCredentialRequired = (selectedRole == 'Student' || selectedRole == 'Staff');
    Color activeColor = roles.firstWhere((r) => r['name'] == selectedRole)['color'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: activeColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(roles.firstWhere((r) => r['name'] == selectedRole)['icon'], size: 64, color: activeColor),
              ),
              const SizedBox(height: 24),
              const Text('Smart Campus Navigator', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Select your role and sign in', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 32),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.8),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedRole == roles[index]['name'];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => setState(() => selectedRole = roles[index]['name']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected ? roles[index]['color'] : Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? roles[index]['color'] : Colors.grey[200]!, width: 2),
                          boxShadow: isSelected ? [BoxShadow(color: roles[index]['color'].withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(roles[index]['icon'], color: isSelected ? Colors.white : Colors.grey[600]),
                            const SizedBox(height: 4),
                            Text(roles[index]['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              if (isCredentialRequired) ...[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline, color: activeColor),
                    filled: true,
                    fillColor: Colors.grey[50],
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: activeColor, width: 2)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Username/Email is required';
                    if (value.contains('@')) {
                      final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (!emailRegex.hasMatch(value)) return 'Enter a valid email (e.g., test@gmail.com)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: activeColor),
                    filled: true,
                    fillColor: Colors.grey[50],
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: activeColor, width: 2)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 8) return 'Minimum 8 characters';
                    if (value.contains(' ')) return 'Password cannot contain spaces';
                    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
                    if (!passwordRegex.hasMatch(value)) {
                      return 'Must contain uppercase, lowercase, number & special symbol';
                    }
                    return null;
                  },
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: activeColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: activeColor.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: activeColor),
                      const SizedBox(width: 16),
                      Expanded(child: Text('Continue as $selectedRole to access campus navigation.', style: TextStyle(color: activeColor, fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 4,
                    ),
                    child: Text(isCredentialRequired ? 'Log In' : 'Continue', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              if (isCredentialRequired) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not registered yet? '),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Text('Create Account', style: TextStyle(color: activeColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forgot Password flow not implemented yet')));
                        },
                        child: Text('Forgot username/password?', style: TextStyle(color: activeColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
