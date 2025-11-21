import 'dart:async';

import 'package:flutter/material.dart';
import '../data/sample_quizzes.dart';
import '../pages/quiz_detail_page.dart';

class TrendingSection extends StatefulWidget {
  final List<Quiz> items;
  final String title;

  const TrendingSection({super.key, required this.items, required this.title});

  @override
  State<TrendingSection> createState() => _TrendingSectionState();
}

class _TrendingSectionState extends State<TrendingSection> {
  final PageController _controller = PageController(viewportFraction: 0.94);
  int _current = 0;
  Timer? _autoplayTimer;
  bool _userInteracting = false;
  OverlayEntry? _dragOverlay;
  Offset _dragPosition = Offset.zero;
  Quiz? _draggedQuiz;
  double _draggedDelta = 0;
  Size? _screenSize;
  TextTheme? _dragTextTheme;
  bool _dragActive = false;

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _removeDragOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _autoplayTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      if (_userInteracting) return;
      if (widget.items.isEmpty) return;
      final next = (_current + 1) % widget.items.length;
      if (_controller.hasClients) {
        _controller.animateToPage(next, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 260,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notif) {
              if (notif is UserScrollNotification) {
                _userInteracting = true;
              } else if (notif is ScrollEndNotification) {
                _userInteracting = false;
              }
              return false;
            },
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.items.length,
              physics: _dragActive ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, index) {
                final q = widget.items[index];
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double page = 0.0;
                    try {
                      page = _controller.page ?? _controller.initialPage.toDouble();
                    } catch (_) {
                      page = _current.toDouble();
                    }
                    final double delta = (index - page);
                    final double scale = (1 - delta.abs() * 0.08).clamp(0.88, 1.0);
                    final double translateX = delta * 28;

                    return Transform.translate(
                      offset: Offset(translateX, 0),
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                          child: _buildInteractiveCard(context, q, delta),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (i) {
            final active = i == _current;
            return GestureDetector(
              onTap: () {

                _userInteracting = true;
                if (_controller.hasClients) {
                  _controller
                      .animateToPage(i, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut)
                      .then((_) {
                    if (!mounted) return;
                    setState(() => _current = i);
                    _userInteracting = false;
                  });
                }
                setState(() => _current = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(color: active ? Theme.of(context).colorScheme.primary : Colors.grey[400], borderRadius: BorderRadius.circular(8)),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInteractiveCard(BuildContext context, Quiz quiz, double delta) {
    _screenSize ??= MediaQuery.of(context).size;

    Widget buildCard() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FractionalTranslation(
              translation: Offset(-delta * 0.12, 0),
              child: Image.network(quiz.imageUrl, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.64)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              right: 14,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Kahoot', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                        const SizedBox(height: 6),
                        Text(quiz.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(quiz.author, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuizDetailPage(quiz: quiz)));
      },
      onPanStart: (details) {
        _startDrag(context, details.globalPosition, quiz, delta);
      },
      onPanUpdate: (details) {
        _updateDrag(details.globalPosition, delta);
      },
      onPanEnd: (_) {
        _stopDrag();
      },
      onPanCancel: _stopDrag,
      child: buildCard(),
    );
  }

  void _startDrag(BuildContext context, Offset globalPosition, Quiz quiz, double delta) {
    _userInteracting = true;
    _dragActive = true;
    _draggedQuiz = quiz;
    _draggedDelta = delta;
    _dragPosition = globalPosition;
    _screenSize ??= MediaQuery.of(context).size;
    _dragTextTheme = Theme.of(context).textTheme;
    _insertDragOverlay(context);
    setState(() {});
  }

  void _updateDrag(Offset globalPosition, double delta) {
    _dragPosition = globalPosition;
    _draggedDelta = delta;
    _dragOverlay?.markNeedsBuild();
  }

  void _stopDrag() {
    _userInteracting = false;
    _dragActive = false;
    _removeDragOverlay();
    setState(() {});
  }

  void _insertDragOverlay(BuildContext context) {
    _removeDragOverlay();
    final overlay = Overlay.of(context, rootOverlay: true);
    _dragOverlay = OverlayEntry(builder: (_) => _buildDragOverlay());
    overlay.insert(_dragOverlay!);
  }

  Widget _buildDragOverlay() {
    if (_draggedQuiz == null || _screenSize == null) {
      return const SizedBox.shrink();
    }
    final width = _screenSize!.width * 0.85;
    const height = 220.0;
    return Positioned(
      left: _dragPosition.dx - width / 2,
      top: _dragPosition.dy - height / 2,
      child: IgnorePointer(
        child: SizedBox(
          width: width,
          height: height,
          child: Material(
            color: Colors.transparent,
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FractionalTranslation(
                    translation: Offset(-_draggedDelta * 0.12, 0),
                    child: Image.network(_draggedQuiz!.imageUrl, fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.64)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 14,
                    right: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Kahoot', style: _dragTextTheme?.bodySmall?.copyWith(color: Colors.white70)),
                        const SizedBox(height: 6),
                        Text(_draggedQuiz!.title, style: _dragTextTheme?.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(_draggedQuiz!.author, style: _dragTextTheme?.bodySmall?.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeDragOverlay() {
    _dragOverlay?.remove();
    _dragOverlay = null;
    _draggedQuiz = null;
    _dragTextTheme = null;
  }
}