import 'package:flutter/material.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String role = authService.currentUserRole ?? 'Guest';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: (role == 'Parent' || role == 'Guest') ? AppBar(
        title: const Text('Smart Navigator', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF2F80ED),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, $role 👋', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      const Text('Smart Campus Navigator', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF2F80ED),
                        child: Icon(Icons.person_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Quick Actions
              const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  _buildQuickAction(context, Icons.map_rounded, 'Campus Map', const Color(0xFF2F80ED), '/map'),
                  _buildQuickAction(context, Icons.search_rounded, 'Search', const Color(0xFF9B51E0), '/search'),
                  _buildQuickAction(context, Icons.warning_rounded, 'Emergency', Colors.redAccent, '/emergency'),
                  _buildQuickAction(context, Icons.feedback_rounded, 'Feedback', const Color(0xFF27AE60), '/help'),
                  _buildQuickAction(context, Icons.apartment_rounded, 'Facilities', const Color(0xFFEB5757), '/facilities'),
                ],
              ),

              const SizedBox(height: 32),

              // Popular Destinations
              const Text('Popular Destinations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildDestinationItem(context, 'Computer Lab 3', 'Block A, Floor 3', Icons.computer_rounded),
              _buildDestinationItem(context, 'Physics Lab', 'Block B, Floor 1', Icons.science),
              _buildDestinationItem(context, 'Admin Office', 'Admin Block, Floor 1', Icons.business_rounded),
              _buildDestinationItem(context, 'Principal Room', 'Admin Block, Ground', Icons.person_rounded),
              _buildDestinationItem(context, 'Cafeteria', 'Ground', Icons.restaurant_rounded),

              const SizedBox(height: 32),

              // Campus Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Campus Hours', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Mon-Fri: 8:00 AM - 6:00 PM', style: TextStyle(color: Colors.white70)),
                    Text('Sat: 9:00 AM - 1:00 PM', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Signature
              Center(
                child: Text(
                  '@developed by Katuri Vivek Sai 25505A4402 Data Science',
                  style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2F80ED),
        onTap: (i) {
          switch (i) {
            case 0: break;
            case 1: Navigator.pushNamed(context, '/map'); break;
            case 2: Navigator.pushNamed(context, '/search'); break;
            case 3: Navigator.pushNamed(context, '/help'); break;
            case 4: Navigator.pushNamed(context, '/docs'); break;
            case 5: Navigator.pushNamed(context, '/profile'); break;
          }
        },
                items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback_outlined), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Design Doc'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, String route) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(20),
        hoverColor: color.withOpacity(0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 10),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationItem(BuildContext context, String name, String location, IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/map', arguments: name),
        borderRadius: BorderRadius.circular(16),
        hoverColor: const Color(0xFF2F80ED).withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: const Color(0xFF2F80ED), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(location, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
