class Country {
  final String name;

  Country(this.name);

  static List<Country> getCountries() =>
      [Country("Kenya"), Country("Ethiopia")];
}
