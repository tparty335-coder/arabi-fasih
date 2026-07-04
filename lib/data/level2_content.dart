// data/level2_content.dart — المستوى الثاني: الحرف الساكن
// المصدر: هيا بنا نتعلم القراءة - المستوى الثاني - الأستاذ محمد علي الكفراوي

class CvcWord {
  final String word;       // الكلمة كاملة
  final String syllable1;  // المقطع الأول (CVC)
  final String syllable2;  // باقي الكلمة
  final String emoji;
  final String type; // 'fatha' | 'damma' | 'kasra'
  const CvcWord(this.word, this.syllable1, this.syllable2, this.emoji, this.type);
}

class Level2DB {
  // =============================================
  // كلمات CVC مسبوق بفتح (صفحات 3-12)
  // =============================================
  static const List<CvcWord> fathaWords = [
    CvcWord('فَأْس','فَأْ','س','🪓','fatha'),
    CvcWord('كَأْس','كَأْ','س','🥛','fatha'),
    CvcWord('رَأْس','رَأْ','س','👤','fatha'),
    CvcWord('بَأْس','بَأْ','س','💪','fatha'),
    CvcWord('يَأْس','يَأْ','س','😔','fatha'),
    CvcWord('فَأْر','فَأْ','ر','🐀','fatha'),
    CvcWord('بَيْت','بَيْ','ت','🏠','fatha'),
    CvcWord('بَيْض','بَيْ','ض','🥚','fatha'),
    CvcWord('بَحْر','بَحْ','ر','🌊','fatha'),
    CvcWord('بَرْد','بَرْ','د','❄️','fatha'),
    CvcWord('بَرْق','بَرْ','ق','⚡','fatha'),
    CvcWord('بَطْن','بَطْ','ن','🤰','fatha'),
    CvcWord('ثَوْر','ثَوْ','ر','🐂','fatha'),
    CvcWord('ثَوْب','ثَوْ','ب','👕','fatha'),
    CvcWord('ثَلْج','ثَلْ','ج','❄️','fatha'),
    CvcWord('جَيْش','جَيْ','ش','⚔️','fatha'),
    CvcWord('جَيْب','جَيْ','ب','👜','fatha'),
    CvcWord('جَفْن','جَفْ','ن','👁️','fatha'),
    CvcWord('جَمْع','جَمْ','ع','➕','fatha'),
    CvcWord('حَفْل','حَفْ','ل','🎉','fatha'),
    CvcWord('حَقْل','حَقْ','ل','🌾','fatha'),
    CvcWord('حَبْل','حَبْ','ل','🪢','fatha'),
    CvcWord('حَوْض','حَوْ','ض','🛁','fatha'),
    CvcWord('حَرْب','حَرْ','ب','⚔️','fatha'),
    CvcWord('حَرْف','حَرْ','ف','🔤','fatha'),
    CvcWord('خَيْط','خَيْ','ط','🧵','fatha'),
    CvcWord('خَيْل','خَيْ','ل','🐎','fatha'),
    CvcWord('خَيْر','خَيْ','ر','✨','fatha'),
    CvcWord('خَوْخ','خَوْ','خ','🍑','fatha'),
    CvcWord('خَوْف','خَوْ','ف','😨','fatha'),
    CvcWord('دَرْس','دَرْ','س','📖','fatha'),
    CvcWord('دَمْع','دَمْ','ع','💧','fatha'),
    CvcWord('دَلْو','دَلْ','و','🪣','fatha'),
    CvcWord('ذَيْل','ذَيْ','ل','🦊','fatha'),
    CvcWord('ذَهَب','ذَهَ','ب','🥇','fatha'),
    CvcWord('رَسْم','رَسْ','م','🎨','fatha'),
    CvcWord('رَمْل','رَمْ','ل','🏖️','fatha'),
    CvcWord('زَيْت','زَيْ','ت','🫒','fatha'),
    CvcWord('زَهْر','زَهْ','ر','🌸','fatha'),
    CvcWord('سَيْف','سَيْ','ف','⚔️','fatha'),
    CvcWord('سَطْح','سَطْ','ح','🏠','fatha'),
    CvcWord('سَبْع','سَبْ','ع','🦁','fatha'),
    CvcWord('شَمْس','شَمْ','س','☀️','fatha'),
    CvcWord('شَمْع','شَمْ','ع','🕯️','fatha'),
    CvcWord('شَعْر','شَعْ','ر','💇','fatha'),
    CvcWord('صَقْر','صَقْ','ر','🦅','fatha'),
    CvcWord('صَخْر','صَخْ','ر','🪨','fatha'),
    CvcWord('صَوْت','صَوْ','ت','🔊','fatha'),
    CvcWord('ضَوْء','ضَوْ','ء','💡','fatha'),
    CvcWord('ضَيْف','ضَيْ','ف','👤','fatha'),
    CvcWord('طَيْر','طَيْ','ر','🐦','fatha'),
    CvcWord('طَوْق','طَوْ','ق','📿','fatha'),
    CvcWord('عَيْن','عَيْ','ن','👁️','fatha'),
    CvcWord('عَقْل','عَقْ','ل','🧠','fatha'),
    CvcWord('عَسَل','عَسَ','ل','🍯','fatha'),
    CvcWord('غَزْل','غَزْ','ل','🧶','fatha'),
    CvcWord('غَرْب','غَرْ','ب','🌅','fatha'),
    CvcWord('فَرْح','فَرْ','ح','😊','fatha'),
    CvcWord('قَمْر','قَمْ','ر','🌙','fatha'),
    CvcWord('قَلْب','قَلْ','ب','❤️','fatha'),
    CvcWord('قَصْر','قَصْ','ر','🏰','fatha'),
    CvcWord('كَلْب','كَلْ','ب','🐶','fatha'),
    CvcWord('كَنْز','كَنْ','ز','💎','fatha'),
    CvcWord('كَعْب','كَعْ','ب','👟','fatha'),
    CvcWord('لَحْم','لَحْ','م','🥩','fatha'),
    CvcWord('لَيْل','لَيْ','ل','🌙','fatha'),
    CvcWord('لَوْن','لَوْ','ن','🎨','fatha'),
    CvcWord('مَوْز','مَوْ','ز','🍌','fatha'),
    CvcWord('مَوْج','مَوْ','ج','🌊','fatha'),
    CvcWord('نَحْل','نَحْ','ل','🐝','fatha'),
    CvcWord('نَخْل','نَخْ','ل','🌴','fatha'),
    CvcWord('نَجْم','نَجْ','م','⭐','fatha'),
    CvcWord('نَمْل','نَمْ','ل','🐜','fatha'),
    CvcWord('وَرْد','وَرْ','د','🌹','fatha'),
    CvcWord('وَقْت','وَقْ','ت','⏰','fatha'),
    CvcWord('هَتْف','هَتْ','ف','📣','fatha'),
    CvcWord('أَهْل','أَهْ','ل','👨‍👩‍👧','fatha'),
    CvcWord('أَرْض','أَرْ','ض','🌍','fatha'),
  ];

