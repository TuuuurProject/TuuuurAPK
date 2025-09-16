import 'package:flutter/material.dart';
import '../../theme/tuuuur_theme.dart';
import '../../widgets/navigation_header.dart';
import '../../navigation/app_router.dart';
import 'competitive_select_page.dart';
import 'matchmaking_page.dart';
import 'duel_1v1_page.dart';

enum OnlineStep { select, search, duel }

class OnlineModePage extends StatefulWidget {
  const OnlineModePage({super.key});

  @override
  State<OnlineModePage> createState() => _OnlineModePageState();
}

class _OnlineModePageState extends State<OnlineModePage> {
  OnlineStep step = OnlineStep.select;
  List<String> selectedCategories = ['Général'];

  void goSearch(List<String> categories) {
    setState(() {
      selectedCategories = categories;
      step = OnlineStep.search;
    });
  }

  void goDuel() {
    setState(() {
      step = OnlineStep.duel;
    });
  }

  void goBack() {
    setState(() {
      step = OnlineStep.select;
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
      case OnlineStep.select:
        return CompetitiveSelectPage(
          onBack: () => context.goBack(),
          onSearch: goSearch,
        );
      case OnlineStep.search:
        return MatchmakingPage(
          categories: selectedCategories,
          onBack: goBack,
          onDuel: goDuel,
        );
      case OnlineStep.duel:
        return Duel1v1Page(
          categories: selectedCategories,
          onBack: goBack,
          onStart: () {
            // TODO: Start the actual quiz
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Démarrage du duel...'),
                backgroundColor: TuuurTheme.brandOrange,
              ),
            );
          },
        );
    }
  }
}
