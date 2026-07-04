// data/level3_content.dart — المستوى الثالث: الأصوات الطويلة (المدود)
// المصدر: هيا بنا نتعلم القراءة - المستوى الثالث - الأستاذ محمد علي الكفراوي

class LongVowelWord {
  final String word;
  final String part1;   // المقطع قبل المد
  final String vowelChar; // 'ا' | 'يـ' | 'و'
  final String part2;   // الجزء بعد المد
  final String emoji;
  final String vowelType; // 'alif' | 'ya' | 'waw'
  const LongVowelWord(this.word, this.part1, this.vowelChar, this.part2, this.emoji, this.vowelType);
}

class L3DB {
  // =============================================
  // جدول المدود الكامل — كل حرف × 3 أنواع
  // صفحة 2: اِفْهَمْ أَوَّلاً ثُمَّ احْفَظْ
  // =============================================
  static const Map<String, List<String>> longVowelTable = {
    'ب': ['بَا', 'بِيـ', 'بُو'],
    'ت': ['تَا', 'تِيـ', 'تُو'],
    'ث': ['ثَا', 'ثِيـ', 'ثُو'],
    'ج': ['جَا', 'جِيـ', 'جُو'],
    'ح': ['حَا', 'حِيـ', 'حُو'],
    'خ': ['خَا', 'خِيـ', 'خُو'],
    'د': ['دَا', 'دِيـ', 'دُو'],
    'ذ': ['ذَا', 'ذِيـ', 'ذُو'],
    'ر': ['رَا', 'رِيـ', 'رُو'],
    'ز': ['زَا', 'زِيـ', 'زُو'],
    'س': ['سَا', 'سِيـ', 'سُو'],
    'ش': ['شَا', 'شِيـ', 'شُو'],
    'ص': ['صَا', 'صِيـ', 'صُو'],
    'ض': ['ضَا', 'ضِيـ', 'ضُو'],
    'ط': ['طَا', 'طِيـ', 'طُو'],
    'ظ': ['ظَا', 'ظِيـ', 'ظُو'],
    'ع': ['عَا', 'عِيـ', 'عُو'],
    'غ': ['غَا', 'غِيـ', 'غُو'],
    'ف': ['فَا', 'فِيـ', 'فُو'],
    'ق': ['قَا', 'قِيـ', 'قُو'],
    'ك': ['كَا', 'كِيـ', 'كُو'],
    'ل': ['لَا', 'لِيـ', 'لُو'],
    'م': ['مَا', 'مِيـ', 'مُو'],
    'ن': ['نَا', 'نِيـ', 'نُو'],
    'هـ': ['هَا', 'هِيـ', 'هُو'],
    'و': ['وَا', 'وِيـ', 'وُو'],
    'ي': ['يَا', 'يِيـ', 'يُو'],
  };

  // =============================================
  // كلمات مد الألف — فتحة + ا (صفحات 3-6)
  // =============================================
  static const List<LongVowelWord> alifWords = [
    LongVowelWord('بَاب','بَ','ا','ب','🚪','alif'),
    LongVowelWord('تَاج','تَ','ا','ج','👑','alif'),
    LongVowelWord('دَار','دَ','ا','ر','🏠','alif'),
    LongVowelWord('مَاء','مَ','ا','ء','💧','alif'),
    LongVowelWord('نَار','نَ','ا','ر','🔥','alif'),
    LongVowelWord('مَال','مَ','ا','ل','💰','alif'),
    LongVowelWord('جَار','جَ','ا','ر','👤','alif'),
    LongVowelWord('عَام','عَ','ا','م','📅','alif'),
    LongVowelWord('دَال','دَ','ا','ل','🔤','alif'),
    LongVowelWord('رَاب','رَ','ا','ب','🧇','alif'),
    LongVowelWord('حَال','حَ','ا','ل','🌟','alif'),
    LongVowelWord('طَار','طَ','ا','ر','✈️','alif'),
    LongVowelWord('صَار','صَ','ا','ر','⚗️','alif'),
    LongVowelWord('شَام','شَ','ا','م','🌍','alif'),
    LongVowelWord('سَار','سَ','ا','ر','🚶','alif'),
    LongVowelWord('فَاز','فَ','ا','ز','🏆','alif'),
    LongVowelWord('قَال','قَ','ا','ل','💬','alif'),
    LongVowelWord('كَان','كَ','ا','ن','✅','alif'),
    LongVowelWord('لَان','لَ','ا','ن','🌿','alif'),
    LongVowelWord('مَان','مَ','ا','ن','🛡️','alif'),
    LongVowelWord('هَام','هَ','ا','م','⭐','alif'),
    LongVowelWord('وَادِ','وَ','ا','دِ','🏞️','alif'),
    LongVowelWord('يَاء','يَ','ا','ء','🔤','alif'),
  ];

