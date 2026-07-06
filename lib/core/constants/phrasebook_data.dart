/// Common travel phrases grouped by language.
abstract final class PhrasebookData {
  static const languages = [
    PhrasebookLanguage(
      code: 'es',
      name: 'Spanish',
      flag: '🇪🇸',
      phrases: [
        Phrase(english: 'Hello', translation: 'Hola', pronunciation: 'OH-lah'),
        Phrase(english: 'Thank you', translation: 'Gracias', pronunciation: 'GRAH-see-ahs'),
        Phrase(english: 'Please', translation: 'Por favor', pronunciation: 'por fah-VOR'),
        Phrase(english: 'Excuse me', translation: 'Disculpe', pronunciation: 'dees-KOOL-peh'),
        Phrase(english: 'Where is…?', translation: '¿Dónde está…?', pronunciation: 'DON-deh es-TAH'),
        Phrase(english: 'How much?', translation: '¿Cuánto cuesta?', pronunciation: 'KWAN-toh KWES-tah'),
        Phrase(english: 'I need help', translation: 'Necesito ayuda', pronunciation: 'neh-seh-SEE-toh ah-YOO-dah'),
        Phrase(english: 'Water', translation: 'Agua', pronunciation: 'AH-gwah'),
        Phrase(english: 'The bill, please', translation: 'La cuenta, por favor', pronunciation: 'lah KWEN-tah'),
        Phrase(english: 'Goodbye', translation: 'Adiós', pronunciation: 'ah-DYOHS'),
      ],
    ),
    PhrasebookLanguage(
      code: 'fr',
      name: 'French',
      flag: '🇫🇷',
      phrases: [
        Phrase(english: 'Hello', translation: 'Bonjour', pronunciation: 'bon-ZHOOR'),
        Phrase(english: 'Thank you', translation: 'Merci', pronunciation: 'mer-SEE'),
        Phrase(english: 'Please', translation: 'S\'il vous plaît', pronunciation: 'seel voo PLAY'),
        Phrase(english: 'Excuse me', translation: 'Excusez-moi', pronunciation: 'ex-kew-zay MWAH'),
        Phrase(english: 'Where is…?', translation: 'Où est…?', pronunciation: 'oo ay'),
        Phrase(english: 'How much?', translation: 'Combien?', pronunciation: 'kom-BYAN'),
        Phrase(english: 'I need help', translation: 'J\'ai besoin d\'aide', pronunciation: 'zhay buh-ZWAN ded'),
        Phrase(english: 'Water', translation: 'Eau', pronunciation: 'oh'),
        Phrase(english: 'The bill, please', translation: 'L\'addition, s\'il vous plaît', pronunciation: 'la-dee-SYON'),
        Phrase(english: 'Goodbye', translation: 'Au revoir', pronunciation: 'oh ruh-VWAR'),
      ],
    ),
    PhrasebookLanguage(
      code: 'ja',
      name: 'Japanese',
      flag: '🇯🇵',
      phrases: [
        Phrase(english: 'Hello', translation: 'こんにちは', pronunciation: 'kon-nee-chee-WAH'),
        Phrase(english: 'Thank you', translation: 'ありがとう', pronunciation: 'ah-ree-GAH-toh'),
        Phrase(english: 'Please', translation: 'お願いします', pronunciation: 'oh-neh-GAI shee-mas'),
        Phrase(english: 'Excuse me', translation: 'すみません', pronunciation: 'soo-mee-mah-SEN'),
        Phrase(english: 'Where is…?', translation: '…はどこですか?', pronunciation: '… wa DOH-ko des-kah'),
        Phrase(english: 'How much?', translation: 'いくらですか?', pronunciation: 'ee-KOO-rah des-kah'),
        Phrase(english: 'I need help', translation: '助けてください', pronunciation: 'ta-soo-KETE koo-dah-sai'),
        Phrase(english: 'Water', translation: '水', pronunciation: 'mee-ZOO'),
        Phrase(english: 'The bill, please', translation: 'お会計お願いします', pronunciation: 'oh-kai-KEH oh-neh-GAI'),
        Phrase(english: 'Goodbye', translation: 'さようなら', pronunciation: 'sah-YOH-nah-rah'),
      ],
    ),
    PhrasebookLanguage(
      code: 'de',
      name: 'German',
      flag: '🇩🇪',
      phrases: [
        Phrase(english: 'Hello', translation: 'Hallo', pronunciation: 'HAH-loh'),
        Phrase(english: 'Thank you', translation: 'Danke', pronunciation: 'DAHN-keh'),
        Phrase(english: 'Please', translation: 'Bitte', pronunciation: 'BIT-teh'),
        Phrase(english: 'Excuse me', translation: 'Entschuldigung', pronunciation: 'ent-SHOOL-dee-goong'),
        Phrase(english: 'Where is…?', translation: 'Wo ist…?', pronunciation: 'voh ist'),
        Phrase(english: 'How much?', translation: 'Wie viel kostet das?', pronunciation: 'vee feel KOS-tet das'),
        Phrase(english: 'I need help', translation: 'Ich brauche Hilfe', pronunciation: 'ikh BROW-kheh HIL-feh'),
        Phrase(english: 'Water', translation: 'Wasser', pronunciation: 'VAH-ser'),
        Phrase(english: 'The bill, please', translation: 'Die Rechnung, bitte', pronunciation: 'dee REKH-noong'),
        Phrase(english: 'Goodbye', translation: 'Auf Wiedersehen', pronunciation: 'owf VEE-der-zayn'),
      ],
    ),
    PhrasebookLanguage(
      code: 'it',
      name: 'Italian',
      flag: '🇮🇹',
      phrases: [
        Phrase(english: 'Hello', translation: 'Ciao', pronunciation: 'CHOW'),
        Phrase(english: 'Thank you', translation: 'Grazie', pronunciation: 'GRAH-tsee-eh'),
        Phrase(english: 'Please', translation: 'Per favore', pronunciation: 'per fah-VOH-reh'),
        Phrase(english: 'Excuse me', translation: 'Mi scusi', pronunciation: 'mee SKOO-zee'),
        Phrase(english: 'Where is…?', translation: 'Dov\'è…?', pronunciation: 'doh-VEH'),
        Phrase(english: 'How much?', translation: 'Quanto costa?', pronunciation: 'KWAN-toh KOS-tah'),
        Phrase(english: 'I need help', translation: 'Ho bisogno di aiuto', pronunciation: 'oh bee-ZOH-nyoh dee ah-YOO-toh'),
        Phrase(english: 'Water', translation: 'Acqua', pronunciation: 'AH-kwah'),
        Phrase(english: 'The bill, please', translation: 'Il conto, per favore', pronunciation: 'eel KON-toh'),
        Phrase(english: 'Goodbye', translation: 'Arrivederci', pronunciation: 'ah-ree-veh-DER-chee'),
      ],
    ),
    PhrasebookLanguage(
      code: 'th',
      name: 'Thai',
      flag: '🇹🇭',
      phrases: [
        Phrase(english: 'Hello', translation: 'สวัสดี', pronunciation: 'sa-WAT-dee'),
        Phrase(english: 'Thank you', translation: 'ขอบคุณ', pronunciation: 'khop KUN'),
        Phrase(english: 'Please', translation: 'โปรด', pronunciation: 'proht'),
        Phrase(english: 'Excuse me', translation: 'ขอโทษ', pronunciation: 'khor TOHT'),
        Phrase(english: 'Where is…?', translation: '…อยู่ที่ไหน?', pronunciation: '… yoo tee nai'),
        Phrase(english: 'How much?', translation: 'เท่าไหร่?', pronunciation: 'tao rai'),
        Phrase(english: 'I need help', translation: 'ช่วยด้วย', pronunciation: 'chuay duay'),
        Phrase(english: 'Water', translation: 'น้ำ', pronunciation: 'nam'),
        Phrase(english: 'The bill, please', translation: 'เช็คบิล', pronunciation: 'check bin'),
        Phrase(english: 'Goodbye', translation: 'ลาก่อน', pronunciation: 'lah gorn'),
      ],
    ),
    PhrasebookLanguage(
      code: 'ar',
      name: 'Arabic',
      flag: '🇦🇪',
      phrases: [
        Phrase(english: 'Hello', translation: 'مرحبا', pronunciation: 'mar-HA-ba'),
        Phrase(english: 'Thank you', translation: 'شكرا', pronunciation: 'SHOO-kran'),
        Phrase(english: 'Please', translation: 'من فضلك', pronunciation: 'min FAD-lak'),
        Phrase(english: 'Excuse me', translation: 'عفوا', pronunciation: 'AF-wan'),
        Phrase(english: 'Where is…?', translation: 'أين…?', pronunciation: 'ayna'),
        Phrase(english: 'How much?', translation: 'بكم؟', pronunciation: 'bi-KAM'),
        Phrase(english: 'I need help', translation: 'أحتاج مساعدة', pronunciation: 'a-H-taj moo-SA-a-dah'),
        Phrase(english: 'Water', translation: 'ماء', pronunciation: 'MA'),
        Phrase(english: 'The bill, please', translation: 'الفاتورة من فضلك', pronunciation: 'al-FA-too-rah'),
        Phrase(english: 'Goodbye', translation: 'مع السلامة', pronunciation: 'ma-a-sal-A-ma'),
      ],
    ),
    PhrasebookLanguage(
      code: 'ko',
      name: 'Korean',
      flag: '🇰🇷',
      phrases: [
        Phrase(english: 'Hello', translation: '안녕하세요', pronunciation: 'an-nyeong-ha-SE-yo'),
        Phrase(english: 'Thank you', translation: '감사합니다', pronunciation: 'gam-sa-HAM-ni-da'),
        Phrase(english: 'Please', translation: '부탁합니다', pronunciation: 'bu-TAK-ham-ni-da'),
        Phrase(english: 'Excuse me', translation: '실례합니다', pronunciation: 'shil-lye-HAM-ni-da'),
        Phrase(english: 'Where is…?', translation: '…어디에 있어요?', pronunciation: '… eo-di-e is-seo-yo'),
        Phrase(english: 'How much?', translation: '얼마예요?', pronunciation: 'eol-ma-ye-yo'),
        Phrase(english: 'I need help', translation: '도와주세요', pronunciation: 'do-wa-ju-se-yo'),
        Phrase(english: 'Water', translation: '물', pronunciation: 'mul'),
        Phrase(english: 'The bill, please', translation: '계산서 주세요', pronunciation: 'gye-san-seo ju-se-yo'),
        Phrase(english: 'Goodbye', translation: '안녕히 가세요', pronunciation: 'an-nyeong-hi ga-se-yo'),
      ],
    ),
  ];
}

class PhrasebookLanguage {
  const PhrasebookLanguage({
    required this.code,
    required this.name,
    required this.flag,
    required this.phrases,
  });

  final String code;
  final String name;
  final String flag;
  final List<Phrase> phrases;
}

class Phrase {
  const Phrase({
    required this.english,
    required this.translation,
    this.pronunciation,
  });

  final String english;
  final String translation;
  final String? pronunciation;
}
