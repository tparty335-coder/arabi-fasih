// data/letters_content.dart — قاموس الحروف الـ 28 كاملاً
class LetterData {
  final String letter, name, soundFatha, soundKasra, soundDamma;
  final String initialForm, medialForm, finalForm;
  final List<String> confusedWith;
  final List<WordExample> fathaWords, kasraWords, dammaWords;
  const LetterData({required this.letter, required this.name,
    required this.soundFatha, required this.soundKasra, required this.soundDamma,
    required this.initialForm, required this.medialForm, required this.finalForm,
    required this.confusedWith, required this.fathaWords,
    required this.kasraWords, required this.dammaWords});
}

class WordExample {
  final String word, emoji, ttsText;
  const WordExample(this.word, this.emoji, this.ttsText);
}

class ArabicLettersDB {
  static const Map<String, LetterData> letters = {
    'ب': LetterData(letter:'ب',name:'باء',soundFatha:'بَ',soundKasra:'بِ',soundDamma:'بُ',
      initialForm:'بـ',medialForm:'ـبـ',finalForm:'ـب',confusedWith:['ت','ث','ن'],
      fathaWords:[WordExample('بَابٌ','🚪','باب'),WordExample('بَقَرَةٌ','🐄','بقرة'),WordExample('بَطَّةٌ','🦆','بطة'),WordExample('بَيتٌ','🏠','بيت'),WordExample('بَحَرٌ','🌊','بحر')],
      kasraWords:[WordExample('بِئرٌ','🕳️','بئر'),WordExample('بِدايةٌ','🌅','بداية')],
      dammaWords:[WordExample('بُرجٌ','🗼','برج'),WordExample('بُستانٌ','🌳','بستان')]),

    'ت': LetterData(letter:'ت',name:'تاء',soundFatha:'تَ',soundKasra:'تِ',soundDamma:'تُ',
      initialForm:'تـ',medialForm:'ـتـ',finalForm:'ـت',confusedWith:['ب','ث'],
      fathaWords:[WordExample('تَمرٌ','🌴','تمر'),WordExample('تُفَّاحٌ','🍎','تفاح'),WordExample('تِمسَاحٌ','🐊','تمساح'),WordExample('تَاجٌ','👑','تاج'),WordExample('تَلَّةٌ','⛰️','تلة')],
      kasraWords:[WordExample('تِلميذٌ','👦','تلميذ'),WordExample('تِجارةٌ','💰','تجارة')],
      dammaWords:[WordExample('تُرابٌ','🌿','تراب'),WordExample('تُفَّاحٌ','🍎','تفاح')]),

    'ث': LetterData(letter:'ث',name:'ثاء',soundFatha:'ثَ',soundKasra:'ثِ',soundDamma:'ثُ',
      initialForm:'ثـ',medialForm:'ـثـ',finalForm:'ـث',confusedWith:['ب','ت'],
      fathaWords:[WordExample('ثَعلَبٌ','🦊','ثعلب'),WordExample('ثَورٌ','🐂','ثور'),WordExample('ثَمَرٌ','🍇','ثمر'),WordExample('ثَلجٌ','❄️','ثلج'),WordExample('ثَلاجةٌ','🧊','ثلاجة')],
      kasraWords:[WordExample('ثِقَةٌ','🤝','ثقة')],
      dammaWords:[WordExample('ثُلُثٌ','⅓','ثلث')]),

    'ج': LetterData(letter:'ج',name:'جيم',soundFatha:'جَ',soundKasra:'جِ',soundDamma:'جُ',
      initialForm:'جـ',medialForm:'ـجـ',finalForm:'ـج',confusedWith:['ح','خ'],
      fathaWords:[WordExample('جَمَلٌ','🐪','جمل'),WordExample('جَبَلٌ','⛰️','جبل'),WordExample('جَزَرٌ','🥕','جزر'),WordExample('جَنَّةٌ','🌺','جنة'),WordExample('جَوَّالٌ','📱','جوال')],
      kasraWords:[WordExample('جِسرٌ','🌉','جسر')],
      dammaWords:[WordExample('جُندِيٌّ','💂','جندي')]),

    'ح': LetterData(letter:'ح',name:'حاء',soundFatha:'حَ',soundKasra:'حِ',soundDamma:'حُ',
      initialForm:'حـ',medialForm:'ـحـ',finalForm:'ـح',confusedWith:['ج','خ'],
      fathaWords:[WordExample('حَصَانٌ','🐴','حصان'),WordExample('حَمَلٌ','🐑','حمل'),WordExample('حَوتٌ','🐳','حوت'),WordExample('حَقيبةٌ','👜','حقيبة'),WordExample('حَدائقٌ','🌸','حدائق')],
      kasraWords:[WordExample('حِمَارٌ','🫏','حمار')],
      dammaWords:[WordExample('حُبٌّ','❤️','حب')]),

    'خ': LetterData(letter:'خ',name:'خاء',soundFatha:'خَ',soundKasra:'خِ',soundDamma:'خُ',
      initialForm:'خـ',medialForm:'ـخـ',finalForm:'ـخ',confusedWith:['ج','ح'],
      fathaWords:[WordExample('خَروفٌ','🐑','خروف'),WordExample('خَيمةٌ','⛺','خيمة'),WordExample('خَبزٌ','🍞','خبز'),WordExample('خَضرَاءٌ','🥬','خضراء'),WordExample('خَريطةٌ','🗺️','خريطة')],
      kasraWords:[WordExample('خِيَارٌ','🥒','خيار')],
      dammaWords:[WordExample('خُضرَةٌ','🌿','خضرة')]),

    'د': LetterData(letter:'د',name:'دال',soundFatha:'دَ',soundKasra:'دِ',soundDamma:'دُ',
      initialForm:'د',medialForm:'ـد',finalForm:'ـد',confusedWith:['ذ'],
      fathaWords:[WordExample('دَجَاجَةٌ','🐔','دجاجة'),WordExample('دَلفينٌ','🐬','دلفين'),WordExample('دَبٌّ','🐻','دب'),WordExample('دَراجةٌ','🚲','دراجة'),WordExample('دَارٌ','🏠','دار')],
      kasraWords:[WordExample('دِيكٌ','🐓','ديك')],
      dammaWords:[WordExample('دُبٌّ','🐻','دب')]),

    'ذ': LetterData(letter:'ذ',name:'ذال',soundFatha:'ذَ',soundKasra:'ذِ',soundDamma:'ذُ',
      initialForm:'ذ',medialForm:'ـذ',finalForm:'ـذ',confusedWith:['د'],
      fathaWords:[WordExample('ذِئبٌ','🐺','ذئب'),WordExample('ذَهَبٌ','🥇','ذهب'),WordExample('ذَنَبٌ','🦊','ذنب'),WordExample('ذَكَاءٌ','🧠','ذكاء'),WordExample('ذَرَّةٌ','🌽','ذرة')],
      kasraWords:[WordExample('ذِئبٌ','🐺','ذئب')],
      dammaWords:[WordExample('ذُرَةٌ','🌽','ذرة')]),

    'ر': LetterData(letter:'ر',name:'راء',soundFatha:'رَ',soundKasra:'رِ',soundDamma:'رُ',
      initialForm:'ر',medialForm:'ـر',finalForm:'ـر',confusedWith:['ز'],
      fathaWords:[WordExample('رَبيعٌ','🌸','ربيع'),WordExample('رُمَّانٌ','🍎','رمان'),WordExample('رَأسٌ','👤','رأس'),WordExample('رَسَّامٌ','🎨','رسام'),WordExample('رَمَلٌ','🏖️','رمل')],
      kasraWords:[WordExample('رِيحٌ','💨','ريح')],
      dammaWords:[WordExample('رُمَّانٌ','🍎','رمان')]),

    'ز': LetterData(letter:'ز',name:'زاي',soundFatha:'زَ',soundKasra:'زِ',soundDamma:'زُ',
      initialForm:'ز',medialForm:'ـز',finalForm:'ـز',confusedWith:['ر'],
      fathaWords:[WordExample('زَرَافةٌ','🦒','زرافة'),WordExample('زَهرةٌ','🌺','زهرة'),WordExample('زَيتونٌ','🫒','زيتون'),WordExample('زَبدَةٌ','🧈','زبدة'),WordExample('زَلزَالٌ','🌍','زلزال')],
      kasraWords:[WordExample('زِنجَبيلٌ','🫚','زنجبيل')],
      dammaWords:[WordExample('زُبدَةٌ','🧈','زبدة')]),

    'س': LetterData(letter:'س',name:'سين',soundFatha:'سَ',soundKasra:'سِ',soundDamma:'سُ',
      initialForm:'سـ',medialForm:'ـسـ',finalForm:'ـس',confusedWith:['ش','ص'],
      fathaWords:[WordExample('سَمَكٌ','🐟','سمك'),WordExample('سَيَّارةٌ','🚗','سيارة'),WordExample('سَماءٌ','☁️','سماء'),WordExample('سَبعٌ','🦁','سبع'),WordExample('سَلَّةٌ','🧺','سلة')],
      kasraWords:[WordExample('سِتَّةٌ','6️⃣','ستة')],
      dammaWords:[WordExample('سُلَّمٌ','🪜','سلم')]),

    'ش': LetterData(letter:'ش',name:'شين',soundFatha:'شَ',soundKasra:'شِ',soundDamma:'شُ',
      initialForm:'شـ',medialForm:'ـشـ',finalForm:'ـش',confusedWith:['س'],
      fathaWords:[WordExample('شَجَرةٌ','🌳','شجرة'),WordExample('شَمسٌ','☀️','شمس'),WordExample('شَوكةٌ','🍴','شوكة'),WordExample('شَرطيٌّ','👮','شرطي'),WordExample('شَاطئٌ','🏖️','شاطئ')],
      kasraWords:[WordExample('شِتاءٌ','❄️','شتاء')],
      dammaWords:[WordExample('شُمسٌ','☀️','شمس')]),

    'ص': LetterData(letter:'ص',name:'صاد',soundFatha:'صَ',soundKasra:'صِ',soundDamma:'صُ',
      initialForm:'صـ',medialForm:'ـصـ',finalForm:'ـص',confusedWith:['س','ض'],
      fathaWords:[WordExample('صَقرٌ','🦅','صقر'),WordExample('صَخرةٌ','🪨','صخرة'),WordExample('صَابونٌ','🧼','صابون'),WordExample('صَديقٌ','👫','صديق'),WordExample('صَحراءٌ','🏜️','صحراء')],
      kasraWords:[WordExample('صِحَّةٌ','💪','صحة')],
      dammaWords:[WordExample('صُورةٌ','🖼️','صورة')]),

    'ض': LetterData(letter:'ض',name:'ضاد',soundFatha:'ضَ',soundKasra:'ضِ',soundDamma:'ضُ',
      initialForm:'ضـ',medialForm:'ـضـ',finalForm:'ـض',confusedWith:['ص','ط'],
      fathaWords:[WordExample('ضَبٌّ','🦎','ضب'),WordExample('ضَفدَعٌ','🐸','ضفدع'),WordExample('ضَوءٌ','💡','ضوء'),WordExample('ضِيَاءٌ','🌟','ضياء'),WordExample('ضَبَّابٌ','🌫️','ضباب')],
      kasraWords:[WordExample('ضِيَاءٌ','🌟','ضياء')],
      dammaWords:[WordExample('ضُفدَعٌ','🐸','ضفدع')]),

    'ط': LetterData(letter:'ط',name:'طاء',soundFatha:'طَ',soundKasra:'طِ',soundDamma:'طُ',
      initialForm:'طـ',medialForm:'ـطـ',finalForm:'ـط',confusedWith:['ض','ظ'],
      fathaWords:[WordExample('طَائرةٌ','✈️','طائرة'),WordExample('طَاوِلةٌ','🪑','طاولة'),WordExample('طَبَّاخٌ','👨‍🍳','طباخ'),WordExample('طَريقٌ','🛣️','طريق'),WordExample('طَبلٌ','🥁','طبل')],
      kasraWords:[WordExample('طِفلٌ','👶','طفل')],
      dammaWords:[WordExample('طُيورٌ','🐦','طيور')]),

    'ظ': LetterData(letter:'ظ',name:'ظاء',soundFatha:'ظَ',soundKasra:'ظِ',soundDamma:'ظُ',
      initialForm:'ظـ',medialForm:'ـظـ',finalForm:'ـظ',confusedWith:['ط'],
      fathaWords:[WordExample('ظَبيٌ','🦌','ظبي'),WordExample('ظَلامٌ','🌑','ظلام'),WordExample('ظَرفٌ','✉️','ظرف'),WordExample('ظِلٌّ','🌳','ظل'),WordExample('ظَهرٌ','🌅','ظهر')],
      kasraWords:[WordExample('ظِلٌّ','🌳','ظل')],
      dammaWords:[WordExample('ظُلمٌ','⚖️','ظلم')]),

    'ع': LetterData(letter:'ع',name:'عين',soundFatha:'عَ',soundKasra:'عِ',soundDamma:'عُ',
      initialForm:'عـ',medialForm:'ـعـ',finalForm:'ـع',confusedWith:['غ'],
      fathaWords:[WordExample('عَقرَبٌ','🦂','عقرب'),WordExample('عَصفورٌ','🐦','عصفور'),WordExample('عُنُقودٌ','🍇','عنقود'),WordExample('عَينٌ','👁️','عين'),WordExample('عَسَلٌ','🍯','عسل')],
      kasraWords:[WordExample('عِنَبٌ','🍇','عنب')],
      dammaWords:[WordExample('عُصفورٌ','🐦','عصفور')]),

    'غ': LetterData(letter:'غ',name:'غين',soundFatha:'غَ',soundKasra:'غِ',soundDamma:'غُ',
      initialForm:'غـ',medialForm:'ـغـ',finalForm:'ـغ',confusedWith:['ع'],
      fathaWords:[WordExample('غَزَالٌ','🦌','غزال'),WordExample('غَابةٌ','🌲','غابة'),WordExample('غَيمةٌ','☁️','غيمة'),WordExample('غُرابٌ','🐦‍⬛','غراب'),WordExample('غَسَّالةٌ','🫧','غسالة')],
      kasraWords:[WordExample('غِطَاءٌ','🛏️','غطاء')],
      dammaWords:[WordExample('غُرابٌ','🐦‍⬛','غراب')]),

    'ف': LetterData(letter:'ف',name:'فاء',soundFatha:'فَ',soundKasra:'فِ',soundDamma:'فُ',
      initialForm:'فـ',medialForm:'ـفـ',finalForm:'ـف',confusedWith:['ق'],
      fathaWords:[WordExample('فَراشةٌ','🦋','فراشة'),WordExample('فِيلٌ','🐘','فيل'),WordExample('فَنَّانٌ','🎨','فنان'),WordExample('فَاكِهةٌ','🍊','فاكهة'),WordExample('فَندَقٌ','🏨','فندق')],
      kasraWords:[WordExample('فِيلٌ','🐘','فيل')],
      dammaWords:[WordExample('فُستانٌ','👗','فستان')]),

    'ق': LetterData(letter:'ق',name:'قاف',soundFatha:'قَ',soundKasra:'قِ',soundDamma:'قُ',
      initialForm:'قـ',medialForm:'ـقـ',finalForm:'ـق',confusedWith:['ف'],
      fathaWords:[WordExample('قِطَّةٌ','🐱','قطة'),WordExample('قَمَرٌ','🌙','قمر'),WordExample('قَلَمٌ','✏️','قلم'),WordExample('قِردٌ','🐒','قرد'),WordExample('قُبَّعةٌ','🎩','قبعة')],
      kasraWords:[WordExample('قِطَّةٌ','🐱','قطة')],
      dammaWords:[WordExample('قُبَّعةٌ','🎩','قبعة')]),

    'ك': LetterData(letter:'ك',name:'كاف',soundFatha:'كَ',soundKasra:'كِ',soundDamma:'كُ',
      initialForm:'كـ',medialForm:'ـكـ',finalForm:'ـك',confusedWith:['ق'],
      fathaWords:[WordExample('كَلبٌ','🐶','كلب'),WordExample('كِتابٌ','📖','كتاب'),WordExample('كُرةٌ','⚽','كرة'),WordExample('كَعكةٌ','🎂','كعكة'),WordExample('كَنغَرٌ','🦘','كنغر')],
      kasraWords:[WordExample('كِتابٌ','📖','كتاب')],
      dammaWords:[WordExample('كُرةٌ','⚽','كرة')]),

    'ل': LetterData(letter:'ل',name:'لام',soundFatha:'لَ',soundKasra:'لِ',soundDamma:'لُ',
      initialForm:'لـ',medialForm:'ـلـ',finalForm:'ـل',confusedWith:['ك'],
      fathaWords:[WordExample('لَبَنٌ','🥛','لبن'),WordExample('لَيمونٌ','🍋','ليمون'),WordExample('لُعبةٌ','🎮','لعبة'),WordExample('لَونٌ','🎨','لون'),WordExample('لِسانٌ','👅','لسان')],
      kasraWords:[WordExample('لِسانٌ','👅','لسان')],
      dammaWords:[WordExample('لُعبةٌ','🎮','لعبة')]),

    'م': LetterData(letter:'م',name:'ميم',soundFatha:'مَ',soundKasra:'مِ',soundDamma:'مُ',
      initialForm:'مـ',medialForm:'ـمـ',finalForm:'ـم',confusedWith:['ب'],
      fathaWords:[WordExample('مَاءٌ','💧','ماء'),WordExample('مَنزِلٌ','🏡','منزل'),WordExample('مَوزٌ','🍌','موز'),WordExample('مِظَلَّةٌ','☂️','مظلة'),WordExample('مِفتاحٌ','🗝️','مفتاح')],
      kasraWords:[WordExample('مِفتاحٌ','🗝️','مفتاح')],
      dammaWords:[WordExample('مُعَلِّمٌ','👨‍🏫','معلم')]),

    'ن': LetterData(letter:'ن',name:'نون',soundFatha:'نَ',soundKasra:'نِ',soundDamma:'نُ',
      initialForm:'نـ',medialForm:'ـنـ',finalForm:'ـن',confusedWith:['ب','ي'],
      fathaWords:[WordExample('نَجمةٌ','⭐','نجمة'),WordExample('نَملةٌ','🐜','نملة'),WordExample('نَهرٌ','🏞️','نهر'),WordExample('نُسورٌ','🦅','نسور'),WordExample('نَخلةٌ','🌴','نخلة')],
      kasraWords:[WordExample('نِعمةٌ','🙏','نعمة')],
      dammaWords:[WordExample('نُجومٌ','⭐','نجوم')]),

    'ه': LetterData(letter:'ه',name:'هاء',soundFatha:'هَ',soundKasra:'هِ',soundDamma:'هُ',
      initialForm:'هـ',medialForm:'ـهـ',finalForm:'ـه',confusedWith:['ح'],
      fathaWords:[WordExample('هِرَّةٌ','🐱','هرة'),WordExample('هِلالٌ','🌙','هلال'),WordExample('هَاتِفٌ','📞','هاتف'),WordExample('هُدهُدٌ','🐦','هدهد'),WordExample('هِضابٌ','⛰️','هضاب')],
      kasraWords:[WordExample('هِلالٌ','🌙','هلال')],
      dammaWords:[WordExample('هُدهُدٌ','🐦','هدهد')]),

    'و': LetterData(letter:'و',name:'واو',soundFatha:'وَ',soundKasra:'وِ',soundDamma:'وُ',
      initialForm:'و',medialForm:'ـو',finalForm:'ـو',confusedWith:['ر'],
      fathaWords:[WordExample('وَردةٌ','🌹','وردة'),WordExample('وَطَنٌ','🏴','وطن'),WordExample('وَلَدٌ','👦','ولد'),WordExample('وِسادةٌ','🛏️','وسادة'),WordExample('وَقتٌ','⏰','وقت')],
      kasraWords:[WordExample('وِسادةٌ','🛏️','وسادة')],
      dammaWords:[WordExample('وُرودٌ','🌹','ورود')]),

    'ي': LetterData(letter:'ي',name:'ياء',soundFatha:'يَ',soundKasra:'يِ',soundDamma:'يُ',
      initialForm:'يـ',medialForm:'ـيـ',finalForm:'ـي',confusedWith:['ن'],
      fathaWords:[WordExample('يَدٌ','✋','يد'),WordExample('يَومٌ','📅','يوم'),WordExample('يَاسمينٌ','🌸','ياسمين'),WordExample('يَعسوبٌ','🦋','يعسوب'),WordExample('يَمامةٌ','🕊️','يمامة')],
      kasraWords:[WordExample('يَدٌ','✋','يد')],
      dammaWords:[WordExample('يُسرٌ','🌟','يسر')]),
  };

  static LetterData? get(String letter) => letters[letter];
  static List<String> get allLetters => letters.keys.toList();
}
