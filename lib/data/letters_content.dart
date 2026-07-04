// ====================================================
// data/letters_content.dart
// مستودع المحتوى — كل الحروف × كل الحركات × الكلمات
// هذا ملف البيانات المنفصل عن الـ Screens تماماً
// ====================================================

class LetterData {
  final String letter;           // ب
  final String name;             // باء
  final String soundFatha;       // بَ
  final String soundKasra;       // بِ
  final String soundDamma;       // بُ
  final String initialForm;      // بـ
  final String medialForm;       // ـبـ
  final String finalForm;        // ـب
  final List<String> confusedWith;
  final List<WordExample> fathaWords;
  final List<WordExample> kasraWords;
  final List<WordExample> dammaWords;

  const LetterData({
    required this.letter,
    required this.name,
    required this.soundFatha,
    required this.soundKasra,
    required this.soundDamma,
    required this.initialForm,
    required this.medialForm,
    required this.finalForm,
    required this.confusedWith,
    required this.fathaWords,
    required this.kasraWords,
    required this.dammaWords,
  });
}

class WordExample {
  final String word;
  final String emoji;
  final String ttsText; // النص الذي يُقال للـ TTS
  const WordExample(this.word, this.emoji, this.ttsText);
}

// ====================================================
// قاموس الحروف الكامل (28 حرف — مكتمل لحد الآن: ب، ت)
// ====================================================
class ArabicLettersDB {
  static const Map<String, LetterData> letters = {

    // =========================================
    // حرف الباء
    // =========================================
    'ب': LetterData(
      letter: 'ب',
      name: 'باء',
      soundFatha: 'بَ',
      soundKasra: 'بِ',
      soundDamma: 'بُ',
      initialForm: 'بـ',
      medialForm: 'ـبـ',
      finalForm: 'ـب',
      confusedWith: ['ت', 'ث', 'ن'],
      fathaWords: [
        WordExample('بَابٌ', '🚪', 'باب'),
        WordExample('بَقَرَةٌ', '🐄', 'بقرة'),
        WordExample('بَطَّةٌ', '🦆', 'بطة'),
        WordExample('بَيتٌ', '🏠', 'بيت'),
        WordExample('بَحَرٌ', '🌊', 'بحر'),
      ],
      kasraWords: [
        WordExample('بِئرٌ', '🕳️', 'بئر'),
        WordExample('بِدايةٌ', '🌅', 'بداية'),
      ],
      dammaWords: [
        WordExample('بُرجٌ', '🗼', 'برج'),
        WordExample('بُستانٌ', '🌳', 'بستان'),
      ],
    ),

    // =========================================
    // حرف التاء
    // =========================================
    'ت': LetterData(
      letter: 'ت',
      name: 'تاء',
      soundFatha: 'تَ',
      soundKasra: 'تِ',
      soundDamma: 'تُ',
      initialForm: 'تـ',
      medialForm: 'ـتـ',
      finalForm: 'ـت',
      confusedWith: ['ب', 'ث'],
      fathaWords: [
        WordExample('تَمرٌ', '🌴', 'تمر'),
        WordExample('تُفَّاحٌ', '🍎', 'تفاح'),
        WordExample('تِمسَاحٌ', '🐊', 'تمساح'),
        WordExample('تَاجٌ', '👑', 'تاج'),
        WordExample('تَلَّةٌ', '⛰️', 'تلة'),
      ],
      kasraWords: [
        WordExample('تِلميذٌ', '👦', 'تلميذ'),
        WordExample('تِجارةٌ', '💰', 'تجارة'),
      ],
      dammaWords: [
        WordExample('تُفَّاحٌ', '🍎', 'تفاح'),
        WordExample('تُرابٌ', '🌿', 'تراب'),
      ],
    ),

    // =========================================
    // حرف الثاء
    // =========================================
    'ث': LetterData(
      letter: 'ث',
      name: 'ثاء',
      soundFatha: 'ثَ',
      soundKasra: 'ثِ',
      soundDamma: 'ثُ',
      initialForm: 'ثـ',
      medialForm: 'ـثـ',
      finalForm: 'ـث',
      confusedWith: ['ب', 'ت'],
      fathaWords: [
        WordExample('ثَعلَبٌ', '🦊', 'ثعلب'),
        WordExample('ثَورٌ', '🐂', 'ثور'),
        WordExample('ثَمَرٌ', '🍇', 'ثمر'),
      ],
      kasraWords: [
        WordExample('ثِقَةٌ', '🤝', 'ثقة'),
      ],
      dammaWords: [
        WordExample('ثُلُوثٌ', '⅓', 'ثلوث'),
      ],
    ),

    // =========================================
    // حرف الجيم
    // =========================================
    'ج': LetterData(
      letter: 'ج',
      name: 'جيم',
      soundFatha: 'جَ',
      soundKasra: 'جِ',
      soundDamma: 'جُ',
      initialForm: 'جـ',
      medialForm: 'ـجـ',
      finalForm: 'ـج',
      confusedWith: ['ح', 'خ'],
      fathaWords: [
        WordExample('جَمَلٌ', '🐪', 'جمل'),
        WordExample('جَبَلٌ', '⛰️', 'جبل'),
        WordExample('جَزَرٌ', '🥕', 'جزر'),
      ],
      kasraWords: [
        WordExample('جِسرٌ', '🌉', 'جسر'),
      ],
      dammaWords: [
        WordExample('جُندِيٌّ', '💂', 'جندي'),
      ],
    ),
  };

  static LetterData? get(String letter) => letters[letter];

  static List<String> get allLetters => letters.keys.toList();
}
