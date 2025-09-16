import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';
import 'qr_preview_widget.dart';

class QuizCategory {
  final String id;
  final String name;
  final IconData icon;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class GroupCreatePage extends StatefulWidget {
  final VoidCallback onBack;
  final Function({
    required List<String> categories,
    required int questions,
    required bool shuffle,
    String? specifics,
  })
  onCreated;

  const GroupCreatePage({
    super.key,
    required this.onBack,
    required this.onCreated,
  });

  @override
  State<GroupCreatePage> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage> {
  final Set<String> selectedCategories = {'general'};
  int questions = 10;
  bool shuffle = true;
  String specifics = '';
  String roomCode = 'TUR-${DateTime.now().millisecond % 10000}';

  final List<QuizCategory> categories = const [
    QuizCategory(id: 'general', name: 'Général', icon: FontAwesomeIcons.globe),
    QuizCategory(id: 'science', name: 'Sciences', icon: FontAwesomeIcons.flask),
    QuizCategory(
      id: 'history',
      name: 'Histoire',
      icon: FontAwesomeIcons.landmark,
    ),
    QuizCategory(id: 'sport', name: 'Sport', icon: FontAwesomeIcons.football),
    QuizCategory(id: 'cinema', name: 'Cinéma', icon: FontAwesomeIcons.film),
    QuizCategory(id: 'music', name: 'Musique', icon: FontAwesomeIcons.music),
    QuizCategory(id: 'art', name: 'Art', icon: FontAwesomeIcons.palette),
    QuizCategory(
      id: 'geo',
      name: 'Géographie',
      icon: FontAwesomeIcons.earthAmericas,
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

  void incrementQuestions() {
    if (questions < 20) {
      setState(() => questions += 5);
    }
  }

  void decrementQuestions() {
    if (questions > 5) {
      setState(() => questions -= 5);
    }
  }

  void createRoom() {
    final selectedCategoryNames = categories
        .where((cat) => selectedCategories.contains(cat.id))
        .map((cat) => cat.name)
        .toList();

    widget.onCreated(
      categories: selectedCategoryNames,
      questions: questions,
      shuffle: shuffle,
      specifics: specifics.isNotEmpty ? specifics : null,
    );
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
            const Text(
              'Créer une partie',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: TuuurTheme.brandLightGray,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: TuuurStyles.pill,
              child: const Text(
                'Partagez le code avec vos amis',
                style: TextStyle(color: TuuurTheme.brandGray, fontSize: 12),
              ),
            ),
          ],
        ).animate().fadeIn().slideX(begin: -0.3),
        const SizedBox(height: 32),

        // Content Grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Quiz Settings
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: TuuurStyles.gamingCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paramètres du quiz',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: TuuurTheme.brandLightGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choisissez les options pour la partie.',
                      style: TextStyle(color: TuuurTheme.brandGray),
                    ),
                    const SizedBox(height: 24),

                    // Categories
                    const Text(
                      'Catégories',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: TuuurTheme.brandLightGray,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: categories.map((category) {
                        final isSelected = selectedCategories.contains(
                          category.id,
                        );
                        return GestureDetector(
                          onTap: () => toggleCategory(category.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: isSelected
                                  ? TuuurTheme.brandPurple
                                  : TuuurTheme.brandDarkGray.withOpacity(0.5),
                              border: Border.all(
                                color: isSelected
                                    ? TuuurTheme.brandPurple
                                    : TuuurTheme.brandPurple.withOpacity(0.3),
                              ),
                              boxShadow: isSelected
                                  ? TuuurTheme.neonShadow
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
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Questions and Shuffle
                    Row(
                      children: [
                        // Questions Count
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Nombre de questions',
                                    style: TextStyle(
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
                                      '$questions',
                                      style: const TextStyle(
                                        color: TuuurTheme.brandLightGray,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: decrementQuestions,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: TuuurStyles.pill,
                                      child: const Text(
                                        '−',
                                        style: TextStyle(
                                          color: TuuurTheme.brandLightGray,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: questions.toDouble(),
                                      min: 5,
                                      max: 20,
                                      divisions: 3,
                                      activeColor: TuuurTheme.brandPurple,
                                      onChanged: (value) => setState(() {
                                        questions = value.round();
                                      }),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: incrementQuestions,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: TuuurStyles.pill,
                                      child: const Text(
                                        '＋',
                                        style: TextStyle(
                                          color: TuuurTheme.brandLightGray,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Shuffle
                        Row(
                          children: [
                            Checkbox(
                              value: shuffle,
                              onChanged: (value) => setState(() {
                                shuffle = value ?? true;
                              }),
                              activeColor: TuuurTheme.brandPurple,
                            ),
                            const Text(
                              'Mélanger les questions',
                              style: TextStyle(
                                color: TuuurTheme.brandLightGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Specifics
                    const Text(
                      'Catégories spécifiques (champ libre)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: TuuurTheme.brandLightGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => setState(() => specifics = value),
                      style: const TextStyle(color: TuuurTheme.brandLightGray),
                      decoration: InputDecoration(
                        hintText:
                            'Ex: Mythologie nordique, Programmation fonctionnelle…',
                        hintStyle: const TextStyle(color: TuuurTheme.brandGray),
                        filled: true,
                        fillColor: TuuurTheme.brandDarkGray.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: TuuurTheme.brandPurple.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: TuuurTheme.brandPurple,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Facultatif — visible par les joueurs.',
                      style: TextStyle(
                        color: TuuurTheme.brandGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.3),
            ),
            const SizedBox(width: 24),

            // Right: Room Info
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: TuuurStyles.gamingCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Salon',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: TuuurTheme.brandLightGray,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Room Code
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
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              roomCode,
                              style: const TextStyle(
                                fontSize: 24,
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
                            // TODO: Copy to clipboard
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // QR Code
                    Center(child: QRPreviewWidget(text: roomCode, size: 180)),
                    const SizedBox(height: 24),

                    // Connected Players
                    const Text(
                      'Joueurs connectés',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: TuuurTheme.brandLightGray,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Mock players
                    Column(
                      children: [
                        _buildPlayerTile('🦊', 'Alice'),
                        const SizedBox(height: 8),
                        _buildPlayerTile('🐼', 'Ben'),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      child: GamingButtonPrimary(
                        text: 'Créer la partie',
                        onPressed: createRoom,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.3),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Back Button
        GamingButtonGhost(text: 'Retour', onPressed: widget.onBack),
      ],
    );
  }

  Widget _buildPlayerTile(String emoji, String name) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: TuuurTheme.brandPurple.withOpacity(0.2),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: TuuurTheme.brandLightGray,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: TuuurStyles.pill,
          child: const Text(
            'Prêt',
            style: TextStyle(
              color: TuuurTheme.brandGreen,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
