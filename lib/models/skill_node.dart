// ====================================================
// models/skill_node.dart
// شبكة المهارات — كل عقدة تمثل مهارة ذرية واحدة
// ====================================================

enum NodeStatus { unseen, learning, masteredTemp, review1, review2, masteredFinal }

enum NodeType {
  abstractPhonemeDicrimination, // NODE_01: سمعي فقط
  graphemePhonemeMapping,        // NODE_02: صوت + شكل
  shortVowelFatha,               // NODE_03: الفتحة
  positionalFormInitial,         // NODE_04: شكل الاتصال
  binaryBlending,                // NODE_05: دمج ثنائي
  // === Level 2: الحرف الساكن ===
  sukunCvcFatha,                 // L2_01: CVC مسبوق بفتح
  sukunCvcDamma,                 // L2_02: CVC مسبوق بضم
  sukunCvcKasra,                 // L2_03: CVC مسبوق بكسر
  multiSyllable,                 // L2_04: كلمات متعددة المقاطع
  verbConjugation,               // L2_05: تصريف الفعل المضارع
  // === Level 3: الأصوات الطويلة (المدود) ===
  longVowelAlif,                 // L3_01: مد الألف (فتحة + ا)
  longVowelYa,                   // L3_02: مد الياء (كسرة + ي)
  longVowelWaw,                  // L3_03: مد الواو (ضمة + و)
  longVowelAdvanced,             // L3_04: كلمات متقدمة + جمع التكسير
  // === Level 4: الحروف المشددة ===
  shaddaBasic,                   // L4_01: شدة بسيطة (قِطّة، حَبّة)
  shaddaProfession,              // L4_02: نمط فَعّال (غَفّار، كَذّاب)
  shaddaComplex,                 // L4_03: كلمات مركبة (مُعَلِّم، سَيّارَة)
  // === Level 5: التنوين ===
  tanwinFath,                    // L5_01: تنوين الفتح (ًـ)
  tanwinKasr,                    // L5_02: تنوين الكسر (ٍـ)
  tanwinDamm,                    // L5_03: تنوين الضم (ٌـ)
}

class SkillNode {
  final String id;           // 'NODE_01_baa'
  final NodeType type;
  final String letter;       // 'ب'
  final String sound;        // '/b/'
  final List<String> prerequisites; // IDs of required nodes
  final List<String> confusedWith;  // ['ت', 'ث', 'ن']

  const SkillNode({
    required this.id,
    required this.type,
    required this.letter,
    required this.sound,
    required this.prerequisites,
    required this.confusedWith,
  });
}

