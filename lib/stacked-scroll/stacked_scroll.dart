import 'package:flutter/material.dart';

class StackingCardsList extends StatefulWidget {
  const StackingCardsList({Key? key}) : super(key: key);

  @override
  State<StackingCardsList> createState() => _StackingCardsListState();
}

class _StackingCardsListState extends State<StackingCardsList> {
  final ScrollController _scrollController = ScrollController();
  final double _cardHeight = 200.0;
  final int _totalCards = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() {}); // Trigger rebuild to update card positions
  }

  double _getCardOffset(int index) {
    final scrollOffset = _scrollController.offset;
    final rawOffset = (index * _cardHeight) - scrollOffset;

    // If card should be stacked at top
    if (rawOffset < 0) {
      return 0;
    }

    return rawOffset;
  }

  bool _shouldRenderCard(int index) {
    final currentCard = (_scrollController.offset / _cardHeight).floor();
    // Only render current card and next few cards
    return index >= currentCard - 1 && index <= currentCard + 3;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: _cardHeight * _totalCards,
        child: Stack(
          children: List.generate(_totalCards, (index) {
            if (!_shouldRenderCard(index)) {
              return const SizedBox.shrink();
            }

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: _getCardOffset(index),
              left: 0,
              right: 0,
              height: _cardHeight,
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                color: Colors.blue[
                    (index % 9 + 1) * 100], // Different colors for visibility
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Card ${index + 1}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Offset: ${_getCardOffset(index).toStringAsFixed(1)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
