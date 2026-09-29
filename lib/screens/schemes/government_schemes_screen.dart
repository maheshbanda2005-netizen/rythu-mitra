import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/scheme_model.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';

class GovernmentSchemesScreen extends StatefulWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  State<GovernmentSchemesScreen> createState() => _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState extends State<GovernmentSchemesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Subsidy Calculator state
  String _selectedEquipment = 'drip';
  String _farmerCategory = 'small';
  double _farmAcres = 2.0;

  // Tracked user applications
  final List<Map<String, dynamic>> _myApplications = [
    {
      'id': 'RB-2026-TL-84920',
      'schemeId': 's_rythu_bharosa',
      'schemeName': 'రైతు భరోసా పెట్టుబడి సాయం',
      'schemeNameEn': 'Rythu Bharosa Investment Support',
      'schemeNameHi': 'रैतु भरोसा किसान निवेश सहायता',
      'appliedDate': '12/05/2026',
      'status': 'approved',
      'amount': '₹15,000 / ఎకరా',
      'amountEn': '₹15,000 / Acre',
      'portal': 'https://rythubharosa.telangana.gov.in',
    },
    {
      'id': 'TSMIP-DRIP-99412',
      'schemeId': 's_tsmip_drip',
      'schemeName': 'తెలంగాణ సూక్ష్మ సేద్య ప్రాజెక్ట్ (డ్రిప్)',
      'schemeNameEn': 'TSMIP Micro Irrigation Drip',
      'schemeNameHi': 'टीएसएमआईपी सूक्ष्म सिंचाई ड्रिप',
      'appliedDate': '28/05/2026',
      'status': 'verification',
      'amount': '90% సబ్సిడీ',
      'amountEn': '90% Subsidy',
      'portal': 'https://tsmip.telangana.gov.in',
    },
    {
      'id': 'PMK-17-IN-40192',
      'schemeId': 's_pm_kisan',
      'schemeName': 'పీఎం-కిసాన్ సమ్మాన్ నిధి',
      'schemeNameEn': 'PM-Kisan Samman Nidhi',
      'schemeNameHi': 'पीएम-किसान सम्मान निधि',
      'appliedDate': '10/04/2026',
      'status': 'approved',
      'amount': '₹2,000 (17వ కిస్తీ)',
      'amountEn': '₹2,000 (17th Installment)',
      'portal': 'https://pmkisan.gov.in',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;
    final allSchemes = AgriDataService.schemes;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('schemesTitle'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              context.tr('schemesSub'),
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: isDark ? const Color(0xFF14241B) : Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: [
                Tab(text: context.tr('telanganaSchemes')),
                Tab(text: context.tr('centralSchemes')),
                Tab(text: context.tr('allSchemes')),
                Tab(text: context.tr('subsidyFinder')),
                Tab(text: context.tr('myApplications')),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 0: Telangana Priority Schemes
          _buildSchemesListTab(
            context,
            allSchemes.where((s) => s.state == 'Telangana').toList(),
            isDark,
            lang,
            showHeroBanner: true,
          ),
          // Tab 1: Central Government Schemes
          _buildSchemesListTab(
            context,
            allSchemes.where((s) => s.level == 'Central').toList(),
            isDark,
            lang,
            showHeroBanner: false,
          ),
          // Tab 2: All Verified Schemes
          _buildSchemesListTab(
            context,
            allSchemes,
            isDark,
            lang,
            showHeroBanner: false,
          ),
          // Tab 3: Interactive Subsidy Calculator
          _buildSubsidyCalculatorTab(context, isDark, lang),
          // Tab 4: My Applications Status Tracker
          _buildMyApplicationsTab(context, isDark, lang),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TAB: SCHEMES LIST WITH SEARCH, HERO SCREENING BANNER & CATEGORY CHIPS
  // --------------------------------------------------------------------------
  Widget _buildSchemesListTab(
    BuildContext context,
    List<GovtSchemeModel> schemesPool,
    bool isDark,
    String lang, {
    required bool showHeroBanner,
  }) {
    // Apply search filter
    var filtered = schemesPool.where((s) {
      if (_searchQuery.trim().isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final name = s.getLocalizedName(lang).toLowerCase();
      final nameEn = s.nameEn.toLowerCase();
      final dept = s.getLocalizedDepartment(lang).toLowerCase();
      final benefits = s.getLocalizedBenefits(lang).toLowerCase();
      return name.contains(query) || nameEn.contains(query) || dept.contains(query) || benefits.contains(query);
    }).toList();

    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered.where((s) => s.categoryKey == _selectedCategory).toList();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Smart Search Bar with Voice Assist button
        _buildSearchBar(context, isDark, lang),
        const SizedBox(height: 12),

        // Hero AI Eligibility Screening Banner
        if (showHeroBanner) ...[
          _buildAiScreeningBanner(context, isDark, lang),
          const SizedBox(height: 14),
        ],

        // Category Filter Chips
        _buildCategoryChips(context, schemesPool, isDark, lang),
        const SizedBox(height: 14),

        // Results Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang == 'te'
                  ? 'ధృవీకరించబడిన పథకాలు (${filtered.length})'
                  : (lang == 'hi' ? 'सत्यापित योजनाएं (${filtered.length})' : 'Verified Schemes (${filtered.length})'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            Row(
              children: [
                const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  context.tr('verifiedOfficial'),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Schemes List
        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Icon(Icons.search_off_rounded, size: 44, color: Colors.grey),
                const SizedBox(height: 10),
                Text(
                  lang == 'te' ? 'పథకాలు ఏవీ కనుగొనబడలేదు' : (lang == 'hi' ? 'कोई योजना नहीं मिली' : 'No schemes found'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  lang == 'te'
                      ? 'శోధన పదాన్ని లేదా ఎంచుకున్న విభాగాన్ని మార్చండి'
                      : (lang == 'hi' ? 'खोज शब्द या श्रेणी बदलें' : 'Try modifying your search or filter'),
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
                ),
              ],
            ),
          )
        else
          ...filtered.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildSchemeCard(context, item, isDark, lang),
              )),

        const SizedBox(height: 20),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // SMART SEARCH BAR & VOICE SEARCH SIMULATION
  // --------------------------------------------------------------------------
  Widget _buildSearchBar(BuildContext context, bool isDark, String lang) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16251C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF294232) : const Color(0xFFE2EBE0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: context.tr('searchSchemesPlaceholder'),
          hintStyle: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.black45),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              IconButton(
                icon: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 22),
                onPressed: () => _showVoiceSearchModal(context, isDark, lang),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // VOICE SEARCH MODAL (Telugu, Hindi & English)
  // --------------------------------------------------------------------------
  void _showVoiceSearchModal(BuildContext context, bool isDark, String lang) {
    final suggestions = lang == 'te'
        ? [
            'రైతు భరోసా పథకం వివరాలు',
            'డ్రిప్ ఇరిగేషన్ సబ్సిడీ ఎంత?',
            'పీఎం కిసాన్ డబ్బులు ఎప్పుడు వస్తాయి?',
            '4% వడ్డీతో పంట రుణాలు (KCC)',
            'ఉచిత నేల పరీక్ష (సాయిల్ హెల్త్)',
          ]
        : (lang == 'hi'
            ? [
                'रैतु भरोसा योजना का लाभ',
                'ड्रिप सिंचाई पर कितनी सब्सिडी है?',
                'पीएम किसान किस्त स्थिति',
                '4% ब्याज पर किसान क्रेडिट कार्ड',
                'मुफ्त मिट्टी जांच कार्ड',
              ]
            : [
                'Tell me about Rythu Bharosa',
                'What is the drip irrigation subsidy?',
                'How to get PM-Kisan installment?',
                'Kisan Credit Card at 4% interest',
                'Free Soil Health Card test',
              ]);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF14241B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic_rounded, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 14),
            Text(
              lang == 'te'
                  ? 'మీ స్వరం ద్వారా పథకాలను వెతకండి'
                  : (lang == 'hi' ? 'अपनी आवाज़ से योजनाएं खोजें' : 'Search Schemes with Your Voice'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              lang == 'te'
                  ? 'క్రింది వాక్యాలలో ఒకదానిని తాకండి లేదా మాట్లాడండి:'
                  : (lang == 'hi' ? 'नीचे दिए गए सुझावों पर टैप करें:' : 'Tap any spoken query below to search:'),
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(height: 16),
            ...suggestions.map((sug) => Material(
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.record_voice_over_rounded, color: AppColors.primary, size: 18),
                    title: Text(sug, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _searchQuery = sug.split(' ').first;
                        _searchController.text = _searchQuery;
                      });
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HERO BANNER: "FIND SCHEMES FOR ME" AI SCREENING
  // --------------------------------------------------------------------------
  Widget _buildAiScreeningBanner(BuildContext context, bool isDark, String lang) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E3A2B), const Color(0xFF13281E)]
              : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF2D573F) : const Color(0xFFA5D6A7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('findSchemesForMe'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      context.tr('findSchemesForMeSub'),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAiScreeningModal(context, isDark, lang),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.manage_search_rounded, size: 18),
              label: Text(
                context.tr('checkEligibility'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // AI SCREENING MODAL SHEET (Interactive Acres & Category matching)
  // --------------------------------------------------------------------------
  void _showAiScreeningModal(BuildContext context, bool isDark, String lang) {
    double tempAcres = 3.0;
    String tempWater = 'Borewell';
    String tempCategory = 'Small';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF14241B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.analytics_rounded, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      lang == 'te'
                          ? 'నా పొలానికి తగిన పథకాల స్క్రీనింగ్'
                          : (lang == 'hi' ? 'खेत पात्रता स्क्रीनिंग' : 'Farm Eligibility Screening'),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  lang == 'te'
                      ? 'మీ పొలం వివరాలను ఎంచుకోండి, తగిన ప్రభుత్వ పథకాలను పరిశీలిస్తాం.'
                      : (lang == 'hi' ? 'खेत विवरण दर्ज करें, उपयुक्त योजनाएं प्रदर्शित होंगी।' : 'Select your farm parameters to filter matching welfare schemes.'),
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
                ),
                const Divider(height: 24),

                // Farm size slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang == 'te' ? 'భూమి విస్తీర్ణం (ఎకరాలు)' : (lang == 'hi' ? 'भूमि क्षेत्र (एकड़)' : 'Land Area (Acres)'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${tempAcres.toStringAsFixed(1)} ${lang == 'te' ? 'ఎకరాలు' : 'Acres'}',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: tempAcres,
                  min: 0.5,
                  max: 15.0,
                  divisions: 29,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setModalState(() => tempAcres = val),
                ),
                const SizedBox(height: 8),

                // Farmer category chips
                Text(
                  lang == 'te' ? 'రైతు కేటగిరీ' : (lang == 'hi' ? 'किसान श्रेणी' : 'Farmer Category'),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(lang == 'te' ? 'చిన్న/సన్నకారు (<5 ఎకరాలు)' : 'Small & Marginal (<5 Ac)'),
                      selected: tempCategory == 'Small',
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      onSelected: (_) => setModalState(() => tempCategory = 'Small'),
                    ),
                    ChoiceChip(
                      label: Text(lang == 'te' ? 'ఎస్సీ / ఎస్టీ (100% సబ్సిడీ)' : 'SC / ST (100% Subsidy)'),
                      selected: tempCategory == 'SC/ST',
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      onSelected: (_) => setModalState(() => tempCategory = 'SC/ST'),
                    ),
                    ChoiceChip(
                      label: Text(lang == 'te' ? 'మహిళా రైతు' : 'Women Farmer'),
                      selected: tempCategory == 'Women',
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      onSelected: (_) => setModalState(() => tempCategory = 'Women'),
                    ),
                    ChoiceChip(
                      label: Text(lang == 'te' ? 'సాధారణ రైతు' : 'General'),
                      selected: tempCategory == 'General',
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      onSelected: (_) => setModalState(() => tempCategory = 'General'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Water source
                Text(
                  lang == 'te' ? 'సాగునీటి వనరు' : (lang == 'hi' ? 'सिंचाई स्रोत' : 'Water Availability'),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(lang == 'te' ? 'బోరుబావి / బావి' : 'Borewell / Well'),
                      selected: tempWater == 'Borewell',
                      onSelected: (_) => setModalState(() => tempWater = 'Borewell'),
                    ),
                    ChoiceChip(
                      label: Text(lang == 'te' ? 'వర్షాధారం' : 'Rainfed'),
                      selected: tempWater == 'Rainfed',
                      onSelected: (_) => setModalState(() => tempWater = 'Rainfed'),
                    ),
                    ChoiceChip(
                      label: Text(lang == 'te' ? 'కాలువ నీరు' : 'Canal'),
                      selected: tempWater == 'Canal',
                      onSelected: (_) => setModalState(() => tempWater = 'Canal'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Screening Results Preview Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              context.tr('likelyEligible'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lang == 'te'
                            ? '• రైతు భరోసా: ${tempAcres.toStringAsFixed(1)} ఎకరాలకు దాదాపు ₹${(tempAcres * 15000).toInt()} పెట్టుబడి సాయం\n• TSMIP డ్రిప్: ${tempCategory == 'SC/ST' ? '100% ఉచిత సబ్సిడీ' : (tempCategory == 'Small' ? '90% భారీ సబ్సిడీ' : '80% సబ్సిడీ')}\n• పీఎం కిసాన్: సంవత్సరానికి ₹6,000 నగదు బదిలీ\n• KCC: 4% వడ్డీతో సాగు రుణం'
                            : (lang == 'hi'
                                ? '• रैतु भरोसा: ₹15,000 प्रति एकड़ निवेश सहायता\n• ड्रिप सब्सिडी: ${tempCategory == 'SC/ST' ? '100% अनुदान' : '90% अनुदान'}\n• पीएम किसान: ₹6,000 वार्षिक सहायता\n• केसीसी ऋण: 4% रियायती ब्याज दर'
                                : '• Rythu Bharosa: Approx ₹${(tempAcres * 15000).toInt()} input aid\n• TSMIP Drip: ${tempCategory == 'SC/ST' ? '100% Free Subsidy' : '90% Major Subsidy'}\n• PM-Kisan: ₹6,000 / year DBT\n• KCC Loan: 4% subsidized crop credit'),
                        style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF14532D)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Button to view all
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _tabController.animateTo(0);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      lang == 'te' ? 'అర్హతగల పథకాలను చూడండి' : (lang == 'hi' ? 'योजनाएं देखें' : 'View Matching Schemes'),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // CATEGORY FILTER CHIPS
  // --------------------------------------------------------------------------
  Widget _buildCategoryChips(
    BuildContext context,
    List<GovtSchemeModel> schemesPool,
    bool isDark,
    String lang,
  ) {
    final categories = [
      {'key': 'all', 'label': context.tr('allSchemes')},
      {'key': 'financial', 'label': lang == 'te' ? 'ఆర్థిక సాయం' : (lang == 'hi' ? 'वित्तीय' : 'Financial')},
      {'key': 'irrigation', 'label': lang == 'te' ? 'సాగునీరు/డ్రిప్' : (lang == 'hi' ? 'सिंचाई/ड्रिप' : 'Irrigation')},
      {'key': 'machinery', 'label': lang == 'te' ? 'యంత్రాలు' : (lang == 'hi' ? 'मशीनरी' : 'Machinery')},
      {'key': 'insurance', 'label': lang == 'te' ? 'పంట బీమా' : (lang == 'hi' ? 'फसल बीमा' : 'Insurance')},
      {'key': 'loan', 'label': lang == 'te' ? '4% రుణాలు' : (lang == 'hi' ? '4% ऋण' : 'Loans')},
      {'key': 'crop', 'label': lang == 'te' ? 'పంట మద్దతు' : (lang == 'hi' ? 'फसल समर्थन' : 'Crops')},
      {'key': 'soil', 'label': lang == 'te' ? 'నేల పరీక్ష' : (lang == 'hi' ? 'मिट्टी जांच' : 'Soil')},
      {'key': 'dairy', 'label': lang == 'te' ? 'పాడి పరిశ్రమ' : (lang == 'hi' ? 'डेयरी' : 'Dairy')},
      {'key': 'women', 'label': lang == 'te' ? 'మహిళా రైతులు' : (lang == 'hi' ? 'महिला किसान' : 'Women')},
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final cat = categories[idx];
          final isSelected = _selectedCategory == cat['key'];

          return ChoiceChip(
            label: Text(cat['label']!),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: isDark ? const Color(0xFF1B2E21) : Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 12,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF284431) : const Color(0xFFD4E2D2)),
            ),
            onSelected: (_) => setState(() => _selectedCategory = cat['key']!),
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SCHEME CARD COMPONENT (Verified, Badges, Benefits, Actions)
  // --------------------------------------------------------------------------
  Widget _buildSchemeCard(BuildContext context, GovtSchemeModel item, bool isDark, String lang) {
    final isState = item.level == 'State';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16251C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF274230) : const Color(0xFFE2EBE0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top badges row (Level, Category, Benefit pill, Deadline)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Level badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isState ? const Color(0xFFEFF6FF) : const Color(0xFFFDF4FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isState ? const Color(0xFFBFDBFE) : const Color(0xFFF0ABFC),
                    ),
                  ),
                  child: Text(
                    isState
                        ? (lang == 'te' ? 'తెలంగాణ పథకం' : (lang == 'hi' ? 'तेलंगाना राज्य' : 'Telangana State'))
                        : (lang == 'te' ? 'కేంద్ర పథకం' : (lang == 'hi' ? 'केंद्रीय योजना' : 'Central Scheme')),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: isState ? const Color(0xFF2563EB) : const Color(0xFFC026D3),
                    ),
                  ),
                ),
                // Category pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E3224) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.getLocalizedCategory(lang),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
                // Highlight badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.getLocalizedBadge(lang),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Scheme Name
            Text(
              item.getLocalizedName(lang),
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            // Department
            Text(
              item.getLocalizedDepartment(lang),
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // Benefit Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C2F23) : const Color(0xFFF4FAF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF2B4A37) : const Color(0xFFDCEDDC),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.card_giftcard_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('benefitsTitle'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.getLocalizedBenefits(lang),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Deadline banner if applicable
            if (item.deadlineDays != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFD97706)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${item.deadlineDays} ${context.tr('deadlineRemaining')}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFFB45309)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Verification date & Source indicator
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, size: 13, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${context.tr('verifiedOfficial')} • ${item.lastVerifiedDate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showSchemeDetailModal(context, item, isDark, lang),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      context.tr('viewDetailsApply'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showHelplineDialog(context, item, isDark, lang),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: isDark ? const Color(0xFF2E4D3A) : const Color(0xFFCCE4CF)),
                  ),
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 16, color: AppColors.primary),
                  label: Text(
                    context.tr('helpline'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // COMPREHENSIVE SCHEME DETAIL MODAL SHEET (All Checklists, Steps, Portal)
  // --------------------------------------------------------------------------
  void _showSchemeDetailModal(
    BuildContext context,
    GovtSchemeModel item,
    bool isDark,
    String lang,
  ) {
    final eligibility = item.getLocalizedEligibility(lang);
    final documents = item.getLocalizedDocuments(lang);
    final steps = item.getLocalizedSteps(lang);
    final isState = item.level == 'State';

    // Interactive checklist states
    final checkedCriteria = List<bool>.filled(eligibility.length, true);
    final checkedDocs = List<bool>.filled(documents.length, true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF14241B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          final allCriteriaMet = !checkedCriteria.contains(false);

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, scrollController) => ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Top handle
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Verified source banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF059669)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${context.tr('verifiedOfficial')} • ${item.lastVerifiedDate}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF065F46),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isState ? const Color(0xFFDBEAFE) : const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.level,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isState ? const Color(0xFF1D4ED8) : const Color(0xFF7E22CE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Scheme Title & Department
                Text(
                  item.getLocalizedName(lang),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.getLocalizedDepartment(lang),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Benefits Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.currency_rupee_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            context.tr('benefitsTitle'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.getLocalizedBenefits(lang),
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 1. Eligibility Checklist
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('eligibilityCriteria'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: allCriteriaMet ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            allCriteriaMet ? Icons.check_circle_rounded : Icons.info_rounded,
                            size: 13,
                            color: allCriteriaMet ? const Color(0xFF166534) : const Color(0xFF92400E),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            allCriteriaMet ? context.tr('likelyEligible') : context.tr('moreInfoRequired'),
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: allCriteriaMet ? const Color(0xFF166534) : const Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(eligibility.length, (idx) {
                  return Material(
                    child: CheckboxListTile(
                      value: checkedCriteria[idx],
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        eligibility[idx],
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                      ),
                      onChanged: (val) {
                        setSheetState(() => checkedCriteria[idx] = val ?? false);
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // 2. Required Documents Checklist
                Text(
                  context.tr('requiredDocs'),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                ...List.generate(documents.length, (idx) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Material(
                      color: isDark ? const Color(0xFF1B2E21) : const Color(0xFFF8FAF8),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isDark ? const Color(0xFF274330) : const Color(0xFFE5EDE4),
                        ),
                      ),
                      child: CheckboxListTile(
                        value: checkedDocs[idx],
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        activeColor: AppColors.primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          documents[idx],
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                        onChanged: (val) {
                          setSheetState(() => checkedDocs[idx] = val ?? false);
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // 3. How to Apply (5 Steps Process)
                Text(
                  context.tr('howToApplySteps'),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                ...List.generate(steps.length, (idx) {
                  final isLast = idx == steps.length - 1;
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${idx + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lang == 'te' ? 'దశ' : (lang == 'hi' ? 'चरण' : 'Step')} ${idx + 1}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  steps[idx],
                                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Official Portal Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openOfficialPortal(context, item, lang),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text(
                      context.tr('applyOnOfficialWebsite'),
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Helpline call button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showHelplineDialog(context, item, isDark, lang),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.support_agent_rounded, size: 18, color: AppColors.primary),
                    label: Text(
                      '${context.tr('helpline')}: ${item.helplineNumber}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF24221A) : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    context.tr('schemeDisclaimer'),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TAB: INTERACTIVE SUBSIDY CALCULATOR
  // --------------------------------------------------------------------------
  Widget _buildSubsidyCalculatorTab(BuildContext context, bool isDark, String lang) {
    // Pricing models
    final Map<String, Map<String, dynamic>> equipmentData = {
      'drip': {
        'nameTe': 'సూక్ష్మ సేద్య ప్రాజెక్ట్ (డ్రిప్ ఇరిగేషన్)',
        'nameEn': 'Micro Irrigation (Drip System)',
        'nameHi': 'सूक्ष्म सिंचाई परियोजना (ड्रिप)',
        'unitCost': 60000, // per acre
        'isPerAcre': true,
        'portal': 'https://tsmip.telangana.gov.in',
      },
      'solar': {
        'nameTe': '5HP సోలార్ వ్యవసాయ పంపుసెట్ (పీఎం-కుసుమ్)',
        'nameEn': '5HP Solar Agricultural Pump (PM-KUSUM)',
        'nameHi': '5HP सौर कृषि पंप (पीएम-कुसुम)',
        'unitCost': 250000,
        'isPerAcre': false,
        'portal': 'https://pmkusum.mnre.gov.in',
      },
      'tractor': {
        'nameTe': '45 HP వ్యవసాయ ట్రాక్టర్ (యాంత్రీకరణ)',
        'nameEn': '45 HP Agri Tractor (Mechanization)',
        'nameHi': '45 HP कृषि ट्रैक्टर (यंत्रीकरण)',
        'unitCost': 750000,
        'isPerAcre': false,
        'portal': 'https://agri.telangana.gov.in',
      },
      'rotavator': {
        'nameTe': 'మల్టీ-స్పీడ్ రోటవేటర్ (Rotavator)',
        'nameEn': 'Multi-Speed Rotavator',
        'nameHi': 'मल्टी-स्पीड रोटावेटर',
        'unitCost': 110000,
        'isPerAcre': false,
        'portal': 'https://agri.telangana.gov.in',
      },
      'sprayer': {
        'nameTe': '16L 12V బ్యాటరీ పవర్ స్ప్రేయర్',
        'nameEn': '16L 12V Battery Power Sprayer',
        'nameHi': '16L 12V बैटरी पावर स्प्रेयर',
        'unitCost': 4500,
        'isPerAcre': false,
        'portal': 'https://agri.telangana.gov.in',
      },
    };

    final currentEq = equipmentData[_selectedEquipment]!;
    final double totalCost = currentEq['isPerAcre']
        ? (currentEq['unitCost'] as int) * _farmAcres
        : (currentEq['unitCost'] as int).toDouble();

    // Subsidy percentage calculation
    double subsidyPercent = 0.50; // default 50%
    if (_selectedEquipment == 'drip') {
      if (_farmerCategory == 'sc_st') {
        subsidyPercent = 1.00; // 100%
      } else if (_farmerCategory == 'small') {
        subsidyPercent = 0.90; // 90%
      } else {
        subsidyPercent = 0.80; // 80%
      }
    } else if (_selectedEquipment == 'solar') {
      subsidyPercent = 0.60; // 60%
    } else {
      // Machinery
      if (_farmerCategory == 'sc_st' || _farmerCategory == 'small') {
        subsidyPercent = 0.50;
      } else {
        subsidyPercent = 0.40;
      }
    }

    final double subsidyAmount = totalCost * subsidyPercent;
    final double farmerShare = totalCost - subsidyAmount;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          context.tr('calculateSubsidy'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          lang == 'te'
              ? 'పరికరాలు మరియు మీ వర్గాన్ని ఎంచుకుని ప్రభుత్వ సబ్సిడీని క్షణాల్లో లెక్కించండి.'
              : (lang == 'hi' ? 'उपकरण व अपनी श्रेणी चुनकर सरकारी सब्सिडी की गणना करें।' : 'Select equipment and your farmer category to calculate instant government grant.'),
          style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
        ),
        const SizedBox(height: 16),

        // 1. Select Equipment
        Text(
          lang == 'te' ? 'వ్యవసాయ పరికరం / పథకం' : (lang == 'hi' ? 'कृषि उपकरण / योजना' : 'Equipment / Scheme'),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...equipmentData.entries.map((entry) {
          final isSel = _selectedEquipment == entry.key;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSel
                  ? (isDark ? const Color(0xFF1E3A2B) : const Color(0xFFECFDF5))
                  : (isDark ? const Color(0xFF16251C) : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSel ? AppColors.primary : (isDark ? const Color(0xFF274230) : const Color(0xFFE2EBE0)),
                width: isSel ? 1.5 : 1.0,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => setState(() => _selectedEquipment = entry.key),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      isSel ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                      color: isSel ? AppColors.primary : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 'te' ? item['nameTe'] : (lang == 'hi' ? item['nameHi'] : item['nameEn']),
                            style: TextStyle(fontWeight: isSel ? FontWeight.w800 : FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${lang == 'te' ? 'ప్రామాణిక అంచనా' : 'Standard Cost'}: ₹${item['unitCost']} ${item['isPerAcre'] ? (lang == 'te' ? '/ ఎకరా' : '/ Acre') : ''}',
                            style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 14),

        // 2. Farmer Category
        Text(
          lang == 'te' ? 'రైతు సామాజిక వర్గం' : (lang == 'hi' ? 'किसान सामाजिक वर्ग' : 'Farmer Category'),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: Center(
                  child: Text(
                    lang == 'te' ? 'ఎస్సీ / ఎస్టీ' : 'SC / ST',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                selected: _farmerCategory == 'sc_st',
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: _farmerCategory == 'sc_st' ? Colors.white : (isDark ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (_) => setState(() => _farmerCategory = 'sc_st'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChoiceChip(
                label: Center(
                  child: Text(
                    lang == 'te' ? 'చిన్న రైతు (<5 ఎ)' : 'Small (<5 Ac)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                selected: _farmerCategory == 'small',
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: _farmerCategory == 'small' ? Colors.white : (isDark ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (_) => setState(() => _farmerCategory = 'small'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChoiceChip(
                label: Center(
                  child: Text(
                    lang == 'te' ? 'ఇతర రైతులు' : 'General',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                selected: _farmerCategory == 'general',
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: _farmerCategory == 'general' ? Colors.white : (isDark ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (_) => setState(() => _farmerCategory = 'general'),
              ),
            ),
          ],
        ),

        // If per acre, show acre slider
        if (currentEq['isPerAcre']) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang == 'te' ? 'సాగు విస్తీర్ణం' : 'Area for Drip',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              Text(
                '${_farmAcres.toStringAsFixed(1)} ${lang == 'te' ? 'ఎకరాలు' : 'Acres'}',
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 13),
              ),
            ],
          ),
          Slider(
            value: _farmAcres,
            min: 0.5,
            max: 10.0,
            divisions: 19,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _farmAcres = val),
          ),
        ],
        const SizedBox(height: 18),

        // 3. Calculation Result Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E3A2B), const Color(0xFF14271E)]
                  : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF2E5740) : const Color(0xFF86EFAC),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('totalEquipmentCost'),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '₹${totalCost.toInt()}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.add_task_rounded, size: 16, color: Color(0xFF16A34A)),
                      const SizedBox(width: 4),
                      Text(
                        '${context.tr('govtSubsidyShare')} (${(subsidyPercent * 100).toInt()}%)',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF16A34A)),
                      ),
                    ],
                  ),
                  Text(
                    '- ₹${subsidyAmount.toInt()}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF16A34A)),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('estimatedShare'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '₹${farmerShare.toInt()}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Apply for this subsidy button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    lang == 'te'
                        ? 'అధికారిక సబ్సిడీ పోర్టల్ తెరుస్తోంది: ${currentEq['portal']}'
                        : 'Opening official subsidy portal: ${currentEq['portal']}',
                  ),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(
              context.tr('applyOnOfficialWebsite'),
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // TAB: MY APPLICATIONS STATUS TRACKER
  // --------------------------------------------------------------------------
  Widget _buildMyApplicationsTab(BuildContext context, bool isDark, String lang) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('myApplications'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            OutlinedButton.icon(
              onPressed: () => _showAddApplicationDialog(context, isDark, lang),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(
                lang == 'te' ? '+ జతచేయండి' : '+ Add',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          lang == 'te'
              ? 'మీరు దరఖాస్తు చేసుకున్న ప్రభుత్వ పథకాల స్థితిని ఇక్కడ సులభంగా ట్రాక్ చేయండి.'
              : (lang == 'hi' ? 'अपने जमा किए गए सरकारी आवेदनों की स्थिति यहां ट्रैक करें।' : 'Track progress of your registered welfare and subsidy applications.'),
          style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
        ),
        const SizedBox(height: 16),

        ..._myApplications.map((app) {
          final isApproved = app['status'] == 'approved';
          final name = lang == 'te' ? app['schemeName'] : (lang == 'hi' ? app['schemeNameHi'] : app['schemeNameEn']);
          final amount = lang == 'te' ? app['amount'] : app['amountEn'];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF16251C) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? const Color(0xFF26402F) : const Color(0xFFE2EBE0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F3526) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        app['id'],
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isApproved ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isApproved ? Icons.check_circle_rounded : Icons.pending_rounded,
                            size: 13,
                            color: isApproved ? const Color(0xFF15803D) : const Color(0xFF1D4ED8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isApproved ? context.tr('statusApproved') : context.tr('statusVerification'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isApproved ? const Color(0xFF15803D) : const Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${lang == 'te' ? 'దరఖాస్తు తేదీ' : 'Applied on'}: ${app['appliedDate']}',
                      style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white60 : Colors.black54),
                    ),
                    const Spacer(),
                    Text(
                      amount,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lang == 'te'
                            ? 'అధికారిక పోర్టల్‌లో ధృవీకరణ పొందండి'
                            : 'Check live status on official portal',
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              lang == 'te'
                                  ? 'అధికారిక పోర్టల్ తెరుస్తోంది: ${app['portal']}'
                                  : 'Opening official portal: ${app['portal']}',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.open_in_new_rounded, size: 14),
                      label: Text(
                        context.tr('openPortal'),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // ADD APPLICATION TRACKING DIALOG
  // --------------------------------------------------------------------------
  void _showAddApplicationDialog(BuildContext context, bool isDark, String lang) {
    final idController = TextEditingController();
    String selectedScheme = 'రైతు భరోసా పెట్టుబడి సాయం';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          lang == 'te' ? 'దరఖాస్తు ట్రాకింగ్ జోడించండి' : 'Add Application Tracking',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang == 'te' ? 'పథకం పేరు' : 'Scheme',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedScheme,
              isExpanded: true,
              items: [
                'రైతు భరోసా పెట్టుబడి సాయం',
                'పీఎం-కిసాన్ సమ్మాన్ నిధి',
                'తెలంగాణ సూక్ష్మ సేద్య ప్రాజెక్ట్ (డ్రిప్)',
                'వ్యవసాయ యాంత్రీకరణ సబ్సిడీ',
                'పీఎం ఫసల్ బీమా యోజన',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12.5)))).toList(),
              onChanged: (val) => selectedScheme = val!,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              lang == 'te' ? 'దరఖాస్తు / రశీదు నంబర్' : 'Application / Ack Number',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: 'e.g. TL-AGRI-840192',
                hintStyle: const TextStyle(fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang == 'te' ? 'రద్దు' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (idController.text.trim().isNotEmpty) {
                setState(() {
                  _myApplications.insert(0, {
                    'id': idController.text.trim().toUpperCase(),
                    'schemeId': 'custom',
                    'schemeName': selectedScheme,
                    'schemeNameEn': selectedScheme,
                    'schemeNameHi': selectedScheme,
                    'appliedDate': '04/09/2026',
                    'status': 'verification',
                    'amount': 'పరిశీలనలో ఉంది',
                    'amountEn': 'Under Review',
                    'portal': 'https://agri.telangana.gov.in',
                  });
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(lang == 'te' ? 'జతచేయండి' : 'Add', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // OFFICIAL PORTAL LAUNCH DIALOG
  // --------------------------------------------------------------------------
  void _openOfficialPortal(BuildContext context, GovtSchemeModel item, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.verified_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                lang == 'te' ? 'అధికారిక ప్రభుత్వ పోర్టల్' : 'Official Government Portal',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang == 'te'
                  ? 'మీరు ఈ క్రింది అధికారిక పోర్టల్ ద్వారా దరఖాస్తును పూర్తి చేసుకోవచ్చు:'
                  : 'You can complete your application on the verified official portal:',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: SelectableText(
                item.officialPortalUrl,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2563EB),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              lang == 'te'
                  ? 'గమనిక: మీ ఆధార్ కార్డ్, పట్టాదారు పాస్‌బుక్ మరియు బ్యాంక్ ఖాతా వివరాలను అందుబాటులో ఉంచుకోండి.'
                  : 'Note: Keep your Aadhaar, Pattadar passbook, and Bank passbook handy.',
              style: const TextStyle(fontSize: 11.5, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang == 'te' ? 'మూసివేయి' : 'Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    lang == 'te'
                        ? 'అధికారిక పోర్టల్ ప్రారంభమవుతోంది: ${item.officialPortalUrl}'
                        : 'Opening official portal: ${item.officialPortalUrl}',
                  ),
                  backgroundColor: const Color(0xFF2563EB),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
            child: Text(
              context.tr('openPortal'),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HELPLINE DIALOG
  // --------------------------------------------------------------------------
  void _showHelplineDialog(BuildContext context, GovtSchemeModel item, bool isDark, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              context.tr('helpline'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.getLocalizedName(lang),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.call_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  SelectableText(
                    item.helplineNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              lang == 'te'
                  ? 'పనివేళలు: సోమవారం నుండి శనివారం వరకు ఉదయం 9:00 నుండి సాయంత్రం 6:00 వరకు.'
                  : (lang == 'hi'
                      ? 'कार्य समय: सोमवार से शनिवार सुबह 9:00 से शाम 6:00 तक।'
                      : 'Working Hours: Mon to Sat, 9:00 AM to 6:00 PM.'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang == 'te' ? 'సరే' : 'OK'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    lang == 'te'
                        ? 'హెల్ప్‌లైన్‌కు కాల్ చేస్తున్నారు: ${item.helplineNumber}'
                        : 'Calling helpline: ${item.helplineNumber}',
                  ),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            icon: const Icon(Icons.call_rounded, size: 16, color: Colors.white),
            label: Text(
              lang == 'te' ? 'కాల్ చేయండి' : 'Call Now',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
