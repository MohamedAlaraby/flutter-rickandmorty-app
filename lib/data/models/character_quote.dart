class Quote {
  late String quote;
  Quote.fromJson(Map<String, dynamic> quote) {
    this.quote = quote["quote"];
  }
}
