extension StringExtension on String {
  String capitalizeEveryFirstLetter() {
    return toLowerCase().split(' ').map((word) {
      if (word.length <= 2) {
        return word;
      } else {
        String leftText =
            (word.length > 1) ? word.substring(1, word.length) : '';
        return word[0].toUpperCase() + leftText;
      }
    }).join(' ');
  }
}
