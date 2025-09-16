import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';

/// Avatar Picker identique à Vue.js avec API Dicebear
/// Équivalent à AvatarPicker.vue avec même seeds et fonctionnalités
class AvatarPickerWidget extends StatefulWidget {
  final String currentAvatar;
  final Function(String) onAvatarSelected;

  const AvatarPickerWidget({
    super.key,
    required this.currentAvatar,
    required this.onAvatarSelected,
  });

  @override
  State<AvatarPickerWidget> createState() => _AvatarPickerWidgetState();
}

class _AvatarPickerWidgetState extends State<AvatarPickerWidget> {
  late String selectedAvatar;
  final TextEditingController _urlController = TextEditingController();
  String _urlPreview = '';

  // Seeds identiques à Vue.js AvatarPicker.vue
  final List<String> seeds = [
    'Renard',
    'Panda',
    'Tigre',
    'Loutre',
    'Koala',
    'Aigle',
    'Lynx',
    'Loup',
    'Cerf',
    'Bison',
  ];

  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.currentAvatar;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  /// Génère l'URL Dicebear identique à Vue.js
  String urlForSeed(String seed) {
    final encodedSeed = Uri.encodeComponent(seed);
    return 'https://api.dicebear.com/9.x/adventurer-neutral/svg?seed=$encodedSeed';
  }

  /// Sélectionne un avatar aléatoire comme dans Vue.js
  void randomize() {
    final randomIndex =
        (seeds.length * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000)
            .floor();
    final randomSeed = seeds[randomIndex];
    setState(() {
      selectedAvatar = urlForSeed(randomSeed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: TuuurStyles.gamingCard.copyWith(
          border: Border.all(
            color: TuuurTheme.brandPurple.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header identique à Vue.js
            _buildHeader(),

            // Grid d'avatars Dicebear
            Expanded(child: _buildAvatarGrid()),

            // Section URL personnalisée
            _buildCustomUrlSection(),

            // Footer avec boutons
            _buildFooter(),
          ],
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const Text(
            'Choisir un avatar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: TuuurTheme.brandLightGray,
            ),
          ),
          const Spacer(),
          GamingButtonGhost(text: 'Aléatoire', onPressed: randomize),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: TuuurStyles.pill,
              child: const Icon(
                Icons.close,
                color: TuuurTheme.brandLightGray,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: seeds.length,
        itemBuilder: (context, index) {
          final seed = seeds[index];
          final avatarUrl = urlForSeed(seed);
          final isSelected = selectedAvatar == avatarUrl;

          return GestureDetector(
            onTap: () => setState(() => selectedAvatar = avatarUrl),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(
                  color: isSelected
                      ? TuuurTheme.brandPurple
                      : TuuurTheme.brandGray.withOpacity(0.3),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: TuuurTheme.brandPurple.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: TuuurTheme.brandDarkGray,
                                child: const Icon(
                                  Icons.person,
                                  color: TuuurTheme.brandGray,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      seed,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: TuuurTheme.brandDark,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 50).ms, duration: 300.ms);
        },
      ),
    );
  }

  Widget _buildCustomUrlSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Depuis une URL',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: TuuurTheme.brandLightGray,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _urlController,
                  style: const TextStyle(color: TuuurTheme.brandLightGray),
                  decoration: InputDecoration(
                    hintText: 'https://exemple.com/avatar.png',
                    hintStyle: TextStyle(
                      color: TuuurTheme.brandGray.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: TuuurTheme.brandDarkGray.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: TuuurTheme.brandGray.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: TuuurTheme.brandGray.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: TuuurTheme.brandPurple,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _urlPreview =
                          value.isNotEmpty && Uri.tryParse(value) != null
                          ? value
                          : '';
                    });
                  },
                ),
              ),
              if (_urlPreview.isNotEmpty) ...[
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: TuuurTheme.brandGray.withOpacity(0.3),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.network(
                      _urlPreview,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: TuuurTheme.brandDarkGray,
                        child: const Icon(
                          Icons.broken_image,
                          color: TuuurTheme.brandGray,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GamingButtonSecondary(
                  text: 'Utiliser',
                  onPressed: () => setState(() => selectedAvatar = _urlPreview),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GamingButtonGhost(
            text: 'Annuler',
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          GamingButtonPrimary(
            text: 'Valider',
            onPressed: () {
              widget.onAvatarSelected(selectedAvatar);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
