extension SentenceCase on String {
  String toSentenceCase() {
    if (isEmpty) {
      return this;
    }
    // Capitalize the first letter and make the rest lowercase
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