  // =============================================
  // كلمات CVC مسبوق بضم (صفحة 12)
  // =============================================
  static const List<CvcWord> dammaWords = [
    CvcWord('أُخْت','أُخْ','ت','👧','damma'),
    CvcWord('بُرْج','بُرْ','ج','🗼','damma'),
    CvcWord('زُبْد','زُبْ','د','🧈','damma'),
    CvcWord('عُشْب','عُشْ','ب','🌿','damma'),
    CvcWord('ثُقْب','ثُقْ','ب','🕳️','damma'),
    CvcWord('غُصْن','غُصْ','ن','🌿','damma'),
    CvcWord('جُبْن','جُبْ','ن','🧀','damma'),
    CvcWord('قُطْن','قُطْ','ن','☁️','damma'),
    CvcWord('خُبْز','خُبْ','ز','🍞','damma'),
    CvcWord('فُجْل','فُجْ','ل','🌿','damma'),
    CvcWord('دُرْج','دُرْ','ج','🗄️','damma'),
    CvcWord('هُدْهُد','هُدْ','هُد','🐦','damma'),
  ];

  // =============================================
  // كلمات CVC مسبوق بكسر (صفحة 13)
  // =============================================
  static const List<CvcWord> kasraWords = [
    CvcWord('بِنْت','بِنْ','ت','👧','kasra'),
    CvcWord('طِفْل','طِفْ','ل','👶','kasra'),
    CvcWord('تِسْع','تِسْ','ع','9️⃣','kasra'),
    CvcWord('عِطْر','عِطْ','ر','🌸','kasra'),
    CvcWord('جِذْر','جِذْ','ر','🌳','kasra'),
    CvcWord('مِلْح','مِلْ','ح','🧂','kasra'),
    CvcWord('رِمْش','رِمْ','ش','👁️','kasra'),
    CvcWord('نِسْر','نِسْ','ر','🦅','kasra'),
    CvcWord('رِجْل','رِجْ','ل','🦵','kasra'),
    CvcWord('ذِئْب','ذِئْ','ب','🐺','kasra'),
    CvcWord('ضِلْع','ضِلْ','ع','🦴','kasra'),
    CvcWord('هِنْد','هِنْ','د','🌺','kasra'),
  ];

