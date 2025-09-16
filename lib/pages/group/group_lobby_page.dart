import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';
import 'group_mode_page.dart';
import 'qr_preview_widget.dart';

class GroupLobbyPage extends StatefulWidget {
  final GroupLobbyData lobby;
  final VoidCallback onBack;

  const GroupLobbyPage({super.key, required this.lobby, required this.onBack});

  @override
  State<GroupLobbyPage> createState() => _GroupLobbyPageState();
}

class _GroupLobbyPageState extends State<GroupLobbyPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header - matching Vue.js exactly
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                const Text(
                  'Lobby',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: TuuurTheme.brandLightGray,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: TuuurStyles.pill.copyWith(
                    color: TuuurTheme.brandGreen.withOpacity(0.2),
                  ),
                  child: const Text(
                    'En attente d\'hôte',
                    style: TextStyle(
                      color: TuuurTheme.brandGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: TuuurStyles.pill,
                  child: const Text(
                    'Code',
                    style: TextStyle(
                      color: TuuurTheme.brandLightGray,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: TuuurTheme.brandDarkGray.withOpacity(0.5),
                    border: Border.all(
                      color: TuuurTheme.brandPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    widget.lobby.code,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: TuuurTheme.brandLightGray,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn().slideX(begin: -0.3),
        const SizedBox(height: 24),

        // Quick parameters chips - matching Vue.js exactly
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildParameterChip(
              'Catégories: ${widget.lobby.categories.join(', ')}',
            ),
            _buildParameterChip('Questions: ${widget.lobby.questions}'),
            _buildParameterChip(
              'Mélanger: ${widget.lobby.shuffle ? 'Oui' : 'Non'}',
            ),
            if (widget.lobby.specifics.isNotEmpty)
              _buildParameterChip('Spécifiques: ${widget.lobby.specifics}'),
          ],
        ),
        const SizedBox(height: 32),

        // Content - matching Vue.js layout exactly
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Players focus panel - matching Vue.js md:col-span-8
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: TuuurStyles.gamingCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Joueurs',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandLightGray,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: TuuurStyles.pill,
                          child: Text(
                            '${widget.lobby.players.length} connectés',
                            style: const TextStyle(
                              color: TuuurTheme.brandPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Players list matching Vue.js grid layout
                    ...widget.lobby.players.map(
                      (player) => _buildPlayerTile(player),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),

            // Right: QR and actions - matching Vue.js md:col-span-4
            Expanded(
              child: Column(
                children: [
                  // QR Code section - matching Vue.js
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: TuuurStyles.gamingCard,
                    child: Column(
                      children: [
                        const Text(
                          'Rejoindre via code',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandLightGray,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Code',
                                  style: TextStyle(
                                    color: TuuurTheme.brandGray,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.lobby.code,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: TuuurTheme.brandLightGray,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                            GamingButtonSecondary(
                              text: 'Copier',
                              onPressed: () {
                                // Copy functionality
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        QRPreviewWidget(text: widget.lobby.code, size: 220),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Actions section - matching Vue.js exactly
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: TuuurStyles.gamingCard,
                    child: Column(
                      children: [
                        const Text(
                          'Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandLightGray,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GamingButtonSecondary(
                                text: 'Quitter',
                                onPressed: widget.onBack,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GamingButtonPrimary(
                                text: 'Lancer la partie',
                                onPressed: null, // Disabled like in Vue.js
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lecture seule (démo) — l\'hôte peut lancer lorsqu\'il sera prêt.',
                          style: TextStyle(
                            color: TuuurTheme.brandGray,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Method to build parameter chips - matching Vue.js design
  Widget _buildParameterChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: TuuurStyles.pill,
      child: Text(
        text,
        style: const TextStyle(
          color: TuuurTheme.brandLightGray,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPlayerTile(GroupPlayer player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TuuurTheme.brandPurple.withOpacity(0.2)),
        color: TuuurTheme.brandDarkGray.withOpacity(0.3),
      ),
      child: Row(
        children: [
          // Player aura effect like in Vue.js
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: TuuurTheme.brandPurple.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: TuuurTheme.brandPurple.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(player.emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: TuuurTheme.brandLightGray,
                  ),
                ),
                Text(
                  'ID #${player.id}',
                  style: const TextStyle(
                    color: TuuurTheme.brandGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: TuuurStyles.pill,
            child: Text(
              player.status,
              style: const TextStyle(
                color: TuuurTheme.brandPurple,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
