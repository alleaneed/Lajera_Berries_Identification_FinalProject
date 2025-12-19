class BerrySample {
  final String name;
  final String scientificName;
  final String description;
  final String imagePath;

  const BerrySample({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.imagePath,
  });
}

class BerrySamplesData {
  static const List<BerrySample> samples = [
    BerrySample(
      name: 'Cranberry',
      scientificName: 'Vaccinium macrocarpon',
      description: 'Small, red, tart berries that grow on low-lying vines in bogs. Rich in antioxidants and Vitamin C, commonly used in juices and sauces.',
      imagePath: 'assets/examples/1.jpg',
    ),
    BerrySample(
      name: 'Golden Berry',
      scientificName: 'Physalis peruviana',
      description: 'Small, yellow-orange berries wrapped in a papery husk. Sweet and tangy flavor, high in Vitamin A and C, also known as Cape gooseberry.',
      imagePath: 'assets/examples/2.jpg',
    ),
    BerrySample(
      name: 'Raspberry',
      scientificName: 'Rubus idaeus',
      description: 'Delicate red berries composed of small drupelets. Sweet-tart flavor, excellent source of fiber, Vitamin C, and antioxidants.',
      imagePath: 'assets/examples/3.jpg',
    ),
    BerrySample(
      name: 'Blackberry',
      scientificName: 'Rubus fruticosus',
      description: 'Large, dark purple to black aggregate berries. Sweet and juicy, packed with vitamins C and K, plus high fiber content.',
      imagePath: 'assets/examples/4.jpg',
    ),
    BerrySample(
      name: 'Blueberry',
      scientificName: 'Vaccinium corymbosum',
      description: 'Small, round blue berries with a waxy coating. Sweet flavor, famous for high antioxidant content and brain health benefits.',
      imagePath: 'assets/examples/5.jpg',
    ),
    BerrySample(
      name: 'Strawberry',
      scientificName: 'Fragaria x ananassa',
      description: 'Bright red, cone-shaped fruit with seeds on the outside. Sweet, aromatic, and extremely high in Vitamin C and manganese.',
      imagePath: 'assets/examples/6.jpg',
    ),
    BerrySample(
      name: 'Pineberry',
      scientificName: 'Fragaria x ananassa "Pineberry"',
      description: 'White strawberries with red seeds. Unique pineapple-like flavor, lower acidity than red strawberries, rare and gourmet variety.',
      imagePath: 'assets/examples/7.jpg',
    ),
    BerrySample(
      name: 'Cloudberry',
      scientificName: 'Rubus chamaemorus',
      description: 'Golden-yellow, soft berries from Arctic regions. Tart flavor when raw, sweet when ripe, extremely high in Vitamin C.',
      imagePath: 'assets/examples/8.jpg',
    ),
    BerrySample(
      name: 'Huckleberry',
      scientificName: 'Vaccinium parvifolium',
      description: 'Small, dark blue to black berries. Similar to blueberries but more intense flavor, grows wild in mountain forests.',
      imagePath: 'assets/examples/9.jpg',
    ),
    BerrySample(
      name: 'Gooseberry',
      scientificName: 'Ribes uva-crispa',
      description: 'Small, translucent green to reddish berries. Tart when raw, sweet when ripe, excellent for jams, pies, and preserves.',
      imagePath: 'assets/examples/10.jpg',
    ),
  ];
}
