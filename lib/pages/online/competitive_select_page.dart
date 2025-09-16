import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';

class CompetitiveCategory {
  final String id;
  final String name;
  final IconData icon;

  const CompetitiveCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class CompetitiveSelectPage extends StatefulWidget {
  final VoidCallback onBack;
  final Function(List<String>) onSearch;

  const CompetitiveSelectPage({
    super.key,
    required this.onBack,
    required this.onSearch,
  });

  @override
  State<CompetitiveSelectPage> createState() => _CompetitiveSelectPageState();
}

class _CompetitiveSelectPageState extends State<CompetitiveSelectPage> {
  final Set<String> selectedCategories = {'general'};

  final List<CompetitiveCategory> categories = const [
    CompetitiveCategory(
      id: 'general',
      name: 'Général',
      icon: FontAwesomeIcons.wandMagicSparkles,
    ),
    CompetitiveCategory(
      id: 'histoire',
      name: 'Histoire',
      icon: FontAwesomeIcons.university,
    ),
    CompetitiveCategory(
      id: 'science',
      name: 'Science',
      icon: FontAwesomeIcons.flask,
    ),
    CompetitiveCategory(
      id: 'sport',
      name: 'Sport',
      icon: FontAwesomeIcons.medal,
    ),
    CompetitiveCategory(
      id: 'musique',
      name: 'Musique',
      icon: FontAwesomeIcons.music,
    ),
    CompetitiveCategory(
      id: 'cinema',
      name: 'Cinéma',
      icon: FontAwesomeIcons.film,
    ),
    CompetitiveCategory(id: 'art', name: 'Art', icon: FontAwesomeIcons.palette),
    CompetitiveCategory(
      id: 'geo',
      name: 'Géographie',
      icon: FontAwesomeIcons.globe,
    ),
  ];

  void toggleCategory(String categoryId) {
    setState(() {
      if (selectedCategories.contains(categoryId)) {
        if (selectedCategories.length > 1) {
          selectedCategories.remove(categoryId);
        }
      } else {
        selectedCategories.add(categoryId);
      }
    });
  }

  void proceed() {
    final selectedNames = categories
        .where((cat) => selectedCategories.contains(cat.id))
        .map((cat) => cat.name)
        .toList();
    widget.onSearch(selectedNames);
  }

  @override
  Widget build(BuildContext context) {
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
                  FontAwesomeIcons.fire,
                  color: TuuurTheme.brandOrange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mode Compétitif',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: TuuurTheme.brandLightGray,
                  ),
                ),
              ].animate().fadeIn(duration: 600.ms).slideX(begin: -0.3),
            ),
            Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: TuuurStyles.pill.copyWith(
                    color: TuuurTheme.brandOrange.withOpacity(0.2),
                  ),
                  child: const Text(
                    'Choisissez vos catégories favorites',
                    style: TextStyle(
                      color: TuuurTheme.brandOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms),
          ],
        ),
        const SizedBox(height: 32),

        // Main Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: TuuurStyles.gamingCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
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
                        FontAwesomeIcons.bullseye,
                        color: TuuurTheme.brandOrange,
                        size: 20,
                      ),
                    ),
                  ).animate().rotate(duration: 3000.ms, curve: Curves.linear),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.trophy,
                              color: TuuurTheme.brandOrange,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Catégories de Combat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: TuuurTheme.brandLightGray,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sélectionnez vos domaines d\'expertise pour des duels équilibrés.',
                          style: TextStyle(color: TuuurTheme.brandGray),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Categories Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: categories.map((category) {
                  final isSelected = selectedCategories.contains(category.id);
                  return GestureDetector(
                    onTap: () => toggleCategory(category.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSelected
                            ? TuuurTheme.brandOrange
                            : TuuurTheme.brandDarkGray.withOpacity(0.5),
                        border: Border.all(
                          color: isSelected
                              ? TuuurTheme.brandOrange
                              : TuuurTheme.brandOrange.withOpacity(0.3),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: TuuurTheme.brandOrange.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            category.icon,
                            color: isSelected
                                ? Colors.white
                                : TuuurTheme.brandLightGray,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : TuuurTheme.brandLightGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(
                    delay: (categories.indexOf(category) * 100).ms,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Competitive Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: TuuurTheme.brandOrange.withOpacity(0.1),
                  border: Border.all(
                    color: TuuurTheme.brandOrange.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('⚡', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Text(
                          'Mode Compétitif',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: TuuurTheme.brandOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Affrontez des joueurs de niveau similaire dans des duels rapides. Plus vous gagnez, plus votre rang augmente !',
                      style: TextStyle(
                        fontSize: 14,
                        color: TuuurTheme.brandGray,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildInfoItem(
                          'Matchmaking équilibré',
                          TuuurTheme.brandGreen,
                        ),
                        const SizedBox(width: 16),
                        _buildInfoItem(
                          'Rang dynamique',
                          TuuurTheme.brandPurple,
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GamingButtonGhost(text: '← Retour', onPressed: widget.onBack),
                  const SizedBox(width: 12),
                  GamingButtonSecondary(
                    text: '🔍 Lancer la recherche',
                    onPressed: selectedCategories.isNotEmpty ? proceed : null,
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildInfoItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: TuuurTheme.brandGray, fontSize: 12),
        ),
      ],
    );
  }
}
