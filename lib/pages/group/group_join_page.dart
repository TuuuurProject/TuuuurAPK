import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/gaming_widgets.dart';

class GroupJoinPage extends StatefulWidget {
  final VoidCallback onBack;
  final Function({required String code}) onJoined;

  const GroupJoinPage({
    super.key,
    required this.onBack,
    required this.onJoined,
  });

  @override
  State<GroupJoinPage> createState() => _GroupJoinPageState();
}

class _GroupJoinPageState extends State<GroupJoinPage> {
  final TextEditingController codeController = TextEditingController();
  bool isValidCode = false;

  @override
  void initState() {
    super.initState();
    codeController.addListener(_validateCode);
  }

  void _validateCode() {
    final code = codeController.text.trim().toUpperCase();
    setState(() {
      isValidCode = code.startsWith('TUR-') && code.length >= 8;
    });
  }

  void joinGame() {
    if (isValidCode) {
      widget.onJoined(code: codeController.text.trim().toUpperCase());
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

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
            const Text(
              'Rejoindre une partie',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: TuuurTheme.brandLightGray,
              ),
            ),
          ],
        ).animate().fadeIn().slideX(begin: -0.3),
        const SizedBox(height: 32),

        // Main Content
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: TuuurStyles.gamingCard,
            child: Column(
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: TuuurTheme.brandOrange.withOpacity(0.2),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.rocket,
                      color: TuuurTheme.brandOrange,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Entrez le code de la partie',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: TuuurTheme.brandLightGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                const Text(
                  'Demandez le code à l\'organisateur ou scannez le QR code.',
                  style: TextStyle(color: TuuurTheme.brandGray, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Code Input
                TextField(
                  controller: codeController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TuuurTheme.brandLightGray,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    hintText: 'TUR-0000',
                    hintStyle: TextStyle(
                      color: TuuurTheme.brandGray.withOpacity(0.5),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                    filled: true,
                    fillColor: TuuurTheme.brandDarkGray.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: TuuurTheme.brandOrange.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: TuuurTheme.brandOrange,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isValidCode
                            ? TuuurTheme.brandGreen
                            : TuuurTheme.brandOrange.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    suffixIcon: isValidCode
                        ? const Icon(
                            Icons.check_circle,
                            color: TuuurTheme.brandGreen,
                          )
                        : null,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: (_) => joinGame(),
                ),
                const SizedBox(height: 24),

                // Join Button
                SizedBox(
                  width: double.infinity,
                  child: GamingButtonPrimary(
                    text: 'Rejoindre',
                    onPressed: isValidCode ? joinGame : null,
                  ),
                ),
                const SizedBox(height: 16),

                // QR Scanner Button
                SizedBox(
                  width: double.infinity,
                  child: GamingButtonSecondary(
                    text: 'Scanner QR Code',
                    onPressed: () {
                      // TODO: Implement QR scanner
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Scanner QR non disponible en démo'),
                          backgroundColor: TuuurTheme.brandOrange,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: TuuurTheme.brandGreen.withOpacity(0.1),
                    border: Border.all(
                      color: TuuurTheme.brandGreen.withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.lightbulb,
                        color: TuuurTheme.brandGreen,
                        size: 16,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Le code commence toujours par "TUR-" suivi de 4 chiffres',
                          style: TextStyle(
                            color: TuuurTheme.brandGreen,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
      ],
    );
  }
}
