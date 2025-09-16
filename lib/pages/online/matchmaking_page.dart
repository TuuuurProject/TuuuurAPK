import 'package:flutter/material.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';

enum MatchmakingState { search, found }

class MatchmakingPage extends StatefulWidget {
  final List<String> categories;
  final VoidCallback onBack;
  final VoidCallback onDuel;

  const MatchmakingPage({
    super.key,
    required this.categories,
    required this.onBack,
    required this.onDuel,
  });

  @override
  State<MatchmakingPage> createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  MatchmakingState state = MatchmakingState.search;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Simulate finding opponent after 3 seconds - Vue.js behavior
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && state == MatchmakingState.search) {
        setState(() {
          state = MatchmakingState.found;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),

        // Main content - matching Vue.js exactly
        Center(
          child: SizedBox(
            width: 288, // w-72 equivalent
            height: 288, // h-72 equivalent
            child: Stack(
              children: [
                // Background blur
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(144),
                      color: TuuurTheme.brandLightGray.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: TuuurTheme.brandLightGray.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                // Animated rings
                for (int i = 0; i < 3; i++)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final delay = i * 0.4;
                        final animValue =
                            (_pulseController.value + delay) % 1.0;
                        final scale = 0.5 + (animValue * 0.7);
                        final opacity = 0.7 - (animValue * 0.7);

                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(144),
                              border: Border.all(
                                color: TuuurTheme.brandOrange.withOpacity(
                                  opacity * 0.35,
                                ),
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Main content circle
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(144),
                      color: Colors.white.withOpacity(0.8),
                      border: Border.all(
                        color: TuuurTheme.brandDark.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: state == MatchmakingState.search
                          ? _buildSearchContent()
                          : _buildFoundContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Action buttons - exactly like Vue.js
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GamingButtonSecondary(text: 'Annuler', onPressed: widget.onBack),
            const SizedBox(width: 12),
            GamingButtonPrimary(
              text: 'Commencer le duel',
              onPressed: state == MatchmakingState.found ? widget.onDuel : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search, size: 40, color: Color(0xFF333333)),
        const SizedBox(height: 8),
        const Text(
          'Recherche',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Nous cherchons un adversaire…',
          style: TextStyle(
            color: Color(0xFF333333).withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFoundContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Players section
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: TuuurTheme.brandLightGray.withOpacity(0.2),
                  ),
                  child: const Center(
                    child: Text('🦊', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Vous',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'VS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: TuuurTheme.brandOrange.withOpacity(0.2),
                  ),
                  child: const Center(
                    child: Text('🐯', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Adversaire',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Adversaire trouvé !',
          style: TextStyle(
            color: Color(0xFF333333).withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
