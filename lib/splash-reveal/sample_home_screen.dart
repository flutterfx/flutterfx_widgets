import 'package:flutter/material.dart';
import 'package:fx_2_folder/splash-reveal/splash_demo.dart';

class MonochromeHomeScreen extends StatelessWidget {
  const MonochromeHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Changed to dark background
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        // Darker app bar
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 1,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white, // White text
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Colors.white70), // Lighter icon
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline,
                color: Colors.white70), // Lighter icon
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Dark card background
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    color: Colors.white70, // Light gray text
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Marcus Aurelius',
                  style: TextStyle(
                    color: Colors.white, // White text
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Tasks',
                  '12',
                  Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Projects',
                  '4',
                  Icons.access_alarm_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity Section
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: Colors.white, // White text
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Activity Items
          _buildActivityItem(
            'Project Update',
            'Design system components updated',
            '2h ago',
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            'New Comment',
            'Sarah commented on your task',
            '4h ago',
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            'Task Completed',
            'Homepage redesign finished',
            '1d ago',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E), // Dark background
        selectedItemColor: Colors.white, // White for selected
        unselectedItemColor: Colors.white70, // Light gray for unselected
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70), // Light gray icon
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white, // White text
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70, // Light gray text
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String description, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: Colors.white70, // Light gray dot
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white, // White text
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70, // Light gray text
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white54, // Darker gray text
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Loading screen with dark theme
class LoadingApp extends StatefulWidget {
  const LoadingApp({Key? key}) : super(key: key);

  @override
  State<LoadingApp> createState() => _LoadingAppState();
}

class _LoadingAppState extends State<LoadingApp> {
  final _revealController = SplashRevealController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    await _revealController.startReveal();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: Stack(
        children: [
          const MonochromeHomeScreen(),
          SplashRevealWidget(
            controller: _revealController,
            duration: const Duration(milliseconds: 1500),
            onAnimationComplete: () {
              print('App reveal completed!');
            },
            child: Container(
              color: const Color(0xFF121212),
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white70,
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
