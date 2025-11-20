import 'dart:math';

import 'package:flutter/material.dart';

import '../data/sample_extra_content.dart';
import '../data/sample_quizzes.dart';

class ChannelCardsCarousel extends StatefulWidget {
  const ChannelCardsCarousel({super.key});

  @override
  State<ChannelCardsCarousel> createState() => _ChannelCardsCarouselState();
}

class _ChannelCardsCarouselState extends State<ChannelCardsCarousel> {
  late final List<Channel> _channels;
  late final PageController _controller;
  final ValueNotifier<double> _page = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    final random = Random();
    final shuffled = [...sampleChannels]..shuffle(random);
    _channels = shuffled.take(3).toList();
    _controller = PageController(viewportFraction: 0.92);
    _controller.addListener(() {
      _page.value = _controller.page ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_channels.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Canales recomendados', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text('Explorar canales')),
            ],
          ),
        ),
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _controller,
            itemCount: _channels.length,
            itemBuilder: (context, index) {
              final channel = _channels[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _ChannelCard(channel: channel, index: index),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<double>(
          valueListenable: _page,
          builder: (context, value, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_channels.length, (index) {
                final active = (index - value).abs() < 0.5;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class _ChannelCard extends StatefulWidget {
  final Channel channel;
  final int index;
  const _ChannelCard({required this.channel, required this.index});

  @override
  State<_ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<_ChannelCard> {
  late final PageController _quizController;

  @override
  void initState() {
    super.initState();
    _quizController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _quizController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.channel;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                image: DecorationImage(image: NetworkImage(channel.imageUrl), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.white.withOpacity(0.25),
                          ),
                          child: const Text('Canal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        Text(channel.name, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(channel.description, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                        const SizedBox(height: 12),
                        Text('${channel.quizzes.length} kahoots', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white)),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: FilledButton.tonal(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Ver canal'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kahoots del canal', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 260,
                    child: PageView.builder(
                      controller: _quizController,
                      itemCount: channel.quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = channel.quizzes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _QuizPreviewCard(quiz: quiz),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizPreviewCard extends StatelessWidget {
  final Quiz quiz;
  const _QuizPreviewCard({required this.quiz});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.7),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox.expand(
                child: Image.network(quiz.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Badge(label: 'Kahoot'),
          const SizedBox(height: 10),
          Text(
            quiz.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            quiz.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () {},
              style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
              child: const Text('Ver'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.primary.withOpacity(0.15),
      ),
      child: Text(label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}