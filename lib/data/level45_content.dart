// data/level4_content.dart — المستوى الرابع: الحروف المشددة
// المصدر: هيا بنا نتعلم القراءة - المستوى الرابع - الأستاذ محمد علي الكفراوي

class ShaddaWord {
  final String withShadda;   // الكلمة بالشدة
  final String withoutShadda; // الكلمة بدون شدة (للمقارنة)
  final String emoji;
  final String vowelType; // 'fatha' | 'kasra' | 'damma'
  const ShaddaWord(this.withShadda, this.withoutShadda, this.emoji, this.vowelType);
}

class L4DB {
  // =============================================
  // مفهوم الشدة: حرفان مدغمان → حرف مشدد
  // الشدة بالفتح = سكون + فتح
  // الشدة بالكسر = سكون + كسر
  // الشدة بالضم  = سكون + ضم
  // =============================================

  // =============================================
  // كلمات بسيطة بالشدة (فَعَّة) — صفحات 5-6
  // =============================================
  static const List<ShaddaWord> simpleWords = [
    ShaddaWord('قِطَّة','قِطَة','🐱','kasra'),
    ShaddaWord('قِصَّة','قِصَة','📖','kasra'),
    ShaddaWord('حِصَّة','حِصَة','⏰','kasra'),
    ShaddaWord('حَبَّة','حَبَة','🌾','fatha'),
    ShaddaWord('جَنَّة','جَنَة','🌿','fatha'),
    ShaddaWord('بَطَّة','بَطَة','🦆','fatha'),
    ShaddaWord('حِنَّة','حِنَة','🌿','kasra'),
    ShaddaWord('خِطَّة','خِطَة','📋','kasra'),
    ShaddaWord('عَمَّة','عَمَة','👩','fatha'),
    ShaddaWord('مَكَّة','مَكَة','🕌','fatha'),
  ];

  // =============================================
  // مقارنة الفعل: فَعَلَ / فَعَّلَ / تَفَعَّلَ
  // =============================================
  static const List<List<String>> verbTriples = [
    ['رَدَّ','رُدِّدَ','تَرَدَّدَ'],
    ['شَبَه','شُبِّه','تَشَبَّه'],
    ['رَتَب','رُتِّب','تَرَتَّب'],
    ['أَثَر','أُثِّر','تَأَثَّر'],
    ['وَحَد','وُحِّد','تَوَحَّد'],
    ['أَخَّر','أُخِّر','تَأَخَّر'],
    ['حَدَث','حُدِّث','تَحَدَّث'],
    ['هَذَّب','هُذِّب','تَهَذَّب'],
    ['حَرَّك','حُرِّك','تَحَرَّك'],
    ['وَسَع','وُسِّع','تَوَسَّع'],
    ['تَقَدَّم','قَدَّم','قَدَمَ'],
    ['تَعَلَّم','عَلَّم','عَلَمَ'],
  ];

  // =============================================
  // نمط المهن (فَعَّال) — صفحة 6
  // =============================================
  static const List<ShaddaWord> professionPattern = [
    ShaddaWord('غَفَّار','غَافِر','🙏','fatha'),
    ShaddaWord('فَتَّاح','فَاتِح','🔓','fatha'),
    ShaddaWord('وَهَّاب','وَاهِب','🎁','fatha'),
    ShaddaWord('فَعَّال','فَاعِل','💪','fatha'),
    ShaddaWord('كَذَّاب','كَاذِب','🤥','fatha'),
    ShaddaWord('جَبَّار','جَابِر','💪','fatha'),
    ShaddaWord('صَبَّار','صَابِر','🧘','fatha'),
    ShaddaWord('نَجَّار','نَاجِر','🪚','fatha'),
    ShaddaWord('حَدَّاد','حَادِد','⚒️','fatha'),
    ShaddaWord('خَبَّاز','خَابِز','🍞','fatha'),
    ShaddaWord('سَبَّاح','سَابِح','🏊','fatha'),
    ShaddaWord('صَيَّاد','صَائِد','🎣','fatha'),
    ShaddaWord('حَجَّام','حَاجِم','✂️','fatha'),
    ShaddaWord('حَفَّار','حَافِر','⛏️','fatha'),
    ShaddaWord('كُتَّاب','كَاتِب','📝','damma'),
    ShaddaWord('تُفَّاح','تُفَاح','🍎','damma'),
    ShaddaWord('رُمَّان','رُمَان','🍎','damma'),
  ];

