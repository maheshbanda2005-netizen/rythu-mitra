import 'package:flutter/material.dart';
import '../core/widgets/custom_nav_bar.dart';
import '../core/widgets/modern_animations.dart';
import '../core/localization/app_localizations.dart';
import 'home/home_screen.dart';
import 'crops/crop_list_screen.dart';
import 'market/market_screen.dart';
import 'diagnosis/ai_diagnosis_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final int initialTab;

  const MainShell({super.key, this.initialTab = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    CropListScreen(),
    MarketScreen(),
    AIDiagnosisScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final navItems = [
      NavBarItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: context.tr('home'),
      ),
      NavBarItem(
        icon: Icons.eco_outlined,
        selectedIcon: Icons.eco_rounded,
        label: context.tr('crops'),
      ),
      NavBarItem(
        icon: Icons.currency_rupee_rounded,
        selectedIcon: Icons.currency_rupee_rounded,
        label: context.tr('market'),
      ),
      NavBarItem(
        icon: Icons.document_scanner_outlined,
        selectedIcon: Icons.document_scanner_rounded,
        label: context.tr('diagnose'),
      ),
      NavBarItem(
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        label: context.tr('profile'),
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: ModernAnimations.pageTransition,
        switchInCurve: ModernAnimations.defaultCurve,
        switchOutCurve: ModernAnimations.defaultCurve,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: IndexedStack(
          key: ValueKey<int>(_currentIndex),
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: navItems,
      ),
    );
  }
}
