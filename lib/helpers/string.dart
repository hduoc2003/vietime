int countMatchWords(String s, List<String> words) {
  int count = 0;
  for (String word in words) {
    if (s.contains(word)) {
      count++;
    }
  }
  return count;
}

String removePunctuation(String text) {
  return text.replaceAll(RegExp(r'[^\w\s]'), '');
}