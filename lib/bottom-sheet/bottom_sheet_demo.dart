import 'package:flutter/material.dart';
import 'package:fx_2_folder/bottom-sheet/bottom_sheet.dart';
import 'package:fx_2_folder/bottom-sheet/grid.dart';

class BottomSheetDemo extends StatefulWidget {
  const BottomSheetDemo({Key? key}) : super(key: key);

  @override
  State<BottomSheetDemo> createState() => _BottomSheetDemoState();
}

class _BottomSheetDemoState extends State<BottomSheetDemo> {
  final _drawerController = CustomDrawerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: CustomDrawer(
          mainContent: _yourMainContent(),
          drawerContent: _yourSheetContent(),
          controller: _drawerController,
        ),
      ),
    );
  }

  Widget _yourMainContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: GridPatternPainter(isDarkMode: false),
          ),
        ),
        Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Row(
                  children: [
                    Icon(
                      Icons.design_services_rounded,
                      size: 32,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Your App',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.swipe_up_rounded,
                        size: 48,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Show bottomsheet',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.8,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Discover More',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => _drawerController.toggle(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // More modern, squared corners
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Open'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_upward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _yourSheetContent() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bottom Sheet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your example bottom sheet content.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 24),
              _buildFeatureCard(
                icon: Icons.gesture,
                title: 'Settings 1',
                description: 'a random settings screen for your app.',
                color: Colors.grey[700]!,
              ),
              _buildFeatureCard(
                icon: Icons.gesture,
                title: 'Settings 2',
                description: 'a random settings screen for your app.',
                color: Colors.grey[600]!,
              ),
              _buildFeatureCard(
                icon: Icons.gesture,
                title: 'Settings 3',
                description: 'a random settings screen for your app.',
                color: Colors.grey[500]!,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[200]!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container with gradient
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 20),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      height: 1.2,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