// ====================================================
// الـ DAG الأول — حرف الباء فقط (MVP)
// ====================================================
class SkillDAG {
  static const List<SkillNode> nodes = [
    SkillNode(
      id: 'NODE_01_baa',
      type: NodeType.abstractPhonemeDicrimination,
      letter: 'ب',
      sound: '/b/',
      prerequisites: [],
      confusedWith: ['م', 'ف'],
    ),
    SkillNode(
      id: 'NODE_02_baa',
      type: NodeType.graphemePhonemeMapping,
      letter: 'ب',
      sound: '/b/',
      prerequisites: ['NODE_01_baa'],
      confusedWith: ['ت', 'ث', 'ن'],
    ),
    SkillNode(
      id: 'NODE_03_baa',
      type: NodeType.shortVowelFatha,
      letter: 'ب',
      sound: '/ba/',
      prerequisites: ['NODE_02_baa'],
      confusedWith: ['تَ', 'ثَ'],
    ),
    SkillNode(
      id: 'NODE_04_baa',
      type: NodeType.positionalFormInitial,
      letter: 'ب',
      sound: '/b/',
      prerequisites: ['NODE_03_baa'],
      confusedWith: ['تـ', 'ثـ'],
    ),
    SkillNode(
      id: 'NODE_05_baa',
      type: NodeType.binaryBlending,
      letter: 'ب',
      sound: '/baa/',
      prerequisites: ['NODE_04_baa'],
      confusedWith: ['دَا', 'مَا'],
    ),

    // =========================================
    // حرف التاء — يُفتح بعد إتقان الباء
    // =========================================
    SkillNode(
      id: 'NODE_01_taa',
      type: NodeType.abstractPhonemeDicrimination,
      letter: 'ت',
      sound: '/t/',
      prerequisites: ['NODE_05_baa'], // يُفتح بعد إتقان الباء
      confusedWith: ['د', 'ك'],
    ),
    SkillNode(
      id: 'NODE_02_taa',
      type: NodeType.graphemePhonemeMapping,
      letter: 'ت',
      sound: '/t/',
      prerequisites: ['NODE_01_taa'],
      confusedWith: ['ب', 'ث'],
    ),
    SkillNode(
      id: 'NODE_03_taa',
      type: NodeType.shortVowelFatha,
      letter: 'ت',
      sound: '/ta/',
      prerequisites: ['NODE_02_taa'],
      confusedWith: ['بَ', 'ثَ'],
    ),
    SkillNode(
      id: 'NODE_04_taa',
      type: NodeType.positionalFormInitial,
      letter: 'ت',
      sound: '/t/',
      prerequisites: ['NODE_03_taa'],
      confusedWith: ['بـ', 'ثـ'],
    ),
    SkillNode(id:'NODE_05_taa',type:NodeType.binaryBlending,letter:'ت',sound:'/taa/',prerequisites:['NODE_04_taa'],confusedWith:['دَا','رَا']),

    // ث
    SkillNode(id:'NODE_01_tha',type:NodeType.abstractPhonemeDicrimination,letter:'ث',sound:'/θ/',prerequisites:['NODE_05_taa'],confusedWith:['ب','ت']),
    SkillNode(id:'NODE_02_tha',type:NodeType.graphemePhonemeMapping,letter:'ث',sound:'/θ/',prerequisites:['NODE_01_tha'],confusedWith:['ب','ت']),
    SkillNode(id:'NODE_03_tha',type:NodeType.shortVowelFatha,letter:'ث',sound:'/θa/',prerequisites:['NODE_02_tha'],confusedWith:['بَ','تَ']),
    SkillNode(id:'NODE_04_tha',type:NodeType.positionalFormInitial,letter:'ث',sound:'/θ/',prerequisites:['NODE_03_tha'],confusedWith:['بـ','تـ']),
    SkillNode(id:'NODE_05_tha',type:NodeType.binaryBlending,letter:'ث',sound:'/θaa/',prerequisites:['NODE_04_tha'],confusedWith:['تَا','بَا']),

    // ج
    SkillNode(id:'NODE_01_jeem',type:NodeType.abstractPhonemeDicrimination,letter:'ج',sound:'/dʒ/',prerequisites:['NODE_05_tha'],confusedWith:['ح','خ']),
    SkillNode(id:'NODE_02_jeem',type:NodeType.graphemePhonemeMapping,letter:'ج',sound:'/dʒ/',prerequisites:['NODE_01_jeem'],confusedWith:['ح','خ']),
    SkillNode(id:'NODE_03_jeem',type:NodeType.shortVowelFatha,letter:'ج',sound:'/dʒa/',prerequisites:['NODE_02_jeem'],confusedWith:['حَ','خَ']),
    SkillNode(id:'NODE_04_jeem',type:NodeType.positionalFormInitial,letter:'ج',sound:'/dʒ/',prerequisites:['NODE_03_jeem'],confusedWith:['حـ','خـ']),
    SkillNode(id:'NODE_05_jeem',type:NodeType.binaryBlending,letter:'ج',sound:'/dʒaa/',prerequisites:['NODE_04_jeem'],confusedWith:['حَا','خَا']),

    // ح
    SkillNode(id:'NODE_01_haa',type:NodeType.abstractPhonemeDicrimination,letter:'ح',sound:'/ħ/',prerequisites:['NODE_05_jeem'],confusedWith:['ج','خ']),
    SkillNode(id:'NODE_02_haa',type:NodeType.graphemePhonemeMapping,letter:'ح',sound:'/ħ/',prerequisites:['NODE_01_haa'],confusedWith:['ج','خ']),
    SkillNode(id:'NODE_03_haa',type:NodeType.shortVowelFatha,letter:'ح',sound:'/ħa/',prerequisites:['NODE_02_haa'],confusedWith:['جَ','خَ']),
    SkillNode(id:'NODE_04_haa',type:NodeType.positionalFormInitial,letter:'ح',sound:'/ħ/',prerequisites:['NODE_03_haa'],confusedWith:['جـ','خـ']),
    SkillNode(id:'NODE_05_haa',type:NodeType.binaryBlending,letter:'ح',sound:'/ħaa/',prerequisites:['NODE_04_haa'],confusedWith:['جَا','خَا']),

    // خ
    SkillNode(id:'NODE_01_kha',type:NodeType.abstractPhonemeDicrimination,letter:'خ',sound:'/x/',prerequisites:['NODE_05_haa'],confusedWith:['ح','ج']),
    SkillNode(id:'NODE_02_kha',type:NodeType.graphemePhonemeMapping,letter:'خ',sound:'/x/',prerequisites:['NODE_01_kha'],confusedWith:['ح','ج']),
    SkillNode(id:'NODE_03_kha',type:NodeType.shortVowelFatha,letter:'خ',sound:'/xa/',prerequisites:['NODE_02_kha'],confusedWith:['حَ','جَ']),
    SkillNode(id:'NODE_04_kha',type:NodeType.positionalFormInitial,letter:'خ',sound:'/x/',prerequisites:['NODE_03_kha'],confusedWith:['حـ','جـ']),
    SkillNode(id:'NODE_05_kha',type:NodeType.binaryBlending,letter:'خ',sound:'/xaa/',prerequisites:['NODE_04_kha'],confusedWith:['حَا','جَا']),

    // د
    SkillNode(id:'NODE_01_dal',type:NodeType.abstractPhonemeDicrimination,letter:'د',sound:'/d/',prerequisites:['NODE_05_kha'],confusedWith:['ذ']),
    SkillNode(id:'NODE_02_dal',type:NodeType.graphemePhonemeMapping,letter:'د',sound:'/d/',prerequisites:['NODE_01_dal'],confusedWith:['ذ']),
    SkillNode(id:'NODE_03_dal',type:NodeType.shortVowelFatha,letter:'د',sound:'/da/',prerequisites:['NODE_02_dal'],confusedWith:['ذَ']),
    SkillNode(id:'NODE_04_dal',type:NodeType.positionalFormInitial,letter:'د',sound:'/d/',prerequisites:['NODE_03_dal'],confusedWith:['ذ']),
    SkillNode(id:'NODE_05_dal',type:NodeType.binaryBlending,letter:'د',sound:'/daa/',prerequisites:['NODE_04_dal'],confusedWith:['ذَا','رَا']),

    // ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي
    SkillNode(id:'NODE_01_dhal',type:NodeType.abstractPhonemeDicrimination,letter:'ذ',sound:'/ð/',prerequisites:['NODE_05_dal'],confusedWith:['د']),
    SkillNode(id:'NODE_02_dhal',type:NodeType.graphemePhonemeMapping,letter:'ذ',sound:'/ð/',prerequisites:['NODE_01_dhal'],confusedWith:['د']),
    SkillNode(id:'NODE_03_dhal',type:NodeType.shortVowelFatha,letter:'ذ',sound:'/ða/',prerequisites:['NODE_02_dhal'],confusedWith:['دَ']),
    SkillNode(id:'NODE_04_dhal',type:NodeType.positionalFormInitial,letter:'ذ',sound:'/ð/',prerequisites:['NODE_03_dhal'],confusedWith:['د']),
    SkillNode(id:'NODE_05_dhal',type:NodeType.binaryBlending,letter:'ذ',sound:'/ðaa/',prerequisites:['NODE_04_dhal'],confusedWith:['دَا','رَا']),

    SkillNode(id:'NODE_01_ra',type:NodeType.abstractPhonemeDicrimination,letter:'ر',sound:'/r/',prerequisites:['NODE_05_dhal'],confusedWith:['ز']),
    SkillNode(id:'NODE_02_ra',type:NodeType.graphemePhonemeMapping,letter:'ر',sound:'/r/',prerequisites:['NODE_01_ra'],confusedWith:['ز']),
    SkillNode(id:'NODE_03_ra',type:NodeType.shortVowelFatha,letter:'ر',sound:'/ra/',prerequisites:['NODE_02_ra'],confusedWith:['زَ']),
    SkillNode(id:'NODE_04_ra',type:NodeType.positionalFormInitial,letter:'ر',sound:'/r/',prerequisites:['NODE_03_ra'],confusedWith:['ز']),
    SkillNode(id:'NODE_05_ra',type:NodeType.binaryBlending,letter:'ر',sound:'/raa/',prerequisites:['NODE_04_ra'],confusedWith:['زَا','دَا']),

    SkillNode(id:'NODE_01_zay',type:NodeType.abstractPhonemeDicrimination,letter:'ز',sound:'/z/',prerequisites:['NODE_05_ra'],confusedWith:['ر']),
    SkillNode(id:'NODE_02_zay',type:NodeType.graphemePhonemeMapping,letter:'ز',sound:'/z/',prerequisites:['NODE_01_zay'],confusedWith:['ر']),
    SkillNode(id:'NODE_03_zay',type:NodeType.shortVowelFatha,letter:'ز',sound:'/za/',prerequisites:['NODE_02_zay'],confusedWith:['رَ']),
    SkillNode(id:'NODE_04_zay',type:NodeType.positionalFormInitial,letter:'ز',sound:'/z/',prerequisites:['NODE_03_zay'],confusedWith:['ر']),
    SkillNode(id:'NODE_05_zay',type:NodeType.binaryBlending,letter:'ز',sound:'/zaa/',prerequisites:['NODE_04_zay'],confusedWith:['رَا','سَا']),

    SkillNode(id:'NODE_01_sin',type:NodeType.abstractPhonemeDicrimination,letter:'س',sound:'/s/',prerequisites:['NODE_05_zay'],confusedWith:['ش','ص']),
    SkillNode(id:'NODE_02_sin',type:NodeType.graphemePhonemeMapping,letter:'س',sound:'/s/',prerequisites:['NODE_01_sin'],confusedWith:['ش','ص']),
    SkillNode(id:'NODE_03_sin',type:NodeType.shortVowelFatha,letter:'س',sound:'/sa/',prerequisites:['NODE_02_sin'],confusedWith:['شَ','صَ']),
    SkillNode(id:'NODE_04_sin',type:NodeType.positionalFormInitial,letter:'س',sound:'/s/',prerequisites:['NODE_03_sin'],confusedWith:['شـ','صـ']),
    SkillNode(id:'NODE_05_sin',type:NodeType.binaryBlending,letter:'س',sound:'/saa/',prerequisites:['NODE_04_sin'],confusedWith:['شَا','صَا']),

    SkillNode(id:'NODE_01_shin',type:NodeType.abstractPhonemeDicrimination,letter:'ش',sound:'/ʃ/',prerequisites:['NODE_05_sin'],confusedWith:['س']),
    SkillNode(id:'NODE_02_shin',type:NodeType.graphemePhonemeMapping,letter:'ش',sound:'/ʃ/',prerequisites:['NODE_01_shin'],confusedWith:['س']),
    SkillNode(id:'NODE_03_shin',type:NodeType.shortVowelFatha,letter:'ش',sound:'/ʃa/',prerequisites:['NODE_02_shin'],confusedWith:['سَ']),
    SkillNode(id:'NODE_04_shin',type:NodeType.positionalFormInitial,letter:'ش',sound:'/ʃ/',prerequisites:['NODE_03_shin'],confusedWith:['سـ']),
    SkillNode(id:'NODE_05_shin',type:NodeType.binaryBlending,letter:'ش',sound:'/ʃaa/',prerequisites:['NODE_04_shin'],confusedWith:['سَا','صَا']),

    SkillNode(id:'NODE_01_sad',type:NodeType.abstractPhonemeDicrimination,letter:'ص',sound:'/sˤ/',prerequisites:['NODE_05_shin'],confusedWith:['س','ض']),
    SkillNode(id:'NODE_02_sad',type:NodeType.graphemePhonemeMapping,letter:'ص',sound:'/sˤ/',prerequisites:['NODE_01_sad'],confusedWith:['س','ض']),
    SkillNode(id:'NODE_03_sad',type:NodeType.shortVowelFatha,letter:'ص',sound:'/sˤa/',prerequisites:['NODE_02_sad'],confusedWith:['سَ','ضَ']),
    SkillNode(id:'NODE_04_sad',type:NodeType.positionalFormInitial,letter:'ص',sound:'/sˤ/',prerequisites:['NODE_03_sad'],confusedWith:['سـ','ضـ']),
    SkillNode(id:'NODE_05_sad',type:NodeType.binaryBlending,letter:'ص',sound:'/sˤaa/',prerequisites:['NODE_04_sad'],confusedWith:['سَا','ضَا']),

    SkillNode(id:'NODE_01_dad',type:NodeType.abstractPhonemeDicrimination,letter:'ض',sound:'/dˤ/',prerequisites:['NODE_05_sad'],confusedWith:['ص','ط']),
    SkillNode(id:'NODE_02_dad',type:NodeType.graphemePhonemeMapping,letter:'ض',sound:'/dˤ/',prerequisites:['NODE_01_dad'],confusedWith:['ص','ط']),
    SkillNode(id:'NODE_03_dad',type:NodeType.shortVowelFatha,letter:'ض',sound:'/dˤa/',prerequisites:['NODE_02_dad'],confusedWith:['صَ','طَ']),
    SkillNode(id:'NODE_04_dad',type:NodeType.positionalFormInitial,letter:'ض',sound:'/dˤ/',prerequisites:['NODE_03_dad'],confusedWith:['صـ','طـ']),
    SkillNode(id:'NODE_05_dad',type:NodeType.binaryBlending,letter:'ض',sound:'/dˤaa/',prerequisites:['NODE_04_dad'],confusedWith:['صَا','طَا']),

    SkillNode(id:'NODE_01_ta2',type:NodeType.abstractPhonemeDicrimination,letter:'ط',sound:'/tˤ/',prerequisites:['NODE_05_dad'],confusedWith:['ض','ظ']),
    SkillNode(id:'NODE_02_ta2',type:NodeType.graphemePhonemeMapping,letter:'ط',sound:'/tˤ/',prerequisites:['NODE_01_ta2'],confusedWith:['ض','ظ']),
    SkillNode(id:'NODE_03_ta2',type:NodeType.shortVowelFatha,letter:'ط',sound:'/tˤa/',prerequisites:['NODE_02_ta2'],confusedWith:['ضَ','ظَ']),
    SkillNode(id:'NODE_04_ta2',type:NodeType.positionalFormInitial,letter:'ط',sound:'/tˤ/',prerequisites:['NODE_03_ta2'],confusedWith:['ضـ','ظـ']),
    SkillNode(id:'NODE_05_ta2',type:NodeType.binaryBlending,letter:'ط',sound:'/tˤaa/',prerequisites:['NODE_04_ta2'],confusedWith:['ضَا','ظَا']),

    SkillNode(id:'NODE_01_dha2',type:NodeType.abstractPhonemeDicrimination,letter:'ظ',sound:'/ðˤ/',prerequisites:['NODE_05_ta2'],confusedWith:['ط']),
    SkillNode(id:'NODE_02_dha2',type:NodeType.graphemePhonemeMapping,letter:'ظ',sound:'/ðˤ/',prerequisites:['NODE_01_dha2'],confusedWith:['ط']),
    SkillNode(id:'NODE_03_dha2',type:NodeType.shortVowelFatha,letter:'ظ',sound:'/ðˤa/',prerequisites:['NODE_02_dha2'],confusedWith:['طَ']),
    SkillNode(id:'NODE_04_dha2',type:NodeType.positionalFormInitial,letter:'ظ',sound:'/ðˤ/',prerequisites:['NODE_03_dha2'],confusedWith:['طـ']),
    SkillNode(id:'NODE_05_dha2',type:NodeType.binaryBlending,letter:'ظ',sound:'/ðˤaa/',prerequisites:['NODE_04_dha2'],confusedWith:['طَا']),

    SkillNode(id:'NODE_01_ain',type:NodeType.abstractPhonemeDicrimination,letter:'ع',sound:'/ʕ/',prerequisites:['NODE_05_dha2'],confusedWith:['غ']),
    SkillNode(id:'NODE_02_ain',type:NodeType.graphemePhonemeMapping,letter:'ع',sound:'/ʕ/',prerequisites:['NODE_01_ain'],confusedWith:['غ']),
    SkillNode(id:'NODE_03_ain',type:NodeType.shortVowelFatha,letter:'ع',sound:'/ʕa/',prerequisites:['NODE_02_ain'],confusedWith:['غَ']),
    SkillNode(id:'NODE_04_ain',type:NodeType.positionalFormInitial,letter:'ع',sound:'/ʕ/',prerequisites:['NODE_03_ain'],confusedWith:['غـ']),
    SkillNode(id:'NODE_05_ain',type:NodeType.binaryBlending,letter:'ع',sound:'/ʕaa/',prerequisites:['NODE_04_ain'],confusedWith:['غَا']),

    SkillNode(id:'NODE_01_ghain',type:NodeType.abstractPhonemeDicrimination,letter:'غ',sound:'/ɣ/',prerequisites:['NODE_05_ain'],confusedWith:['ع']),
    SkillNode(id:'NODE_02_ghain',type:NodeType.graphemePhonemeMapping,letter:'غ',sound:'/ɣ/',prerequisites:['NODE_01_ghain'],confusedWith:['ع']),
    SkillNode(id:'NODE_03_ghain',type:NodeType.shortVowelFatha,letter:'غ',sound:'/ɣa/',prerequisites:['NODE_02_ghain'],confusedWith:['عَ']),
    SkillNode(id:'NODE_04_ghain',type:NodeType.positionalFormInitial,letter:'غ',sound:'/ɣ/',prerequisites:['NODE_03_ghain'],confusedWith:['عـ']),
    SkillNode(id:'NODE_05_ghain',type:NodeType.binaryBlending,letter:'غ',sound:'/ɣaa/',prerequisites:['NODE_04_ghain'],confusedWith:['عَا']),

    SkillNode(id:'NODE_01_fa',type:NodeType.abstractPhonemeDicrimination,letter:'ف',sound:'/f/',prerequisites:['NODE_05_ghain'],confusedWith:['ق']),
    SkillNode(id:'NODE_02_fa',type:NodeType.graphemePhonemeMapping,letter:'ف',sound:'/f/',prerequisites:['NODE_01_fa'],confusedWith:['ق']),
    SkillNode(id:'NODE_03_fa',type:NodeType.shortVowelFatha,letter:'ف',sound:'/fa/',prerequisites:['NODE_02_fa'],confusedWith:['قَ']),
    SkillNode(id:'NODE_04_fa',type:NodeType.positionalFormInitial,letter:'ف',sound:'/f/',prerequisites:['NODE_03_fa'],confusedWith:['قـ']),
    SkillNode(id:'NODE_05_fa',type:NodeType.binaryBlending,letter:'ف',sound:'/faa/',prerequisites:['NODE_04_fa'],confusedWith:['قَا']),

    SkillNode(id:'NODE_01_qaf',type:NodeType.abstractPhonemeDicrimination,letter:'ق',sound:'/q/',prerequisites:['NODE_05_fa'],confusedWith:['ف']),
    SkillNode(id:'NODE_02_qaf',type:NodeType.graphemePhonemeMapping,letter:'ق',sound:'/q/',prerequisites:['NODE_01_qaf'],confusedWith:['ف']),
    SkillNode(id:'NODE_03_qaf',type:NodeType.shortVowelFatha,letter:'ق',sound:'/qa/',prerequisites:['NODE_02_qaf'],confusedWith:['فَ']),
    SkillNode(id:'NODE_04_qaf',type:NodeType.positionalFormInitial,letter:'ق',sound:'/q/',prerequisites:['NODE_03_qaf'],confusedWith:['فـ']),
    SkillNode(id:'NODE_05_qaf',type:NodeType.binaryBlending,letter:'ق',sound:'/qaa/',prerequisites:['NODE_04_qaf'],confusedWith:['فَا']),

    SkillNode(id:'NODE_01_kaf',type:NodeType.abstractPhonemeDicrimination,letter:'ك',sound:'/k/',prerequisites:['NODE_05_qaf'],confusedWith:['ق']),
    SkillNode(id:'NODE_02_kaf',type:NodeType.graphemePhonemeMapping,letter:'ك',sound:'/k/',prerequisites:['NODE_01_kaf'],confusedWith:['ق']),
    SkillNode(id:'NODE_03_kaf',type:NodeType.shortVowelFatha,letter:'ك',sound:'/ka/',prerequisites:['NODE_02_kaf'],confusedWith:['قَ']),
    SkillNode(id:'NODE_04_kaf',type:NodeType.positionalFormInitial,letter:'ك',sound:'/k/',prerequisites:['NODE_03_kaf'],confusedWith:['قـ']),
    SkillNode(id:'NODE_05_kaf',type:NodeType.binaryBlending,letter:'ك',sound:'/kaa/',prerequisites:['NODE_04_kaf'],confusedWith:['قَا']),

    SkillNode(id:'NODE_01_lam',type:NodeType.abstractPhonemeDicrimination,letter:'ل',sound:'/l/',prerequisites:['NODE_05_kaf'],confusedWith:['ك']),
    SkillNode(id:'NODE_02_lam',type:NodeType.graphemePhonemeMapping,letter:'ل',sound:'/l/',prerequisites:['NODE_01_lam'],confusedWith:['ك']),
    SkillNode(id:'NODE_03_lam',type:NodeType.shortVowelFatha,letter:'ل',sound:'/la/',prerequisites:['NODE_02_lam'],confusedWith:['كَ']),
    SkillNode(id:'NODE_04_lam',type:NodeType.positionalFormInitial,letter:'ل',sound:'/l/',prerequisites:['NODE_03_lam'],confusedWith:['كـ']),
    SkillNode(id:'NODE_05_lam',type:NodeType.binaryBlending,letter:'ل',sound:'/laa/',prerequisites:['NODE_04_lam'],confusedWith:['كَا','مَا']),

    SkillNode(id:'NODE_01_mim',type:NodeType.abstractPhonemeDicrimination,letter:'م',sound:'/m/',prerequisites:['NODE_05_lam'],confusedWith:['ب']),
    SkillNode(id:'NODE_02_mim',type:NodeType.graphemePhonemeMapping,letter:'م',sound:'/m/',prerequisites:['NODE_01_mim'],confusedWith:['ب']),
    SkillNode(id:'NODE_03_mim',type:NodeType.shortVowelFatha,letter:'م',sound:'/ma/',prerequisites:['NODE_02_mim'],confusedWith:['بَ']),
    SkillNode(id:'NODE_04_mim',type:NodeType.positionalFormInitial,letter:'م',sound:'/m/',prerequisites:['NODE_03_mim'],confusedWith:['بـ']),
    SkillNode(id:'NODE_05_mim',type:NodeType.binaryBlending,letter:'م',sound:'/maa/',prerequisites:['NODE_04_mim'],confusedWith:['بَا','لَا']),

    SkillNode(id:'NODE_01_nun',type:NodeType.abstractPhonemeDicrimination,letter:'ن',sound:'/n/',prerequisites:['NODE_05_mim'],confusedWith:['ب','ي']),
    SkillNode(id:'NODE_02_nun',type:NodeType.graphemePhonemeMapping,letter:'ن',sound:'/n/',prerequisites:['NODE_01_nun'],confusedWith:['ب','ي']),
    SkillNode(id:'NODE_03_nun',type:NodeType.shortVowelFatha,letter:'ن',sound:'/na/',prerequisites:['NODE_02_nun'],confusedWith:['بَ','يَ']),
    SkillNode(id:'NODE_04_nun',type:NodeType.positionalFormInitial,letter:'ن',sound:'/n/',prerequisites:['NODE_03_nun'],confusedWith:['بـ','يـ']),
    SkillNode(id:'NODE_05_nun',type:NodeType.binaryBlending,letter:'ن',sound:'/naa/',prerequisites:['NODE_04_nun'],confusedWith:['مَا','يَا']),

    SkillNode(id:'NODE_01_ha',type:NodeType.abstractPhonemeDicrimination,letter:'ه',sound:'/h/',prerequisites:['NODE_05_nun'],confusedWith:['ح']),
    SkillNode(id:'NODE_02_ha',type:NodeType.graphemePhonemeMapping,letter:'ه',sound:'/h/',prerequisites:['NODE_01_ha'],confusedWith:['ح']),
    SkillNode(id:'NODE_03_ha',type:NodeType.shortVowelFatha,letter:'ه',sound:'/ha/',prerequisites:['NODE_02_ha'],confusedWith:['حَ']),
    SkillNode(id:'NODE_04_ha',type:NodeType.positionalFormInitial,letter:'ه',sound:'/h/',prerequisites:['NODE_03_ha'],confusedWith:['حـ']),
    SkillNode(id:'NODE_05_ha',type:NodeType.binaryBlending,letter:'ه',sound:'/haa/',prerequisites:['NODE_04_ha'],confusedWith:['حَا']),

    SkillNode(id:'NODE_01_waw',type:NodeType.abstractPhonemeDicrimination,letter:'و',sound:'/w/',prerequisites:['NODE_05_ha'],confusedWith:['ر']),
    SkillNode(id:'NODE_02_waw',type:NodeType.graphemePhonemeMapping,letter:'و',sound:'/w/',prerequisites:['NODE_01_waw'],confusedWith:['ر']),
    SkillNode(id:'NODE_03_waw',type:NodeType.shortVowelFatha,letter:'و',sound:'/wa/',prerequisites:['NODE_02_waw'],confusedWith:['رَ']),
    SkillNode(id:'NODE_04_waw',type:NodeType.positionalFormInitial,letter:'و',sound:'/w/',prerequisites:['NODE_03_waw'],confusedWith:['ر']),
    SkillNode(id:'NODE_05_waw',type:NodeType.binaryBlending,letter:'و',sound:'/waa/',prerequisites:['NODE_04_waw'],confusedWith:['رَا','يَا']),

    SkillNode(id:'NODE_01_ya',type:NodeType.abstractPhonemeDicrimination,letter:'ي',sound:'/j/',prerequisites:['NODE_05_waw'],confusedWith:['ن']),
    SkillNode(id:'NODE_02_ya',type:NodeType.graphemePhonemeMapping,letter:'ي',sound:'/j/',prerequisites:['NODE_01_ya'],confusedWith:['ن']),
    SkillNode(id:'NODE_03_ya',type:NodeType.shortVowelFatha,letter:'ي',sound:'/ja/',prerequisites:['NODE_02_ya'],confusedWith:['نَ']),
    SkillNode(id:'NODE_04_ya',type:NodeType.positionalFormInitial,letter:'ي',sound:'/j/',prerequisites:['NODE_03_ya'],confusedWith:['نـ']),
    SkillNode(id:'NODE_05_ya',type:NodeType.binaryBlending,letter:'ي',sound:'/jaa/',prerequisites:['NODE_04_ya'],confusedWith:['نَا','وَا']),

    // ===================================================
    // المستوى الثاني — الحرف الساكن (يُفتح بعد إتقان ي)
    // ===================================================

    // L2_01: CVC مسبوق بفتح (فَأْس، بَيْت، شَمْس...)
    SkillNode(id:'L2_01_cvc_fatha',type:NodeType.sukunCvcFatha,letter:'◌ْ',sound:'CVC-a',prerequisites:['NODE_05_ya'],confusedWith:[]),

    // L2_02: CVC مسبوق بضم (بُرْج، أُخْت...)
    SkillNode(id:'L2_02_cvc_damma',type:NodeType.sukunCvcDamma,letter:'◌ْ',sound:'CVC-u',prerequisites:['L2_01_cvc_fatha'],confusedWith:[]),

    // L2_03: CVC مسبوق بكسر (بِنْت، طِفْل...)
    SkillNode(id:'L2_03_cvc_kasra',type:NodeType.sukunCvcKasra,letter:'◌ْ',sound:'CVC-i',prerequisites:['L2_02_cvc_damma'],confusedWith:[]),

    // L2_04: كلمات متعددة المقاطع (مَدْرَسة، أَرْنَب...)
    SkillNode(id:'L2_04_multi',type:NodeType.multiSyllable,letter:'◌ْ',sound:'multi',prerequisites:['L2_03_cvc_kasra'],confusedWith:[]),

    // L2_05: تصريف الفعل المضارع (أَكْتُب، نَكْتُب...)
    SkillNode(id:'L2_05_verb',type:NodeType.verbConjugation,letter:'◌ْ',sound:'verb',prerequisites:['L2_04_multi'],confusedWith:[]),

    // ===================================================
    // المستوى الثالث — الأصوات الطويلة (يُفتح بعد L2_05)
    // ===================================================

    // L3_01: مد الألف (فختح + ا): بَاب، تَاج، نَار...
    SkillNode(id:'L3_01_alif',type:NodeType.longVowelAlif,letter:'ا',sound:'medd-a',prerequisites:['L2_05_verb'],confusedWith:[]),

    // L3_02: مد الياء (كسرة + ي): فِيل، دِيك، عِيد...
    SkillNode(id:'L3_02_ya',type:NodeType.longVowelYa,letter:'ي',sound:'medd-i',prerequisites:['L3_01_alif'],confusedWith:[]),

    // L3_03: مد الواو (ضمة + و): حُوت، كُوب، نُور...
    SkillNode(id:'L3_03_waw',type:NodeType.longVowelWaw,letter:'و',sound:'medd-u',prerequisites:['L3_02_ya'],confusedWith:[]),

    // L3_04: كلمات متقدمة + جمع التكسير: مدارس، مصانع...
    SkillNode(id:'L3_04_adv',type:NodeType.longVowelAdvanced,letter:'المد',sound:'adv',prerequisites:['L3_03_waw'],confusedWith:[]),

    // ===================================================
    // المستوى الرابع — الحروف المشددة (L3_04 →)
    // ===================================================
    SkillNode(id:'L4_01_shadda',type:NodeType.shaddaBasic,letter:'ّ',sound:'shadda-basic',prerequisites:['L3_04_adv'],confusedWith:[]),
    SkillNode(id:'L4_02_prof',type:NodeType.shaddaProfession,letter:'ّ',sound:'shadda-prof',prerequisites:['L4_01_shadda'],confusedWith:[]),
    SkillNode(id:'L4_03_complex',type:NodeType.shaddaComplex,letter:'ّ',sound:'shadda-complex',prerequisites:['L4_02_prof'],confusedWith:[]),

    // ===================================================
    // المستوى الخامس — التنوين (L4_03 →)
    // ===================================================
    SkillNode(id:'L5_01_tanwin_fath',type:NodeType.tanwinFath,letter:'ً',sound:'tanwin-fath',prerequisites:['L4_03_complex'],confusedWith:[]),
    SkillNode(id:'L5_02_tanwin_kasr',type:NodeType.tanwinKasr,letter:'ٍ',sound:'tanwin-kasr',prerequisites:['L5_01_tanwin_fath'],confusedWith:[]),
    SkillNode(id:'L5_03_tanwin_damm',type:NodeType.tanwinDamm,letter:'ٌ',sound:'tanwin-damm',prerequisites:['L5_02_tanwin_kasr'],confusedWith:[]),
  ];

  static SkillNode? getById(String id) {
    try {
      return nodes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }
}
