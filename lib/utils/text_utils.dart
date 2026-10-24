/// Replaces French accented letters with their plain version ("é" -> "e").
String removeDiacritics(String value) {
  return value.split('').map((char) => _replacements[char] ?? char).join();
}

/// Formats a date as dd/MM/yyyy.
String formatShortDate(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}';
}

const _replacements = {
  'à': 'a',
  'â': 'a',
  'ä': 'a',
  'ç': 'c',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'î': 'i',
  'ï': 'i',
  'ô': 'o',
  'ö': 'o',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'À': 'A',
  'Â': 'A',
  'Ä': 'A',
  'Ç': 'C',
  'É': 'E',
  'È': 'E',
  'Ê': 'E',
  'Ë': 'E',
  'Î': 'I',
  'Ï': 'I',
  'Ô': 'O',
  'Ö': 'O',
  'Ù': 'U',
  'Û': 'U',
  'Ü': 'U',
};