  // =============================================
  // كلمات مد الياء — كسرة + يـ (صفحات 3-5)
  // =============================================
  static const List<LongVowelWord> yaWords = [
    LongVowelWord('فِيل','فِ','يـ','ل','🐘','ya'),
    LongVowelWord('دِيك','دِ','يـ','ك','🐓','ya'),
    LongVowelWord('عِيد','عِ','يـ','د','🎉','ya'),
    LongVowelWord('رِيف','رِ','يـ','ف','🌾','ya'),
    LongVowelWord('رِيش','رِ','يـ','ش','🪶','ya'),
    LongVowelWord('جِيل','جِ','يـ','ل','👥','ya'),
    LongVowelWord('تِين','تِ','يـ','ن','🫐','ya'),
    LongVowelWord('رِيق','رِ','يـ','ق','💧','ya'),
    LongVowelWord('حِين','حِ','يـ','ن','⏰','ya'),
    LongVowelWord('نِيل','نِ','يـ','ل','🌊','ya'),
    LongVowelWord('لِيف','لِ','يـ','ف','🌴','ya'),
    LongVowelWord('سِيف','سِ','يـ','ف','⚔️','ya'),
    LongVowelWord('بِيت','بِ','يـ','ت','🏠','ya'),
    LongVowelWord('ضِيف','ضِ','يـ','ف','👤','ya'),
    LongVowelWord('شِيح','شِ','يـ','ح','🌿','ya'),
  ];

  // =============================================
  // كلمات مد الواو — ضمة + و (صفحات 3-6)
  // =============================================
  static const List<LongVowelWord> wawWords = [
    LongVowelWord('حُوت','حُ','و','ت','🐳','waw'),
    LongVowelWord('كُوب','كُ','و','ب','🥤','waw'),
    LongVowelWord('كُوخ','كُ','و','خ','🏚️','waw'),
    LongVowelWord('نُور','نُ','و','ر','💡','waw'),
    LongVowelWord('سُوق','سُ','و','ق','🛒','waw'),
    LongVowelWord('طُوب','طُ','و','ب','🧱','waw'),
    LongVowelWord('صُوف','صُ','و','ف','🐑','waw'),
    LongVowelWord('عُود','عُ','و','د','🪗','waw'),
    LongVowelWord('تُوت','تُ','و','ت','🫐','waw'),
    LongVowelWord('فُول','فُ','و','ل','🫘','waw'),
    LongVowelWord('لُوح','لُ','و','ح','📋','waw'),
    LongVowelWord('بُوم','بُ','و','م','🦉','waw'),
    LongVowelWord('دُود','دُ','و','د','🪱','waw'),
    LongVowelWord('زُور','زُ','و','ر','⚓','waw'),
    LongVowelWord('شُوك','شُ','و','ك','🍴','waw'),
  ];

  // =============================================
  // كلمات ثنائية المقاطع مع المد (صفحات 4-6)
  // =============================================
  static const List<LongVowelWord> twoSyllableWords = [
    // كسر + مد ألف
    LongVowelWord('كِتَاب','كِ','تَا','ب','📖','alif'),
    LongVowelWord('حِصَان','حِ','صَا','ن','🐴','alif'),
    LongVowelWord('خِطَاب','خِ','طَا','ب','📜','alif'),
    LongVowelWord('لِسَان','لِ','سَا','ن','👅','alif'),
    LongVowelWord('نِظَام','نِ','ظَا','م','📐','alif'),
    LongVowelWord('جِمَال','جِ','مَا','ل','🐪','alif'),
    LongVowelWord('شِبَاك','شِ','بَا','ك','🎣','alif'),
    LongVowelWord('إِنَاء','إِ','نَا','ء','🏺','alif'),
    LongVowelWord('بِحَار','بِ','حَا','ر','🌊','alif'),
    LongVowelWord('رِمَال','رِ','مَا','ل','🏖️','alif'),
    LongVowelWord('قِطَار','قِ','طَا','ر','🚂','alif'),
    LongVowelWord('دِمَاغ','دِ','مَا','غ','🧠','alif'),
    // فتح + مد ياء
    LongVowelWord('أَمِير','أَ','مِي','ر','👑','ya'),
    LongVowelWord('بَرِيد','بَ','رِي','د','📬','ya'),
    LongVowelWord('جَمِيل','جَ','مِي','ل','✨','ya'),
    LongVowelWord('قَرِيب','قَ','رِي','ب','🤏','ya'),
    LongVowelWord('طَبِيب','طَ','بِي','ب','👨‍⚕️','ya'),
    LongVowelWord('نَظِيف','نَ','ظِي','ف','🧹','ya'),
    LongVowelWord('كَبِير','كَ','بِي','ر','📏','ya'),
    LongVowelWord('صَغِير','صَ','غِي','ر','🔬','ya'),
    LongVowelWord('حَلِيب','حَ','لِي','ب','🥛','ya'),
    LongVowelWord('عَجِيب','عَ','جِي','ب','😲','ya'),
    LongVowelWord('رَغِيف','رَ','غِي','ف','🍞','ya'),
    LongVowelWord('مَرِيض','مَ','رِي','ض','🤒','ya'),
    LongVowelWord('فَرِيد','فَ','رِي','د','💎','ya'),
    LongVowelWord('سَمِيك','سَ','مِي','ك','📦','ya'),
    // فتح + مد واو
    LongVowelWord('أُسُود','أُ','سُو','د','🦁','waw'),
    LongVowelWord('بُحُور','بُ','حُو','ر','🌊','waw'),
    LongVowelWord('حُرُوف','حُ','رُو','ف','🔤','waw'),
    LongVowelWord('دُمُوع','دُ','مُو','ع','😢','waw'),
    LongVowelWord('نُجُوم','نُ','جُو','م','⭐','waw'),
    LongVowelWord('كُنُوز','كُ','نُو','ز','💎','waw'),
    LongVowelWord('فُصُول','فُ','صُو','ل','🍂','waw'),
    LongVowelWord('قُلُوب','قُ','لُو','ب','❤️','waw'),
    LongVowelWord('مُلُوك','مُ','لُو','ك','👑','waw'),
    LongVowelWord('زُهُور','زُ','هُو','ر','🌸','waw'),
    LongVowelWord('رُمُوش','رُ','مُو','ش','👁️','waw'),
    LongVowelWord('ذُيُول','ذُ','يُو','ل','🦊','waw'),
    LongVowelWord('ضُيُوف','ضُ','يُو','ف','👥','waw'),
    LongVowelWord('طُيُور','طُ','يُو','ر','🐦','waw'),
  ];

