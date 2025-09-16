import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navigation_header.dart';
import '../../navigation/app_router.dart';

class SoloSelectPage extends StatefulWidget {
  const SoloSelectPage({super.key});

  @override
  State<SoloSelectPage> createState() => _SoloSelectPageState();
}

class _SoloSelectPageState extends State<SoloSelectPage> {
  final Set<String> _selectedCategories = {'general'}; // Même défaut que Vue.js
  final TextEditingController _specificsController = TextEditingController();
  int _questionCount = 10;
  bool _shuffle = true;

  // Categories de quiz (équivalent au Vue component - mêmes icônes que Vue.js)
  final List<QuizCategory> _categories = [
    QuizCategory(
      id: 'general',
      name: 'Général',
      icon: FontAwesomeIcons.wandMagicSparkles,
    ), // wand-magic-sparkles
    QuizCategory(
      id: 'histoire',
      name: 'Histoire',
      icon: FontAwesomeIcons
          .buildingColumns, // buildingColumns (nouvelle version de university)
    ),
    QuizCategory(
      id: 'science',
      name: 'Science',
      icon: FontAwesomeIcons.flask,
    ), // flask - même nom que Vue.js
    QuizCategory(
      id: 'sport',
      name: 'Sport',
      icon: FontAwesomeIcons.medal, // medal
    ),
    QuizCategory(id: 'musique', name: 'Musique', icon: FontAwesomeIcons.music),
    QuizCategory(id: 'cinema', name: 'Cinéma', icon: FontAwesomeIcons.film),
    QuizCategory(id: 'art', name: 'Art', icon: FontAwesomeIcons.palette),
    QuizCategory(
      id: 'geo',
      name: 'Géographie',
      icon: FontAwesomeIcons.globe, // globe
    ),
    QuizCategory(
      id: 'tech',
      name: 'Technologie',
      icon: FontAwesomeIcons.laptopCode, // laptop-code
    ),
    QuizCategory(
      id: 'jeux',
      name: 'Jeux vidéo',
      icon: FontAwesomeIcons.gamepad,
    ),
  ];

  @override
  void dispose() {
    _specificsController.dispose();
    super.dispose();
  }

  void _toggleCategory(String categoryId) {
    setState(() {
      if (_selectedCategories.contains(categoryId)) {
        _selectedCategories.remove(categoryId);
      } else {
        _selectedCategories.add(categoryId);
      }
    });
  }

  void _startQuiz() {
    if (_selectedCategories.isEmpty) {
      ToastManager.show(
        context: context,
        message: 'Veuillez sélectionner au moins une catégorie',
        backgroundColor: TuuurTheme.brandOrange.withOpacity(0.9),
      );
      return;
    }

    GamingModal.show(
      context: context,
      title: 'Démarrer le quiz',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConfirmationRow(
            FontAwesomeIcons.bullseye,
            'Catégories:',
            _selectedCategories
                .map((id) => _categories.firstWhere((cat) => cat.id == id).name)
                .join(', '),
          ),
          const SizedBox(height: 12),
          _buildConfirmationRow(
            FontAwesomeIcons.listOl,
            'Questions:',
            '$_questionCount',
          ),
          const SizedBox(height: 12),
          _buildConfirmationRow(
            FontAwesomeIcons.shuffle,
            'Mélanger:',
            _shuffle ? 'Oui' : 'Non',
          ),
          if (_specificsController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildConfirmationRow(
              FontAwesomeIcons.lightbulb,
              'Spécifiques:',
              _specificsController.text,
            ),
          ],
        ],
      ),
      onConfirm: () {
        Navigator.of(context).pop();
        context.goSoloQuiz(
          categories: _selectedCategories.toList(),
          questions: _questionCount,
          shuffle: _shuffle,
        );
      },
    );
  }

  Widget _buildConfirmationRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaIcon(icon, color: TuuurTheme.brandPurple, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: TuuurTheme.brandLightGray,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: TuuurTheme.brandGray),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavigationHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Main content
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildCategoriesSection()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildSettingsSection()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildCategoriesSection(),
                      const SizedBox(height: 24),
                      _buildSettingsSection(),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            // Footer actions
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.bullseye,
                    color: TuuurTheme.brandPurple,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Mode Solo',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: TuuurTheme.brandLightGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        BadgeSuccess(
              text: 'Sélectionnez au moins une catégorie',
              icon: FontAwesomeIcons.lightbulb,
            )
            .animate(onPlay: (controller) => controller.repeat())
            .fade(duration: 2000.ms),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return GamingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.gamepad,
                color: TuuurTheme.brandPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Catégories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: TuuurTheme.brandLightGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Choisissez une ou plusieurs catégories pour votre aventure.',
            style: TextStyle(color: TuuurTheme.brandGray, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Grid de catégories
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return CategoryButton(
                    text: category.name,
                    icon: category.icon,
                    selected: _selectedCategories.contains(category.id),
                    onTap: () => _toggleCategory(category.id),
                  )
                  .animate(delay: (100 * index).ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.2);
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Champ spécifique
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚡ Catégories spécifiques (champ libre)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: TuuurTheme.brandLightGray,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _specificsController,
                decoration: InputDecoration(
                  hintText:
                      'Ex: Capitales d\'Afrique, Histoire de l\'art moderne…',
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
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(color: TuuurTheme.brandLightGray),
              ),
              const SizedBox(height: 4),
              const Text(
                'Facultatif — ajoutez du contexte précis pour des questions personnalisées.',
                style: TextStyle(fontSize: 12, color: TuuurTheme.brandGray),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return GamingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '⚙️ Paramètres',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: TuuurTheme.brandLightGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nombre de questions
          _buildSettingItem(
            'Nombre de questions',
            Row(
              children: [
                IconButton(
                  onPressed: _questionCount > 5
                      ? () => setState(() => _questionCount--)
                      : null,
                  icon: const Icon(Icons.remove),
                  color: TuuurTheme.brandLightGray,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: TuuurStyles.pill,
                  child: Text(
                    '$_questionCount',
                    style: const TextStyle(
                      color: TuuurTheme.brandLightGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _questionCount < 50
                      ? () => setState(() => _questionCount++)
                      : null,
                  icon: const Icon(Icons.add),
                  color: TuuurTheme.brandLightGray,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Mélanger les questions
          _buildSettingItem(
            'Mélanger les questions',
            Switch(
              value: _shuffle,
              onChanged: (value) => setState(() => _shuffle = value),
              activeColor: TuuurTheme.brandPurple,
              activeTrackColor: TuuurTheme.brandPurple.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String label, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: TuuurTheme.brandLightGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        widget,
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GamingButtonGhost(text: '← Retour', onPressed: () => context.goBack()),
        const SizedBox(width: 16),
        GamingButtonPrimary(
          text: 'Commencer l\'aventure',
          icon: FontAwesomeIcons.rocket,
          onPressed: _selectedCategories.isEmpty ? null : _startQuiz,
        ),
      ],
    );
  }
}

class QuizCategory {
  final String id;
  final String name;
  final IconData icon;

  QuizCategory({required this.id, required this.name, required this.icon});
}
