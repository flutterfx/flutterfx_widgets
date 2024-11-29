import 'package:flutter/material.dart';
import 'package:fx_2_folder/decoration-bulbs/decoration_bulbs.dart';

class DecorationBulbsDemo extends StatefulWidget {
  const DecorationBulbsDemo({Key? key}) : super(key: key);

  @override
  State<DecorationBulbsDemo> createState() => _InteractiveLightsShowcaseState();
}

enum BlinkStrategyType { synchronized, sequential, wave }

class _InteractiveLightsShowcaseState extends State<DecorationBulbsDemo> {
  int _currentIndex = 0;
  bool _showLights = true;
  BlinkStrategyType _currentStrategyType = BlinkStrategyType.synchronized;

  LightAnimationStrategy get _currentStrategy {
    switch (_currentStrategyType) {
      case BlinkStrategyType.synchronized:
        return SynchronizedBlinkStrategy();
      case BlinkStrategyType.sequential:
        return SequentialBlinkStrategy();
      case BlinkStrategyType.wave:
        return WaveBlinkStrategy();
    }
  }

  final List<ShowcaseItem> _items = [
    ShowcaseItem(
      title: 'Premium Card',
      builder: (showLights, strategy) => showLights
          ? DecorativeLightsDecorator(
              numberOfLights: 10,
              colors: const [
                Colors.purple,
                Colors.pink,
                Colors.amber,
                Colors.teal,
              ],
              animationStrategy: strategy,
              child: _buildPremiumCard(),
            )
          : _buildPremiumCard(),
    ),
    ShowcaseItem(
      title: 'Action Buttons',
      builder: (showLights, strategy) => showLights
          ? DecorativeLightsDecorator(
              numberOfLights: 8,
              colors: const [Colors.red, Colors.blue, Colors.green],
              animationStrategy: strategy,
              child: _buildActionButtons(),
            )
          : _buildActionButtons(),
    ),
    ShowcaseItem(
      title: 'Feature List',
      builder: (showLights, strategy) => showLights
          ? DecorativeLightsDecorator(
              numberOfLights: 12,
              colors: const [Colors.orange, Colors.yellow],
              animationStrategy: strategy,
              child: _buildFeatureList(),
            )
          : _buildFeatureList(),
    ),
    ShowcaseItem(
      title: 'Call to Action',
      builder: (showLights, strategy) => showLights
          ? DecorativeLightsDecorator(
              numberOfLights: 12,
              colors: const [
                Colors.green,
                Colors.lightGreenAccent,
                Colors.lightGreen,
              ],
              animationStrategy: strategy,
              child: _buildCallToAction(),
            )
          : _buildCallToAction(),
    ),
  ];

  static Widget _buildPremiumCard() {
    return Card(
      color: Colors.grey[850],
      elevation: 8,
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration, color: Colors.white, size: 48),
            SizedBox(height: 16),
            Text(
              'Premium Feature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Unlock amazing capabilities',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 20,
              ),
            ),
            child: const Text(
              'Subscribe',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 20,
              ),
            ),
            child: const Text(
              'Upgrade',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildFeatureList() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemBuilder: (context, index) => ListTile(
          leading: Icon(
            Icons.star,
            color: Colors.yellow[700],
            size: 28,
          ),
          title: Text(
            'Feature ${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Tap to learn more',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildCallToAction() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[900]!,
            Colors.green[700]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ready to get started?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green[900],
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
            ),
            icon: const Icon(Icons.rocket_launch, size: 24),
            label: const Text(
              'Launch Now',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateLeft() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _navigateRight() {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _toggleLights() {
    setState(() {
      _showLights = !_showLights;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Main showcase area (70% of screen)
          Expanded(
            flex: 7,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: _items[_currentIndex]
                    .builder(_showLights, _currentStrategy),
              ),
            ),
          ),
          // Control buttons (bottom area)
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _currentIndex > 0 ? _navigateLeft : null,
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 32,
                    color: _currentIndex > 0 ? Colors.white : Colors.grey,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _toggleLights,
                        icon: Icon(_showLights
                            ? Icons.lightbulb
                            : Icons.lightbulb_outline),
                        iconSize: 32,
                        color: _showLights ? Colors.yellow : Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _showLights ? 'Hide Lights' : 'Show Lights',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStrategyDropdown(),
                    ],
                  ),
                  IconButton(
                    onPressed: _currentIndex < _items.length - 1
                        ? _navigateRight
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    iconSize: 32,
                    color: _currentIndex < _items.length - 1
                        ? Colors.white
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<BlinkStrategyType>(
        value: _currentStrategyType,
        dropdownColor: Colors.grey[850],
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: [
          DropdownMenuItem(
            value: BlinkStrategyType.synchronized,
            child: _buildDropdownItem('Synchronized'),
          ),
          DropdownMenuItem(
            value: BlinkStrategyType.sequential,
            child: _buildDropdownItem('Sequential'),
          ),
          DropdownMenuItem(
            value: BlinkStrategyType.wave,
            child: _buildDropdownItem('Wave'),
          ),
        ],
        onChanged: (BlinkStrategyType? strategyType) {
          if (strategyType != null) {
            setState(() {
              _currentStrategyType = strategyType;
            });
          }
        },
      ),
    );
  }

  Widget _buildDropdownItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }
}

class ShowcaseItem {
  final String title;
  final Widget Function(bool showLights, LightAnimationStrategy strategy)
      builder;

  ShowcaseItem({
    required this.title,
    required this.builder,
  });
}