  // =============================================
  // كلمات مركبة بالشدة (صفحة 7)
  // =============================================
  static const List<ShaddaWord> complexWords = [
    ShaddaWord('مُعَلِّم','مُعَلِم','👨‍🏫','kasra'),
    ShaddaWord('مُعَلِّمَة','مُعَلِمَة','👩‍🏫','kasra'),
    ShaddaWord('سَيَّارَة','سَيَارَة','🚗','fatha'),
    ShaddaWord('غَسَّالَة','غَسَالَة','🫧','fatha'),
    ShaddaWord('ثَلَّاجَة','ثَلَاجَة','🧊','fatha'),
    ShaddaWord('طَفَّايَة','طَفَايَة','🧯','fatha'),
    ShaddaWord('دَفَّايَة','دَفَايَة','🔥','fatha'),
    ShaddaWord('غَلَّايَة','غَلَايَة','♨️','fatha'),
  ];

  // =============================================
  // جميع الكلمات للتدريب العشوائي
  // =============================================
  static List<ShaddaWord> get allBasicWords =>
      [...simpleWords, ...professionPattern];
}

// =============================================
// data/level5_content.dart — المستوى الخامس: التنوين
// =============================================

class TanwinWord {
  final String withTanwin;   // الكلمة بالتنوين
  final String withoutTanwin; // بدون تنوين
  final String emoji;
  final String type; // 'fath' | 'kasr' | 'damm'
  const TanwinWord(this.withTanwin, this.withoutTanwin, this.emoji, this.type);
}

class L5DB {
  // =============================================
  // كلمات CVC مع تنوين الفتح (ً) — صفحات 4-8
  // =============================================
  static const List<TanwinWord> fathTanwin = [
    TanwinWord('ضَوْءًا','ضَوْء','💡','fath'),
    TanwinWord('قَلْبًا','قَلْب','❤️','fath'),
    TanwinWord('بَيْتًا','بَيْت','🏠','fath'),
    TanwinWord('مَوْجًا','مَوْج','🌊','fath'),
    TanwinWord('لَوْحًا','لَوْح','📋','fath'),
    TanwinWord('خَوْخًا','خَوْخ','🍑','fath'),
    TanwinWord('وَرْدًا','وَرْد','🌹','fath'),
    TanwinWord('فَخْذًا','فَخْذ','🦵','fath'),
    TanwinWord('قَصْرًا','قَصْر','🏰','fath'),
    TanwinWord('مَوْزًا','مَوْز','🍌','fath'),
    TanwinWord('شَمْسًا','شَمْس','☀️','fath'),
    TanwinWord('رِمْشًا','رِمْش','👁️','fath'),
    TanwinWord('أَرْضًا','أَرْض','🌍','fath'),
    TanwinWord('خَيْطًا','خَيْط','🧵','fath'),
    TanwinWord('غَيْظًا','غَيْظ','😤','fath'),
    TanwinWord('فَرْعًا','فَرْع','🌿','fath'),
    TanwinWord('صَمْغًا','صَمْغ','🌲','fath'),
    TanwinWord('حَرْفًا','حَرْف','🔤','fath'),
    TanwinWord('بَرْقًا','بَرْق','⚡','fath'),
    TanwinWord('شَوْكًا','شَوْك','🍴','fath'),
    TanwinWord('حَقْلًا','حَقْل','🌾','fath'),
    TanwinWord('نَوْمًا','نَوْم','😴','fath'),
    TanwinWord('وَجْهًا','وَجْه','😊','fath'),
    TanwinWord('دَلْوًا','دَلْو','🪣','fath'),
    TanwinWord('رَحْمَةً','رَحْمَة','❤️','fath'),
    TanwinWord('قِرَاءَةً','قِرَاءَة','📖','fath'),
    TanwinWord('لَيْثًا','لَيْث','🦁','fath'),
  ];