  // =============================================
  // كلمات متعددة المقاطع (صفحات 14-18)
  // =============================================
  static const List<MultiSyllableWord> multiSyllableWords = [
    // مَفْعَلة pattern
    MultiSyllableWord('مَدْرَسَة', ['مَدْ','رَ','سَ','ـة'], '🏫'),
    MultiSyllableWord('مَرْوَحَة', ['مَرْ','وَ','حَ','ـة'], '🌀'),
    MultiSyllableWord('مَكْتَبَة', ['مَكْ','تَ','بَ','ـة'], '📚'),
    MultiSyllableWord('مَزْرَعَة', ['مَزْ','رَ','عَ','ـة'], '🌾'),
    MultiSyllableWord('مَطْعَم', ['مَطْ','عَ','م'], '🍽️'),
    MultiSyllableWord('مَطْبَخ', ['مَطْ','بَ','خ'], '🍳'),
    MultiSyllableWord('مَكْتَب', ['مَكْ','تَ','ب'], '🖊️'),
    MultiSyllableWord('مَلْعَب', ['مَلْ','عَ','ب'], '⚽'),
    MultiSyllableWord('مَصْنَع', ['مَصْ','نَ','ع'], '🏭'),
    MultiSyllableWord('مَدْخَل', ['مَدْ','خَ','ل'], '🚪'),
    MultiSyllableWord('مَخْرَج', ['مَخْ','رَ','ج'], '🚪'),
    MultiSyllableWord('مَقْعَد', ['مَقْ','عَ','د'], '🪑'),
    // أَفْعَل pattern
    MultiSyllableWord('أَرْنَب', ['أَرْ','نَ','ب'], '🐇'),
    MultiSyllableWord('أَحْمَد', ['أَحْ','مَ','د'], '👦'),
    MultiSyllableWord('أَرْجُل', ['أَرْ','جُ','ل'], '🦶'),
    MultiSyllableWord('أَحْمَر', ['أَحْ','مَ','ر'], '🔴'),
    MultiSyllableWord('أَزْرَق', ['أَزْ','رَ','ق'], '🔵'),
    MultiSyllableWord('أَصْفَر', ['أَصْ','فَ','ر'], '🟡'),
    MultiSyllableWord('أَخْضَر', ['أَخْ','ضَ','ر'], '🟢'),
    MultiSyllableWord('أَبْيَض', ['أَبْ','يَ','ض'], '⬜'),
    MultiSyllableWord('أَسْوَد', ['أَسْ','وَ','د'], '⬛'),
    // فَعْلة pattern
    MultiSyllableWord('شَمْعَة', ['شَمْ','عَ','ـة'], '🕯️'),
    MultiSyllableWord('شَعْرَة', ['شَعْ','رَ','ـة'], '💇'),
    MultiSyllableWord('شَوْكَة', ['شَوْ','كَ','ـة'], '🍴'),
    MultiSyllableWord('نَحْلَة', ['نَحْ','لَ','ـة'], '🐝'),
    MultiSyllableWord('نَخْلَة', ['نَخْ','لَ','ـة'], '🌴'),
    MultiSyllableWord('نَمْلَة', ['نَمْ','لَ','ـة'], '🐜'),
    MultiSyllableWord('هَمْسَة', ['هَمْ','سَ','ـة'], '🤫'),
    MultiSyllableWord('بَسْمَة', ['بَسْ','مَ','ـة'], '😊'),
    MultiSyllableWord('رَحْمَة', ['رَحْ','مَ','ـة'], '❤️'),
    MultiSyllableWord('وَرْدَة', ['وَرْ','دَ','ـة'], '🌹'),
    MultiSyllableWord('زَهْرَة', ['زَهْ','رَ','ـة'], '🌸'),
    MultiSyllableWord('قَرْيَة', ['قَرْ','يَ','ـة'], '🏘️'),
    MultiSyllableWord('فَرْحَة', ['فَرْ','حَ','ـة'], '😊'),
    MultiSyllableWord('لَيْلَة', ['لَيْ','لَ','ـة'], '🌙'),
    MultiSyllableWord('لَوْحَة', ['لَوْ','حَ','ـة'], '🖼️'),
    // عُفْلة pattern (damma)
    MultiSyllableWord('عُلْبَة', ['عُلْ','بَ','ـة'], '📦'),
    MultiSyllableWord('غُرْفَة', ['غُرْ','فَ','ـة'], '🛏️'),
    MultiSyllableWord('شُعْلَة', ['شُعْ','لَ','ـة'], '🔥'),
    MultiSyllableWord('أُسْرَة', ['أُسْ','رَ','ـة'], '👨‍👩‍👧‍👦'),
    MultiSyllableWord('حُجْرَة', ['حُجْ','رَ','ـة'], '🚪'),
    MultiSyllableWord('حُفْرَة', ['حُفْ','رَ','ـة'], '🕳️'),
    MultiSyllableWord('فُرْشَة', ['فُرْ','شَ','ـة'], '🪥'),
    // إِفْلة pattern (kasra)
    MultiSyllableWord('إِبْرَة', ['إِبْ','رَ','ـة'], '🪡'),
    MultiSyllableWord('نِسْمَة', ['نِسْ','مَ','ـة'], '🌬️'),
    MultiSyllableWord('طِفْلَة', ['طِفْ','لَ','ـة'], '👧'),
    MultiSyllableWord('رِحْلَة', ['رِحْ','لَ','ـة'], '✈️'),
    MultiSyllableWord('تِسْعَة', ['تِسْ','عَ','ـة'], '9️⃣'),
    MultiSyllableWord('سِلْسِلَة', ['سِلْ','سِ','لَ','ـة'], '⛓️'),
    MultiSyllableWord('مِسْطَرَة', ['مِسْ','طَ','رَ','ـة'], '📏'),
    MultiSyllableWord('مِشْمِشَة', ['مِشْ','مِ','شَ','ـة'], '🍑'),
    MultiSyllableWord('سِمْسِمَة', ['سِمْ','سِ','مَ','ـة'], '🌱'),
  ];

