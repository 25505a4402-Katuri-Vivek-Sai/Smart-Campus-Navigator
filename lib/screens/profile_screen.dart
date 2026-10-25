import 'package:flutter/material.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _pickImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Choose Profile Picture', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: 8,
            itemBuilder: (c, i) => GestureDetector(
              onTap: () { 
                userSession.updateAvatar(i);
                Navigator.pop(c); 
              },
              child: CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${i + 1}'), radius: 30),
            ),
          ),
          const SizedBox(height: 16),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening native File Picker...'), backgroundColor: Color(0xFF27AE60)));
              },
              leading: const Icon(Icons.upload_file_rounded, color: Color(0xFF27AE60)),
              title: const Text('Upload from Drive/Local File', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String role = authService.currentUserRole ?? 'Guest';
    String avatarUrl = userSession.selectedAvatarIndex >= 0 ? 'https://i.pravatar.cc/150?img=${userSession.selectedAvatarIndex + 1}' : 'https://i.pravatar.cc/150?u=smartcampus';
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2F80ED)), onPressed: () => Navigator.pop(context)),
        title: const Text('My Profile', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(children: [
          GestureDetector(onTap: _pickImage, child: Stack(alignment: Alignment.bottomRight, children: [
            CircleAvatar(radius: 65, backgroundColor: const Color(0xFF2F80ED), child: CircleAvatar(radius: 61, backgroundImage: NetworkImage(avatarUrl))),
            Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Color(0xFF2F80ED), shape: BoxShape.circle), child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18)),
          ])),
          const SizedBox(height: 8),
          const Text('Tap to change photo', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          Text(userSession.userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('$role • Smart Campus Navigator', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 32),
          _section('Personal', [
            _item(Icons.person_outline_rounded, 'Edit Profile', () => _editProfile()),
            _item(Icons.bookmark_outline_rounded, 'Saved Locations', () => _savedLocs()),
          ]),
          const SizedBox(height: 20),
          _section('Application', [
            _item(Icons.settings_outlined, 'App Settings', () => _settings()),
            _item(Icons.info_outline_rounded, 'About', () => _about()),
          ]),
          const SizedBox(height: 36),
          SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(
            onPressed: () { authService.logout(); Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false); },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            label: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          )),
          const SizedBox(height: 24),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 5, type: BottomNavigationBarType.fixed, selectedItemColor: const Color(0xFF2F80ED),
        onTap: (i) { if (i == 0) Navigator.pushReplacementNamed(context, '/home'); else if (i == 1) Navigator.pushNamed(context, '/map'); else if (i == 2) Navigator.pushNamed(context, '/search'); else if (i == 3) Navigator.pushNamed(context, '/help'); },
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

  Widget _section(String t, List<Widget> items) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(left: 4, bottom: 10), child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey))),
    Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]), child: Column(children: items)),
  ]);

  Widget _item(IconData ic, String t, VoidCallback onTap) => InkWell(onTap: onTap, hoverColor: const Color(0xFF2F80ED).withOpacity(0.04), borderRadius: BorderRadius.circular(16),
    child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(ic, color: const Color(0xFF2F80ED), size: 20)),
      title: Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey)));

  void _editProfile() {
    final n = TextEditingController(text: userSession.userName);
    final e = TextEditingController(text: userSession.email);
    final d = TextEditingController(text: userSession.department);
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (c) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom, left: 32, right: 32, top: 32), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
        _tf('Full Name', n, Icons.person_rounded), const SizedBox(height: 14),
        _tf('Email', e, Icons.email_rounded), const SizedBox(height: 14),
        _tf('Department', d, Icons.business_rounded), const SizedBox(height: 28),
        SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () {
          userSession.updateProfile(n.text, e.text, d.text);
          setState((){});
          Navigator.pop(c); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!'), backgroundColor: Color(0xFF27AE60)));
        }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F80ED), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        const SizedBox(height: 40),
      ])));
  }

  void _savedLocs() => showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (c) => Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Saved Locations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
      _loc('Library', 'Block B, Floor 1'), _loc('Computer Lab 3', 'Block A, Floor 3'), _loc('Cafeteria', 'Ground Floor'), const SizedBox(height: 16),
    ])));

  void _settings() {
    double tempSize = userSession.fontSize;
    String tempStyle = userSession.fontStyle;
    
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (c) => StatefulBuilder(builder: (c, ss) => Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('App Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
        ListTile(title: const Text('Font Style'), subtitle: Text(tempStyle), trailing: const Icon(Icons.font_download_rounded),
          onTap: () { 
            ss(() => tempStyle = tempStyle == 'Default' ? 'Serif' : 'Default'); 
            userSession.updateSettings(tempSize, tempStyle);
          }),
        ListTile(title: const Text('Text Size'), subtitle: Slider(value: tempSize, min: 12, max: 24, divisions: 6,
          onChanged: (v) { 
            ss(() => tempSize = v); 
            userSession.updateSettings(tempSize, tempStyle);
          }), trailing: Text('${tempSize.toInt()}px')),
        const SizedBox(height: 24),
      ]))));
  }

  void _about() => showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (c) => SingleChildScrollView(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.explore_rounded, color: Color(0xFF2F80ED), size: 48)),
      const SizedBox(height: 16), const Text('Smart Campus Navigator', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const Text('Version 1.2.0', style: TextStyle(color: Colors.grey)), const SizedBox(height: 20),
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(height: 8),
          Text('Smart Campus Navigator is a premium interactive navigation app for college campuses with multi-floor maps, role-based access, pathfinding, and voice guidance.', style: TextStyle(fontSize: 13, height: 1.5)),
          SizedBox(height: 12), Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('• Interactive building map with 3 floors'), Text('• Role-based authentication'), Text('• Real-time map navigation'), Text('• Voice guidance & feedback system'),
          SizedBox(height: 12), Text('Documentation:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('📄 User Guide: Map navigation & floor switching'), Text('📄 Admin Guide: Location management'), Text('📄 API: Campus system integration'),
        ])),
      const SizedBox(height: 12), const Text('© 2026 Smart Campus Navigator', style: TextStyle(color: Colors.grey, fontSize: 12)), const SizedBox(height: 16),
    ])));

  Widget _tf(String l, TextEditingController c, IconData i) => TextField(controller: c, decoration: InputDecoration(labelText: l, prefixIcon: Icon(i, color: const Color(0xFF2F80ED)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)));

  Widget _loc(String n, String s) => ListTile(
    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.location_on_rounded, color: Color(0xFF2F80ED))),
    title: Text(n, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(s, style: const TextStyle(fontSize: 13, color: Colors.grey)),
    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey), onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/map', arguments: n); });
}