  // =============================================
  // كلمات بتنوين الكسر (ٍ)
  // =============================================
  static const List<TanwinWord> kasrTanwin = [
    TanwinWord('يَوْمٍ','يَوْم','📅','kasr'),
    TanwinWord('زَيْتٍ','زَيْت','🫒','kasr'),
    TanwinWord('حَرْفٍ','حَرْف','🔤','kasr'),
    TanwinWord('زَوْجٍ','زَوْج','👫','kasr'),
    TanwinWord('نَخْلٍ','نَخْل','🌴','kasr'),
    TanwinWord('سَيْفٍ','سَيْف','⚔️','kasr'),
    TanwinWord('جِسْمٍ','جِسْم','🦴','kasr'),
    TanwinWord('صَوْتٍ','صَوْت','🔊','kasr'),
    TanwinWord('حَرْبٍ','حَرْب','⚔️','kasr'),
    TanwinWord('شَمْسٍ','شَمْس','☀️','kasr'),
    TanwinWord('شَعْرٍ','شَعْر','🧣','kasr'),
    TanwinWord('ثَوْبٍ','ثَوْب','👘','kasr'),
    TanwinWord('شَهْرٍ','شَهْر','📅','kasr'),
    TanwinWord('رَمْلٍ','رَمْل','🏖️','kasr'),
    TanwinWord('بَيْتٍ','بَيْت','🏠','kasr'),
    TanwinWord('كِتَابٍ','كِتَاب','📖','kasr'),
    TanwinWord('عِلْمٍ','عِلْم','💡','kasr'),
    TanwinWord('عَذَابٍ','عَذَاب','⚠️','kasr'),
    TanwinWord('رَجُلٍ','رَجُل','👤','kasr'),
    TanwinWord('نَهْرٍ','نَهْر','🌊','kasr'),
    TanwinWord('وَلَدٍ','وَلَد','👦','kasr'),
    TanwinWord('جَمَلٍ','جَمَل','🐪','kasr'),
  ];

  static const List<TanwinWord> dammTanwin = [
    TanwinWord('قَلْبٌ','قَلْب','❤️','damm'),
    TanwinWord('بَيْتٌ','بَيْت','🏠','damm'),
    TanwinWord('تَمْرٌ','تَمْر','🌴','damm'),
    TanwinWord('لَوْنٌ','لَوْن','🎨','damm'),
    TanwinWord('أَرْضٌ','أَرْض','🌍','damm'),
    TanwinWord('مَوْجٌ','مَوْج','🌊','damm'),
    TanwinWord('نَهْرٌ','نَهْر','🌊','damm'),
    TanwinWord('دَمْعٌ','دَمْع','😢','damm'),
    TanwinWord('وَرْدٌ','وَرْد','🌹','damm'),
    TanwinWord('قَمَرٌ','قَمَر','🌙','damm'),
    TanwinWord('شَجَرَةٌ','شَجَرَة','🌳','damm'),
    TanwinWord('مَدْرَسَةٌ','مَدْرَسَة','🏫','damm'),
    TanwinWord('سَيَّارَةٌ','سَيَّارَة','🚗','damm'),
    TanwinWord('أَرْنَبٌ','أَرْنَب','🐇','damm'),
    TanwinWord('قَلَمٌ','قَلَم','✏️','damm'),
    TanwinWord('كِتَابٌ','كِتَاب','📖','damm'),
    TanwinWord('عِلْمٌ','عِلْم','💡','damm'),
    TanwinWord('بَابٌ','بَاب','🚪','damm'),
    TanwinWord('حَدِيثٌ','حَدِيث','💬','damm'),
    TanwinWord('وَقْتٌ','وَقْت','⏰','damm'),
    TanwinWord('فَرَحٌ','فَرَح','😊','damm'),
    TanwinWord('نَمْلٌ','نَمْل','🐜','damm'),
  ];

  // =============================================
  // أزواج متشابهة (درس تمييزي مهم) — صفحة 27
  // =============================================
  static const List<List<String>> minimalPairs = [
    ['عِلْمٌ', 'عَلَمٌ'],    // علم (knowledge) vs علم (flag)
    ['مَلِكٌ', 'مَلَكٌ'],    // ملك (king) vs ملك (angel)
    ['سِنَةٌ', 'سَنَةٌ'],    // سنة (doze) vs سنة (year)
    ['أَلْفٌ', 'أَلِفَ'],     // ألف (thousand) vs ألف (he liked)
    ['عَالِمٌ', 'عَالَمٌ'],  // عالم (scholar) vs عالم (world)
  ];

  static List<TanwinWord> byType(String type) {
    switch (type) {
      case 'kasr': return kasrTanwin;
      case 'damm': return dammTanwin;
      default:     return fathTanwin;
    }
  }
}
