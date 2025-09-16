import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';
import '../../widgets/navigation_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Matching Vue.js exactly - simple auth state switch
  bool isAuthenticated = false;

  // User data when authenticated
  String playerName = 'sanbiX';
  String playerId = '#123456';
  int level = 12;
  int elo = 1210;
  String status = 'Actif';

  String get avatarUrl {
    final seed = Uri.encodeComponent(playerName);
    return 'https://api.dicebear.com/9.x/adventurer-neutral/svg?seed=$seed';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TuuurTheme.brandDark,
      appBar: const NavigationHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Header matching Vue.js exactly
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('👤', style: TextStyle(fontSize: 28)),
                    SizedBox(width: 8),
                    Text(
                      'Profil Joueur',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: TuuurTheme.brandLightGray,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: TuuurTheme.brandCyan.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: TuuurTheme.brandCyan.withOpacity(0.3),
                    ),
                  ),
                  child: const Text(
                    'Aperçu — UI uniquement',
                    style: TextStyle(
                      color: TuuurTheme.brandLightGray,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Main content with demo status switcher
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left sidebar - Demo status switcher
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: TuuurStyles.gamingCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🔧', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 8),
                            Text(
                              'Statut de Démo',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: TuuurTheme.brandLightGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildStatusButton(
                              '🔓 Déconnecté',
                              !isAuthenticated,
                              () => setState(() => isAuthenticated = false),
                            ),
                            const SizedBox(width: 12),
                            _buildStatusButton(
                              '🔐 Connecté',
                              isAuthenticated,
                              () => setState(() => isAuthenticated = true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Basculez pour voir les deux interfaces gaming.',
                          style: TextStyle(
                            color: TuuurTheme.brandGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // Right main panel
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: TuuurStyles.gamingCard,
                    child: isAuthenticated
                        ? _buildAuthenticatedView()
                        : _buildUnauthenticatedView(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(
    String text,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: isSelected
            ? TuuurTheme.brandPurple.withOpacity(0.2)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? TuuurTheme.brandPurple.withOpacity(0.4)
                : TuuurTheme.brandPurple.withOpacity(0.2),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: TuuurTheme.brandLightGray,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildUnauthenticatedView() {
    return Column(
      children: [
        // Gaming icon and welcome text
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: TuuurTheme.brandOrange.withOpacity(0.2),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.gamepad,
                  color: TuuurTheme.brandOrange,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rejoignez l\'Aventure',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: TuuurTheme.brandLightGray,
                    ),
                  ),
                  Text(
                    'Sauvegardez votre historique, suivez votre rang et personnalisez votre avatar gaming.',
                    style: TextStyle(color: TuuurTheme.brandGray, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Features grid
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TuuurTheme.brandPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TuuurTheme.brandPurple.withOpacity(0.2),
                  ),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.chartBar,
                          color: TuuurTheme.brandPurple,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Statistiques',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandPurple,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Historique détaillé des parties',
                      style: TextStyle(
                        color: TuuurTheme.brandGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TuuurTheme.brandGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TuuurTheme.brandGreen.withOpacity(0.2),
                  ),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.trophy,
                          color: TuuurTheme.brandGreen,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Classement',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandGreen,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Système de rang compétitif',
                      style: TextStyle(
                        color: TuuurTheme.brandGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Action buttons
        Row(
          children: [
            GamingButtonPrimary(
              text: '🚀 Se connecter',
              onPressed: () => context.push('/login'),
            ),
            const SizedBox(width: 12),
            GamingButtonSecondary(
              text: '🔗 Créer un compte',
              onPressed: () => context.push('/register'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthenticatedView() {
    return Column(
      children: [
        // User profile header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TuuurTheme.brandPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TuuurTheme.brandPurple.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              // Avatar with status indicator
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: TuuurTheme.brandPurple,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        avatarUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: TuuurTheme.brandPurple.withOpacity(0.2),
                          child: const Icon(
                            Icons.person,
                            color: TuuurTheme.brandPurple,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: TuuurTheme.brandGreen,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: TuuurTheme.brandDarkGray,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.fire,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: TuuurTheme.brandLightGray,
                      ),
                    ),
                    Text(
                      'Joueur $playerId',
                      style: const TextStyle(
                        color: TuuurTheme.brandGray,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: TuuurTheme.brandGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: TuuurTheme.brandGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: TuuurTheme.brandYellow.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Niveau $level',
                            style: const TextStyle(
                              color: TuuurTheme.brandYellow,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Elo badge and modify button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: TuuurTheme.brandOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: TuuurTheme.brandOrange.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.trophy,
                          color: TuuurTheme.brandOrange,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Élo: $elo',
                          style: const TextStyle(
                            color: TuuurTheme.brandOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GamingButtonSecondary(
                    text: '⚙️ Modifier avatar',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité en démo'),
                          backgroundColor: TuuurTheme.brandOrange,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Security section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TuuurTheme.brandDarkGray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TuuurTheme.brandPurple.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TuuurTheme.brandCyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('🔒', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sécurité',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: TuuurTheme.brandLightGray,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Réinitialisez votre mot de passe',
                      style: TextStyle(
                        color: TuuurTheme.brandGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GamingButtonSecondary(
                text: '🔄 Réinitialiser',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonctionnalité en démo'),
                      backgroundColor: TuuurTheme.brandOrange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Game history
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('📈', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text(
                  'Historique des parties',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: TuuurTheme.brandLightGray,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Dernières sessions',
                  style: TextStyle(color: TuuurTheme.brandCyan, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: TuuurStyles.gamingCard,
              child: const Row(
                children: [
                  Text(
                    'S',
                    style: TextStyle(
                      color: TuuurTheme.brandGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solo',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandLightGray,
                          ),
                        ),
                        Text(
                          'Score 870',
                          style: TextStyle(
                            color: TuuurTheme.brandGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Aujourd\'hui à 12:45',
                        style: TextStyle(
                          color: TuuurTheme.brandGray,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '+12',
                        style: TextStyle(
                          color: TuuurTheme.brandGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
