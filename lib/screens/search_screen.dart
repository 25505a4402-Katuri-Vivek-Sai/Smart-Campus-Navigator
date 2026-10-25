import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> _allPlaces = [
    {'name': 'Principal Room', 'location': 'Admin Block, Ground Floor', 'icon': Icons.person_rounded},
    {'name': 'Admin Office', 'location': 'Admin Block, Floor 1', 'icon': Icons.business_rounded},
    {'name': 'Staff Room', 'location': 'Admin Block, Floor 2', 'icon': Icons.groups_rounded},
    {'name': 'Computer Lab 1', 'location': 'Block A, Floor 1', 'icon': Icons.computer_rounded},
    {'name': 'Computer Lab 2', 'location': 'Block A, Floor 2', 'icon': Icons.computer_rounded},
    {'name': 'Computer Lab 3', 'location': 'Block A, Floor 3', 'icon': Icons.computer_rounded},
    {'name': 'Physics Lab', 'location': 'Block B, Floor 1', 'icon': Icons.science_rounded},
    {'name': 'Chemistry Lab', 'location': 'Block B, Floor 2', 'icon': Icons.science_rounded},
    {'name': 'Drawing Lab', 'location': 'Block C, Floor 2', 'icon': Icons.draw_rounded},
    {'name': 'Library', 'location': 'Block B, Floor 1', 'icon': Icons.menu_book_rounded},
    {'name': 'Auditorium', 'location': 'Block C, Floor 1', 'icon': Icons.theater_comedy_rounded},
    {'name': 'Cafeteria', 'location': 'Ground Floor', 'icon': Icons.restaurant_rounded},
    {'name': 'Exam Cell', 'location': 'Block B, Floor 2', 'icon': Icons.edit_document},
    {'name': 'Sports Room', 'location': 'Block C, Floor 1', 'icon': Icons.sports_basketball_rounded},
    {'name': 'Seminar Hall', 'location': 'Block B, Floor 3', 'icon': Icons.co_present_rounded},
  ];

  List<Map<String, dynamic>> get _filteredPlaces {
    if (_query.isEmpty) return [];
    return _allPlaces.where((p) => p['name'].toString().toLowerCase().contains(_query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2F80ED)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Search Campus', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (val) => setState(() => _query = val),
                decoration: InputDecoration(
                  hintText: 'Type to search locations...',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2F80ED), size: 24),
                  suffixIcon: _query.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear_rounded, color: Colors.grey), onPressed: () { setState(() { _query = ''; _searchController.clear(); }); })
                    : IconButton(icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF2F80ED), size: 24), onPressed: () {}),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty) Navigator.pushNamed(context, '/map', arguments: val);
                },
              ),
            ),
          ),
          if (_filteredPlaces.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filteredPlaces.length,
                itemBuilder: (context, index) {
                  final place = _filteredPlaces[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/map', arguments: place['name']),
                      borderRadius: BorderRadius.circular(12),
                      hoverColor: const Color(0xFF2F80ED).withOpacity(0.05),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                              child: Icon(place['icon'], color: const Color(0xFF2F80ED), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(place['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  Text(place['location'], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.north_east_rounded, color: Color(0xFF2F80ED), size: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else if (_query.isNotEmpty)
            const Expanded(child: Center(child: Text('No locations found', style: TextStyle(color: Colors.grey))))
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: [
                        _buildCategoryItem(Icons.school_rounded, 'Computer Lab', Colors.blue),
                        _buildCategoryItem(Icons.science_rounded, 'Physics Lab', Colors.purple),
                        _buildCategoryItem(Icons.science_rounded, 'Chemistry Lab', Colors.orange),
                        _buildCategoryItem(Icons.draw_rounded, 'Drawing Lab', Colors.teal),
                        _buildCategoryItem(Icons.local_library_rounded, 'Library', Colors.indigo),
                        _buildCategoryItem(Icons.person_rounded, 'Principal Room', Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2F80ED),
        onTap: (i) {
          switch (i) {
            case 0: Navigator.pushReplacementNamed(context, '/home'); break;
            case 1: Navigator.pushNamed(context, '/map'); break;
            case 2: break;
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

  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () { setState(() { _query = label; _searchController.text = label; }); },
        borderRadius: BorderRadius.circular(16),
        hoverColor: color.withOpacity(0.08),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
