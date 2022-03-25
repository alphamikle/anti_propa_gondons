import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/src/widgets/localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

      abstract class _App {
      late String title;
      late String fullTitle;
      }
      class _EnApp extends _App {
      /// Description: ""
    /// Example: "A.P.G"
    @override
    final String title = Intl.message('A.P.G', name: 'title', desc: '');
      /// Description: ""
    /// Example: "Anti Propa Gondons"
    @override
    final String fullTitle = Intl.message('Anti Propa Gondons', name: 'fullTitle', desc: '');
      }
      abstract class _About {
      late String title;
      late String content;
      }
      class _EnAbout extends _About {
      /// Description: ""
    /// Example: "About"
    @override
    final String title = Intl.message('About', name: 'title', desc: '');
      /// Description: ""
    /// Example: "LARGE_EN_CONTENT"
    @override
    final String content = Intl.message('LARGE_EN_CONTENT', name: 'content', desc: '');
      }
      abstract class _MainControls {
      late String enable;
      late String disable;
      }
      class _EnMainControls extends _MainControls {
      /// Description: ""
    /// Example: "Включить всё"
    @override
    final String enable = Intl.message('Включить всё', name: 'enable', desc: '');
      /// Description: ""
    /// Example: "Выключить всё"
    @override
    final String disable = Intl.message('Выключить всё', name: 'disable', desc: '');
      }
      abstract class _Main {
      late String requestsInWork;
      late String totalRequests;
      late _MainControls controls;
      }
      class _EnMain extends _Main {
      /// Description: ""
    /// Example: "Запросов в работе"
    @override
    final String requestsInWork = Intl.message('Запросов в работе', name: 'requestsInWork', desc: '');
      /// Description: ""
    /// Example: "Всего запросов"
    @override
    final String totalRequests = Intl.message('Всего запросов', name: 'totalRequests', desc: '');
      @override
    final _MainControls controls = _EnMainControls();
      }
      abstract class LocalizationMessages {
      late _App app;
      late _About about;
      late _Main main;
      }
      class _En extends LocalizationMessages {
      @override
    final _App app = _EnApp();
      @override
    final _About about = _EnAbout();
      @override
    final _Main main = _EnMain();
      }
      class _RuApp extends _App {
      /// Description: ""
    /// Example: "A.P.G"
    @override
    final String title = Intl.message('A.P.G', name: 'title', desc: '');
      /// Description: ""
    /// Example: "Anti Propa Gondons"
    @override
    final String fullTitle = Intl.message('Anti Propa Gondons', name: 'fullTitle', desc: '');
      }
      class _RuAbout extends _About {
      /// Description: ""
    /// Example: "Информация"
    @override
    final String title = Intl.message('Информация', name: 'title', desc: '');
      /// Description: ""
    /// Example: "LARGE_RU_CONTENT"
    @override
    final String content = Intl.message('LARGE_RU_CONTENT', name: 'content', desc: '');
      }
      class _RuMainControls extends _MainControls {
      /// Description: ""
    /// Example: "Включить всё"
    @override
    final String enable = Intl.message('Включить всё', name: 'enable', desc: '');
      /// Description: ""
    /// Example: "Выключить всё"
    @override
    final String disable = Intl.message('Выключить всё', name: 'disable', desc: '');
      }
      class _RuMain extends _Main {
      /// Description: ""
    /// Example: "Запросов в работе"
    @override
    final String requestsInWork = Intl.message('Запросов в работе', name: 'requestsInWork', desc: '');
      /// Description: ""
    /// Example: "Всего запросов"
    @override
    final String totalRequests = Intl.message('Всего запросов', name: 'totalRequests', desc: '');
      @override
    final _MainControls controls = _RuMainControls();
      }
      class _Ru extends LocalizationMessages {
      @override
    final _App app = _RuApp();
      @override
    final _About about = _RuAbout();
      @override
    final _Main main = _RuMain();
      }
      class _UaApp extends _App {
      /// Description: ""
    /// Example: "A.P.G"
    @override
    final String title = Intl.message('A.P.G', name: 'title', desc: '');
      /// Description: ""
    /// Example: "Anti Propa Gondons"
    @override
    final String fullTitle = Intl.message('Anti Propa Gondons', name: 'fullTitle', desc: '');
      }
      class _UaAbout extends _About {
      /// Description: ""
    /// Example: "Информация"
    @override
    final String title = Intl.message('Информация', name: 'title', desc: '');
      /// Description: ""
    /// Example: "LARGE_UA_CONTENT"
    @override
    final String content = Intl.message('LARGE_UA_CONTENT', name: 'content', desc: '');
      }
      class _UaMainControls extends _MainControls {
      /// Description: ""
    /// Example: "Включить всё"
    @override
    final String enable = Intl.message('Включить всё', name: 'enable', desc: '');
      /// Description: ""
    /// Example: "Выключить всё"
    @override
    final String disable = Intl.message('Выключить всё', name: 'disable', desc: '');
      }
      class _UaMain extends _Main {
      /// Description: ""
    /// Example: "Запросов в работе"
    @override
    final String requestsInWork = Intl.message('Запросов в работе', name: 'requestsInWork', desc: '');
      /// Description: ""
    /// Example: "Всего запросов"
    @override
    final String totalRequests = Intl.message('Всего запросов', name: 'totalRequests', desc: '');
      @override
    final _MainControls controls = _UaMainControls();
      }
      class _Ua extends LocalizationMessages {
      @override
    final _App app = _UaApp();
      @override
    final _About about = _UaAbout();
      @override
    final _Main main = _UaMain();
      }
    class LocalizationDelegate extends LocalizationsDelegate<LocalizationMessages> {
    @override
    bool isSupported(Locale locale) => _languageMap.keys.contains(locale.languageCode);
  
    @override
    Future<LocalizationMessages> load(Locale locale) async {
      Intl.defaultLocale = locale.countryCode == null ? locale.languageCode : locale.toString();
      return _languageMap[locale.languageCode]!;
    }
    
    @override
    bool shouldReload(LocalizationsDelegate<LocalizationMessages> old) => false;

    final Map<String, LocalizationMessages> _languageMap = {
      'en': _En(),
        'ru': _Ru(),
        'ua': _Ua(),
      };

    }

    class Messages {
    static LocalizationMessages of(BuildContext context) => Localizations.of(context, LocalizationMessages);

    static LocalizationMessages get en => LocalizationDelegate()._languageMap['en']!;
    static LocalizationMessages get ru => LocalizationDelegate()._languageMap['ru']!;
    static LocalizationMessages get ua => LocalizationDelegate()._languageMap['ua']!;
    
    
    static LocalizationMessages? getLocale(String locale) {
      final List<String> localeData = locale.split('_');
      String languageCode = '';
      String countryCode = '';
      if (localeData.isEmpty) {
        throw Exception('Not found any locale info in string ${locale}');
      }
      languageCode = localeData[0];
      if (localeData.length > 1) {
        countryCode = localeData[1];
      }
      return LocalizationDelegate()._languageMap[languageCode];
    }
  }
  
  final List<LocalizationsDelegate> localizationsDelegates = [LocalizationDelegate(), ...GlobalMaterialLocalizations.delegates];

  const List<Locale> supportedLocales = [
const Locale('en'),
    const Locale('ru'),
    const Locale('ua'),
    ];