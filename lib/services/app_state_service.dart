import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../models/expense_model.dart';

class AppStateService extends ChangeNotifier {
  String _currentLanguage = 'te'; // Default to Telugu as requested for Rythu Mitra
  ThemeMode _themeMode = ThemeMode.light;

  // Farmer Farm Profile
  String _location = 'Warangal, Telangana';
  final double _farmAreaAcres = 5.0;
  final DateTime _sowingDate = DateTime.now().subtract(const Duration(days: 65));
  int _activeCropStageIndex = 2; // 0: Seedling, 1: Vegetative, 2: Flowering, 3: Harvest

  // Notifications
  List<AppNotificationItem> _notifications = [
    const AppNotificationItem(
      id: 'n1',
      title: 'Weather Advisory',
      titleTe: 'వర్ష సూచన',
      titleEn: 'Weather Advisory',
      titleHi: 'मौसम की सलाह',
      body: 'Rain expected tomorrow in Warangal (30mm). Hold off fertilizer and pesticide spraying.',
      bodyTe: 'రేపు వరంగల్ జిల్లాలో 30mm వర్షం పడే అవకాశం ఉంది. ఎరువులు, పురుగుమందుల పిచికారీ నిలిపివేయండి.',
      bodyEn: 'Rain expected tomorrow in Warangal (30mm). Hold off fertilizer and pesticide spraying.',
      bodyHi: 'कल वारंगल जिले में 30mm बारिश की संभावना है। खाद और कीटनाशक छिड़काव टालें।',
      time: '10 mins ago',
      timeTe: '10 నిమిషాల క్రితం',
      timeEn: '10 mins ago',
      timeHi: '10 मिनट पहले',
      type: NotificationType.weather,
      isRead: false,
    ),
    const AppNotificationItem(
      id: 'n2',
      title: 'Cotton Price Rise',
      titleTe: 'పత్తి ధర పెరుగుదల',
      titleEn: 'Cotton Price Rise',
      titleHi: 'कपास भाव में तेजी',
      body: 'Warangal Market Yard cotton price rose to ₹7,850 per quintal today (+₹150).',
      bodyTe: 'వరంగల్ మార్కెట్ యార్డ్‌లో నేడు పత్తి క్వింటాల్ ధర ₹7,850 కి చేరింది (+₹150).',
      bodyEn: 'Warangal Market Yard cotton price rose to ₹7,850 per quintal today (+₹150).',
      bodyHi: 'वारंगल कृषि मंडी में आज कपास का भाव ₹7,850 प्रति क्विंटल (+₹150) पहुंचा।',
      time: '1 hour ago',
      timeTe: '1 గంట క్రితం',
      timeEn: '1 hour ago',
      timeHi: '1 घंटा पहले',
      type: NotificationType.market,
      isRead: false,
    ),
    const AppNotificationItem(
      id: 'n3',
      title: 'Fertilizer Management',
      titleTe: 'ఎరువుల యాజమాన్యం',
      titleEn: 'Fertilizer Management',
      titleHi: 'उर्वरक प्रबंधन',
      body: 'Time for 2nd dose of Urea & Potash during flowering stage.',
      bodyTe: 'పూత దశలో 2వ దఫా యూరియా & పొటాష్ వేయడానికి సమయం ఆసన్నమైంది.',
      bodyEn: 'Time for 2nd dose of Urea & Potash during flowering stage.',
      bodyHi: 'फूल आने की अवस्था में यूरिया और पोटाश की दूसरी खुराक का समय आ गया है।',
      time: 'Yesterday',
      timeTe: 'నిన్న',
      timeEn: 'Yesterday',
      timeHi: 'कल',
      type: NotificationType.fertilizer,
      isRead: true,
    ),
  ];