  // =============================================
  // كلمات ثلاثية المقاطع (صفحات 40-44)
  // =============================================
  static const List<LongVowelWord> advancedWords = [
    // CVC + مد + C
    LongVowelWord('مَرْوَان','مَرْ','وَا','ن','👦','alif'),
    LongVowelWord('عَدْنَان','عَدْ','نَا','ن','👦','alif'),
    LongVowelWord('قِرْطَاس','قِرْ','طَا','س','📄','alif'),
    LongVowelWord('جِلْبَاب','جِلْ','بَا','ب','👘','alif'),
    LongVowelWord('إِمْضَاء','إِمْ','ضَا','ء','✍️','alif'),
    LongVowelWord('إِنْقَاذ','إِنْ','قَا','ذ','🛟','alif'),
    LongVowelWord('خُرْطُوم','خُرْ','طُو','م','🐘','waw'),
    LongVowelWord('بُلْدَان','بُلْ','دَا','ن','🌍','alif'),
    LongVowelWord('تَغْرِيد','تَغْ','رِي','د','🐦','ya'),
    LongVowelWord('تَسْجِيل','تَسْ','جِي','ل','🎙️','ya'),
    LongVowelWord('تَشْغِيل','تَشْ','غِي','ل','▶️','ya'),
    LongVowelWord('مَجْرُوح','مَجْ','رُو','ح','🩹','waw'),
    LongVowelWord('مَخْلُوق','مَخْ','لُو','ق','🌿','waw'),
    LongVowelWord('مَكْتُوب','مَكْ','تُو','ب','📬','waw'),
    LongVowelWord('مَقْتُول','مَقْ','تُو','ل','⚠️','waw'),
    // جمع التكسير (صفحات 43-46)
    LongVowelWord('مَدَارِس','مَدَا','رِ','س','🏫','ya'),
    LongVowelWord('مَسَاجِد','مَسَا','جِ','د','🕌','ya'),
    LongVowelWord('مَصَانِع','مَصَا','نِ','ع','🏭','ya'),
    LongVowelWord('مَطَابِخ','مَطَا','بِ','خ','🍳','ya'),
    LongVowelWord('مَكَاتِب','مَكَا','تِ','ب','🖊️','ya'),
    LongVowelWord('مَرَاوِح','مَرَا','وِ','ح','🌀','ya'),
    LongVowelWord('مَسَاكِن','مَسَا','كِ','ن','🏘️','ya'),
    LongVowelWord('قَوَارِب','قَوَا','رِ','ب','⛵','ya'),
  ];

  // =============================================
  // جميع الكلمات مجمعة
  // =============================================
  static List<LongVowelWord> allWords() =>
      [...alifWords, ...yaWords, ...wawWords];

  static List<LongVowelWord> wordsByType(String type) {
    switch (type) {
      case 'alif': return [...alifWords, ...twoSyllableWords.where((w) => w.vowelType == 'alif').toList()];
      case 'ya':   return [...yaWords,   ...twoSyllableWords.where((w) => w.vowelType == 'ya').toList()];
      case 'waw':  return [...wawWords,  ...twoSyllableWords.where((w) => w.vowelType == 'waw').toList()];
      default:     return allWords();
    }
  }
}
