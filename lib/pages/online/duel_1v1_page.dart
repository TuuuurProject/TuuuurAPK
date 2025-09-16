import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';

class Duel1v1Page extends StatefulWidget {
  final List<String> categories;
  final VoidCallback onBack;
  final VoidCallback onStart;

  const Duel1v1Page({
    super.key,
    required this.categories,
    required this.onBack,
    required this.onStart,
  });

  @override
  State<Duel1v1Page> createState() => _Duel1v1PageState();
}

class _Duel1v1PageState extends State<Duel1v1Page>
    with TickerProviderStateMixin {
  late AnimationController _vsController;
  bool isReady = false;
  bool opponentReady = false;

  @override
  void initState() {
    super.initState();
    _vsController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Simulate opponent getting ready
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => opponentReady = true);
      }
    });
  }

  @override
  void dispose() {
    _vsController.dispose();
    super.dispose();
  }

  void toggleReady() {
    setState(() => isReady = !isReady);
  }

  bool get canStart => isReady && opponentReady;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: TuuurStyles.pill,
                child: const FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  color: TuuurTheme.brandLightGray,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const FaIcon(
              FontAwesomeIcons.fire,
              color: TuuurTheme.brandOrange,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Duel 1vs1',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: TuuurTheme.brandLightGray,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: TuuurStyles.pill.copyWith(
                color: TuuurTheme.brandOrange.withOpacity(0.2),
                border: Border.all(
                  color: TuuurTheme.brandOrange.withOpacity(0.3),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.bolt,
                    color: TuuurTheme.brandOrange,
                    size: 12,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Compétitif',
                    style: TextStyle(
                      color: TuuurTheme.brandOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn().slideX(begin: -0.3),
        const SizedBox(height: 32),

        // Main Duel Arena
        Container(
          padding: const EdgeInsets.all(32),
          decoration: TuuurStyles.gamingCard.copyWith(
            border: Border.all(
              color: TuuurTheme.brandOrange.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // VS Section
              Row(
                children: [
                  // Player 1 (You)
                  Expanded(
                    child: _buildPlayerCard(
                      emoji: '🎮',
                      name: 'Vous',
                      level: 'Niveau 23',
                      isReady: isReady,
                      isPlayer: true,
                    ),
                  ),

                  // VS Animation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AnimatedBuilder(
                      animation: _vsController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_vsController.value * 0.2),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: TuuurTheme.brandOrange.withOpacity(0.2),
                              border: Border.all(
                                color: TuuurTheme.brandOrange,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: TuuurTheme.brandOrange.withOpacity(
                                    _vsController.value * 0.5,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'VS',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: TuuurTheme.brandOrange,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  // Player 2 (Opponent)
                  Expanded(
                    child: _buildPlayerCard(
                      emoji: '🤖',
                      name: 'CyberQuiz_Master',
                      level: 'Niveau 47',
                      isReady: opponentReady,
                      isPlayer: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Game Info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: TuuurTheme.brandDarkGray.withOpacity(0.3),
                  border: Border.all(
                    color: TuuurTheme.brandPurple.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.trophy,
                          color: TuuurTheme.brandPurple,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Règles du Duel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandLightGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGameRule(
                            icon: FontAwesomeIcons.clock,
                            title: '10 Questions',
                            description: 'Temps limité',
                          ),
                        ),
                        Expanded(
                          child: _buildGameRule(
                            icon: FontAwesomeIcons.bolt,
                            title: 'Points rapides',
                            description: 'Réponse + vitesse',
                          ),
                        ),
                        Expanded(
                          child: _buildGameRule(
                            icon: FontAwesomeIcons.crown,
                            title: 'Victoire',
                            description: 'Meilleur score',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),
              const SizedBox(height: 24),

              // Categories
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: TuuurTheme.brandOrange.withOpacity(0.1),
                  border: Border.all(
                    color: TuuurTheme.brandOrange.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.tags,
                          color: TuuurTheme.brandOrange,
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Catégories du duel',
                          style: TextStyle(
                            color: TuuurTheme.brandOrange,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.categories.map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: TuuurStyles.pill.copyWith(
                            color: TuuurTheme.brandOrange.withOpacity(0.2),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: TuuurTheme.brandOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1000.ms),
              const SizedBox(height: 32),

              // Ready Status
              if (!canStart) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isReady
                        ? TuuurTheme.brandGreen.withOpacity(0.2)
                        : TuuurTheme.brandOrange.withOpacity(0.2),
                    border: Border.all(
                      color: isReady
                          ? TuuurTheme.brandGreen.withOpacity(0.3)
                          : TuuurTheme.brandOrange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        isReady
                            ? FontAwesomeIcons.check
                            : FontAwesomeIcons.clock,
                        color: isReady
                            ? TuuurTheme.brandGreen
                            : TuuurTheme.brandOrange,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isReady
                            ? 'En attente de l\'adversaire...'
                            : 'Cliquez sur "Prêt" pour commencer',
                        style: TextStyle(
                          color: isReady
                              ? TuuurTheme.brandGreen
                              : TuuurTheme.brandOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Action Buttons
              Row(
                children: [
                  if (!canStart) ...[
                    Expanded(
                      child: GamingButtonPrimary(
                        text: isReady ? 'Pas prêt' : 'Prêt !',
                        onPressed: toggleReady,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: GamingButtonPrimary(
                        text: '⚔️ COMMENCER LE DUEL !',
                        onPressed: widget.onStart,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildPlayerCard({
    required String emoji,
    required String name,
    required String level,
    required bool isReady,
    required bool isPlayer,
  }) {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isPlayer
                ? TuuurTheme.brandPurple.withOpacity(0.1)
                : TuuurTheme.brandDarkGray.withOpacity(0.3),
            border: Border.all(
              color: isPlayer
                  ? TuuurTheme.brandPurple.withOpacity(0.3)
                  : TuuurTheme.brandGray.withOpacity(0.3),
              width: isReady ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: isPlayer
                      ? TuuurTheme.brandPurple.withOpacity(0.2)
                      : TuuurTheme.brandGray.withOpacity(0.2),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TuuurTheme.brandLightGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              // Level
              Text(
                level,
                style: const TextStyle(
                  color: TuuurTheme.brandGray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),

              // Ready Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: TuuurStyles.pill.copyWith(
                  color: isReady
                      ? TuuurTheme.brandGreen.withOpacity(0.2)
                      : TuuurTheme.brandOrange.withOpacity(0.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      isReady ? FontAwesomeIcons.check : FontAwesomeIcons.clock,
                      color: isReady
                          ? TuuurTheme.brandGreen
                          : TuuurTheme.brandOrange,
                      size: 12,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isReady ? 'Prêt' : 'En attente',
                      style: TextStyle(
                        color: isReady
                            ? TuuurTheme.brandGreen
                            : TuuurTheme.brandOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: (isPlayer ? 400 : 600).ms)
        .slideX(begin: isPlayer ? -0.3 : 0.3);
  }

  Widget _buildGameRule({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        FaIcon(icon, color: TuuurTheme.brandPurple, size: 20),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: TuuurTheme.brandLightGray,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(color: TuuurTheme.brandGray, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
