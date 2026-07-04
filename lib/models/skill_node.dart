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
    SkillNode(
      id: 'NODE_05_taa',
      type: NodeType.binaryBlending,
      letter: 'ت',
      sound: '/taa/',
      prerequisites: ['NODE_04_taa'],
      confusedWith: ['دَا', 'رَا'],
    ),
  ];

  static SkillNode? getById(String id) {
    try {
      return nodes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }
}