  // =============================================
  // أفعال المضارع (صفحات 19-22)
  // فعل + أ/ن/ت/ي
  // =============================================
  static const List<VerbGroup> verbs = [
    VerbGroup('بدأ','🚀',['أَبْدَأ','نَبْدَأ','تَبْدَأ','يَبْدَأ']),
    VerbGroup('رَكَب','🚗',['أَرْكَب','نَرْكَب','تَرْكَب','يَرْكَب']),
    VerbGroup('بَحَث','🔍',['أَبْحَث','نَبْحَث','تَبْحَث','يَبْحَث']),
    VerbGroup('رَكَع','🙇',['أَرْكَع','نَرْكَع','تَرْكَع','يَرْكَع']),
    VerbGroup('جَمَع','➕',['أَجْمَع','نَجْمَع','تَجْمَع','يَجْمَع']),
    VerbGroup('حَفِظ','📖',['أَحْفَظ','نَحْفَظ','تَحْفَظ','يَحْفَظ']),
    VerbGroup('خَرَج','🚪',['أَخْرُج','نَخْرُج','تَخْرُج','يَخْرُج']),
    VerbGroup('دَخَل','🏠',['أَدْخُل','نَدْخُل','تَدْخُل','يَدْخُل']),
    VerbGroup('ذَهَب','🏃',['أَذْهَب','نَذْهَب','تَذْهَب','يَذْهَب']),
    VerbGroup('زَرَع','🌱',['أَزْرَع','نَزْرَع','تَزْرَع','يَزْرَع']),
    VerbGroup('سَمِع','👂',['أَسْمَع','نَسْمَع','تَسْمَع','يَسْمَع']),
    VerbGroup('شَرِب','🥤',['أَشْرَب','نَشْرَب','تَشْرَب','يَشْرَب']),
    VerbGroup('صَنَع','🔧',['أَصْنَع','نَصْنَع','تَصْنَع','يَصْنَع']),
    VerbGroup('ضَرَب','👊',['أَضْرِب','نَضْرِب','تَضْرِب','يَضْرِب']),
    VerbGroup('طَبَخ','🍳',['أَطْبُخ','نَطْبُخ','تَطْبُخ','يَطْبُخ']),
    VerbGroup('عَمِل','💼',['أَعْمَل','نَعْمَل','تَعْمَل','يَعْمَل']),
    VerbGroup('فَرِح','😊',['أَفْرَح','نَفْرَح','تَفْرَح','يَفْرَح']),
    VerbGroup('قَرَأ','📚',['أَقْرَأ','نَقْرَأ','تَقْرَأ','يَقْرَأ']),
    VerbGroup('كَتَب','✏️',['أَكْتُب','نَكْتُب','تَكْتُب','يَكْتُب']),
    VerbGroup('لَعِب','⚽',['أَلْعَب','نَلْعَب','تَلْعَب','يَلْعَب']),
    VerbGroup('مَسَح','🧹',['أَمْسَح','نَمْسَح','تَمْسَح','يَمْسَح']),
    VerbGroup('نَزَل','⬇️',['أَنْزِل','نَنْزِل','تَنْزِل','يَنْزِل']),
    VerbGroup('هَرَب','🏃',['أَهْرُب','نَهْرُب','تَهْرُب','يَهْرُب']),
  ];
}

class MultiSyllableWord {
  final String word;
  final List<String> syllables;
  final String emoji;
  const MultiSyllableWord(this.word, this.syllables, this.emoji);
}

class VerbGroup {
  final String root;
  final String emoji;
  final List<String> conjugations; // أ / ن / ت / ي
  const VerbGroup(this.root, this.emoji, this.conjugations);
}
