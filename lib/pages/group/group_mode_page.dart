import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';
import '../../widgets/navigation_header.dart';
import '../../navigation/app_router.dart';
import 'group_create_page.dart';
import 'group_join_page.dart';
import 'group_lobby_page.dart';

enum GroupStep { mode, create, join, lobby }

class GroupLobbyData {
  String code;
  List<String> categories;
  int questions;
  bool shuffle;
  String specifics;
  List<GroupPlayer> players;

  GroupLobbyData({
    this.code = 'TUR-0000',
    this.categories = const ['Général'],
    this.questions = 10,
    this.shuffle = true,
    this.specifics = '',
    this.players = const [],
  });
}

class GroupPlayer {
  final int id;
  final String name;
  final String emoji;
  final String status;

  const GroupPlayer({
    required this.id,
    required this.name,
    required this.emoji,
    this.status = 'Prêt',
  });
}

class GroupModePage extends StatefulWidget {
  const GroupModePage({super.key});

  @override
  State<GroupModePage> createState() => _GroupModePageState();
}

class _GroupModePageState extends State<GroupModePage> {
  GroupStep step = GroupStep.mode;
  GroupLobbyData lobby = GroupLobbyData(
    players: [
      const GroupPlayer(id: 1, name: 'Alice', emoji: '🦊'),
      const GroupPlayer(id: 2, name: 'Ben', emoji: '🐼'),
    ],
  );

  void goLobbyFromCreate({
    required List<String> categories,
    required int questions,
    required bool shuffle,
    String? specifics,
  }) {
    setState(() {
      lobby.categories = categories;
      lobby.questions = questions;
      lobby.shuffle = shuffle;
      lobby.specifics = specifics ?? '';
      lobby.code = 'TUR-${1000 + (DateTime.now().millisecond % 9000)}';
      step = GroupStep.lobby;
    });
  }

  void goLobbyFromJoin({required String code}) {
    setState(() {
      lobby.code = code;
      step = GroupStep.lobby;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuuurTheme.brandDark,
      appBar: const NavigationHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    switch (step) {
      case GroupStep.mode:
        return _buildModeSelection();
      case GroupStep.create:
        return GroupCreatePage(
          onBack: () => setState(() => step = GroupStep.mode),
          onCreated: goLobbyFromCreate,
        );
      case GroupStep.join:
        return GroupJoinPage(
          onBack: () => setState(() => step = GroupStep.mode),
          onJoined: goLobbyFromJoin,
        );
      case GroupStep.lobby:
        return GroupLobbyPage(
          lobby: lobby,
          onBack: () => setState(() => step = GroupStep.mode),
        );
    }
  }

  Widget _buildModeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.users,
                  color: TuuurTheme.brandPurple,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mode Groupe',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: TuuurTheme.brandLightGray,
                  ),
                ),
              ].animate().fadeIn(duration: 600.ms).slideX(begin: -0.3),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: TuuurStyles.pill.copyWith(
                color: TuuurTheme.brandDarkGray.withOpacity(0.8),
                border: Border.all(
                  color: TuuurTheme.brandOrange.withOpacity(0.3),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.house,
                    color: TuuurTheme.brandOrange,
                    size: 14,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Local / Affichage uniquement',
                    style: TextStyle(
                      color: TuuurTheme.brandOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
        const SizedBox(height: 32),

        // Interactive Cards
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.2,
          children: [
            // Create Game Card
            _buildModeCard(
              icon: FontAwesomeIcons.gamepad,
              title: 'Créer une partie',
              description:
                  'Définissez les paramètres et partagez le code/QR avec vos amis.',
              color: TuuurTheme.brandPurple,
              onTap: () => setState(() => step = GroupStep.create),
              delay: 0,
            ),
            // Join Game Card
            _buildModeCard(
              icon: FontAwesomeIcons.rocket,
              title: 'Rejoindre une partie',
              description:
                  'Entrez un code pour rejoindre le lobby et commencer l\'aventure.',
              color: TuuurTheme.brandOrange,
              onTap: () => setState(() => step = GroupStep.join),
              delay: 200,
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Tips Section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: TuuurStyles.gamingCard,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: TuuurTheme.brandGreen.withOpacity(0.2),
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.lightbulb,
                        color: TuuurTheme.brandGreen,
                        size: 16,
                      ),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2000.ms),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.bullseye,
                          color: TuuurTheme.brandPurple,
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Conseils pour une partie réussie',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandLightGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          [
                                '• Choisissez des catégories que tous les joueurs apprécient',
                                '• Utilisez le mélange de questions pour plus de surprise',
                                '• Partagez le QR code pour un accès rapide',
                              ]
                              .map(
                                (tip) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    tip,
                                    style: const TextStyle(
                                      color: TuuurTheme.brandGray,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: TuuurStyles.gamingCard.copyWith(
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: color.withOpacity(0.2),
                      ),
                      child: Center(
                        child: FaIcon(icon, color: color, size: 20),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 0,
                      height: 2,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ).animate().scaleX(
                      duration: 500.ms,
                      delay: (delay + 800).ms,
                      curve: Curves.easeOutBack,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: TuuurTheme.brandLightGray,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: TuuurTheme.brandGray,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .shimmer(delay: (delay + 1000).ms, duration: 1500.ms);
  }
}