  // Expenses Ledger
  final List<FarmExpenseItem> _expenses = [
    FarmExpenseItem(
      id: 'e1',
      title: 'Bt Cotton Hybrid Seeds',
      category: ExpenseCategory.seeds,
      amount: 4500,
      date: DateTime.now().subtract(const Duration(days: 65)),
      cropName: 'Cotton',
    ),
    FarmExpenseItem(
      id: 'e2',
      title: 'Tractor Ploughing & Land Prep',
      category: ExpenseCategory.tractor,
      amount: 7000,
      date: DateTime.now().subtract(const Duration(days: 60)),
      cropName: 'Cotton',
    ),
    FarmExpenseItem(
      id: 'e3',
      title: 'DAP & Complex Fertilizers (Basal)',
      category: ExpenseCategory.fertilizer,
      amount: 8500,
      date: DateTime.now().subtract(const Duration(days: 45)),
      cropName: 'Cotton',
    ),
    FarmExpenseItem(
      id: 'e4',
      title: 'Weeding & Manual Labour (10 Workers)',
      category: ExpenseCategory.labour,
      amount: 5000,
      date: DateTime.now().subtract(const Duration(days: 30)),
      cropName: 'Cotton',
    ),
    FarmExpenseItem(
      id: 'e5',
      title: 'Neem Oil + Bio-Pesticide Spray',
      category: ExpenseCategory.pesticides,
      amount: 2800,
      date: DateTime.now().subtract(const Duration(days: 15)),
      cropName: 'Cotton',
    ),
  ];

  // Getters
  String get currentLanguage => _currentLanguage;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  String get farmerName {
    if (_currentLanguage == 'te') return 'రాజేశ్వర్ రావు';
    if (_currentLanguage == 'hi') return 'राजेश्वर राव';
    return 'Rajeshwar Rao';
  }

  String get location {
    if (_location != 'Warangal, Telangana' && _location != 'వరంగల్, తెలంగాణ' && _location != 'वारंगल, तेलंगाना' && _location != 'వరంగల్ (Warangal), Telangana') {
      return _location;
    }
    if (_currentLanguage == 'te') return 'వరంగల్, తెలంగాణ';
    if (_currentLanguage == 'hi') return 'वारंगल, तेलंगाना';
    return 'Warangal, Telangana';
  }

  String get activeCrop {
    if (_currentLanguage == 'te') return 'పత్తి';
    if (_currentLanguage == 'hi') return 'कपास';
    return 'Cotton';
  }

  double get farmAreaAcres => _farmAreaAcres;
  DateTime get sowingDate => _sowingDate;
  int get activeCropStageIndex => _activeCropStageIndex;

  List<AppNotificationItem> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  List<FarmExpenseItem> get expenses => _expenses;
  double get totalExpenses => _expenses
      .where((e) => !e.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);
  double get totalIncome => _expenses
      .where((e) => e.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);
  double get estimatedRevenue => 145000; // Estimated 20 quintals @ ₹7250
  double get estimatedNetProfit => estimatedRevenue - totalExpenses;

  // Actions
  void setLanguage(String langCode) {
    if (_currentLanguage != langCode) {
      _currentLanguage = langCode;
      notifyListeners();
    }
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLocation(String newLoc) {
    _location = newLoc;
    notifyListeners();
  }

  void updateCropStage(int stageIndex) {
    _activeCropStageIndex = stageIndex;
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications
        .map((n) => AppNotificationItem(
              id: n.id,
              title: n.title,
              titleTe: n.titleTe,
              titleEn: n.titleEn,
              titleHi: n.titleHi,
              body: n.body,
              bodyTe: n.bodyTe,
              bodyEn: n.bodyEn,
              bodyHi: n.bodyHi,
              time: n.time,
              timeTe: n.timeTe,
              timeEn: n.timeEn,
              timeHi: n.timeHi,
              type: n.type,
              isRead: true,
              actionRoute: n.actionRoute,
            ))
        .toList();
    notifyListeners();
  }

  void addExpense(FarmExpenseItem expense) {
    _expenses.insert(0, expense);
    notifyListeners();
  }
}
