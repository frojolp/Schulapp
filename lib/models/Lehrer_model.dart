class Lehrer {
  final String name;
  final String email;
  final String sonstiges;

  Lehrer({this.name, this.email, this.sonstiges});
}

final List<Lehrer> Lehrkraefte = [
  Lehrer(
      name: 'Herr Baumgärtel', email: 'baumgaertel@esss.de', sonstiges: '123'),
  Lehrer(name: 'Herr Trautmann', email: 'Trautmann@esss.de', sonstiges: '456'),
  Lehrer(name: 'Herr Beier', email: 'Beier@esss.de', sonstiges: '789'),
  Lehrer(name: 'Frau Dr. Tröster', email: 'troester@esss.de', sonstiges: '111')
];
