import 'package:flutter/material.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

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
        title: const Text('Design Document', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Design Document',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F80ED)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// PROBLEM IDENTIFICATION
                  const Text(
                    'PROBLEM IDENTIFICATION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'In many college campuses, students, staff, and visitors face difficulties in locating classrooms, laboratories, faculty rooms, administrative offices, and other important facilities. Large campus areas, multiple buildings, and lack of proper navigation systems create confusion and delay in reaching the required locations. New students and visitors especially struggle to find their destinations, which leads to time wastage and inconvenience.\n\n'
                    'Currently, most campuses rely on traditional methods such as signboards, printed maps, or asking others for directions. These methods are not efficient and often create confusion, especially for first-time visitors. There is no centralized digital system that provides accurate and real-time navigation inside the campus. As a result, users spend extra time searching for locations and sometimes reach late to classes or meetings.\n\n'
                    'Students often face difficulty in finding new classrooms or laboratories when schedules change. Staff members sometimes struggle to guide visitors or new students due to lack of a proper navigation system. Visitors coming for admissions, events, or meetings face confusion while moving around the campus. Emergency situations also become difficult to handle without proper location guidance.\n\n'
                    'The major problems identified in the campus navigation system include:\n\n'
                    '• Difficulty in locating classrooms and laboratories\n'
                    '• Lack of real-time campus navigation\n'
                    '• Time wastage in searching for locations\n'
                    '• Confusion among new students and visitors\n'
                    '• Dependence on signboards and manual directions\n'
                    '• No centralized digital campus navigation system\n'
                    '• Difficulty in handling emergency location support\n\n'
                    'These problems clearly show the need for a smart and efficient campus navigation system. Therefore, the Smart Campus Navigator project is proposed to provide a digital solution that helps users easily locate places and navigate within the campus without confusion.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ABSTRACT
                  const Text(
                    'ABSTRACT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'The Smart Campus Navigator is a Design Thinking and Innovation (DT&I) project developed to solve the common problem of navigation and location identification within a college campus. Many students, staff members, and visitors face difficulty in finding classrooms, laboratories, faculty rooms, and important campus facilities due to lack of proper navigation systems. This creates confusion, wastes time, and reduces efficiency in campus movement.\n\n'
                    'The main objective of this project is to design a smart and user-friendly campus navigation system that helps users easily locate places within the campus using a mobile application. The system provides an interactive campus map, search functionality, GPS-based navigation, and real-time route guidance to help users reach their destination quickly and efficiently.\n\n'
                    'This project follows the Design Thinking methodology, which includes understanding user needs, identifying problems, creating personas and empathy maps, defining problem statements, generating innovative ideas, developing prototypes, and testing the solution. The Smart Campus Navigator focuses on providing a simple, accessible, and efficient navigation system for students, staff, and visitors.\n\n'
                    'The proposed solution improves campus accessibility, reduces confusion, saves time, and enhances the overall campus experience. The system also includes emergency support features and user-friendly interface design to ensure easy usage by all users.\n\n'
                    'This project demonstrates how Design Thinking can be used to develop innovative solutions for real-world campus problems and create a smart digital environment in educational institutions.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2F80ED),
        onTap: (i) {
          switch (i) {
            case 0: Navigator.pushReplacementNamed(context, '/home'); break;
            case 1: Navigator.pushNamed(context, '/map'); break;
            case 2: Navigator.pushNamed(context, '/search'); break;
            case 3: Navigator.pushNamed(context, '/help'); break;
            case 4: break;
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
}
