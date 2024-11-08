import 'package:flutter/material.dart';
import 'package:fx_2_folder/test-1/light_bulb.dart';

class NightModeDemo extends StatefulWidget {
  const NightModeDemo({Key? key}) : super(key: key);

  @override
  State<NightModeDemo> createState() => _DemoState();
}

class _DemoState extends State<NightModeDemo> {
  bool isDarkMode = true;

  void _handleThemeChange(bool isLightMode) {
    setState(() {
      isDarkMode = !isLightMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: Scaffold(
        body: Stack(
          children: [
            ThemeShowcaseCard(isDarkMode: isDarkMode),
            ThemeLightBulb(
              onThemeChanged: _handleThemeChange,
              initialState: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }
}

//card--------------------------------

class ThemeShowcaseCard extends StatelessWidget {
  final bool isDarkMode;

  const ThemeShowcaseCard({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: isDarkMode ? 8.0 : 4.0,
          shadowColor: isDarkMode
              ? Colors.blue.withOpacity(0.4)
              : Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          size: 24,
                          color: isDarkMode ? Colors.blue : Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isDarkMode ? 'Night Mode' : 'Day Mode',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.blue
                                        : Colors.orange,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isDarkMode
                                  ? 'Easier on your eyes in low light'
                                  : 'Perfect visibility in daylight',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        context,
                        icon: Icons.visibility,
                        title: 'Visibility',
                        value: isDarkMode
                            ? 'Optimized for dark'
                            : 'Enhanced for daylight',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        icon: Icons.battery_charging_full,
                        title: 'Battery Usage',
                        value: isDarkMode
                            ? 'Reduced consumption'
                            : 'Standard consumption',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        icon: Icons.remove_red_eye,
                        title: 'Eye Comfort',
                        value:
                            isDarkMode ? 'Maximum comfort' : 'Balanced viewing',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDarkMode ? Colors.blue : Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
