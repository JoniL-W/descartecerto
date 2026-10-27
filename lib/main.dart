import 'package:flutter/material.dart';

void main() => runApp(const DescarteCertoApp());

const green = Color(0xFF16834A);
const pale = Color(0xFFEAF6EE);

class DescarteCertoApp extends StatelessWidget {
  const DescarteCertoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DescarteCerto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF7F9F7),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF7F9F7)),
      ),
      home: const HomePage(),
    );
  }
}

class ResidueCategory {
  const ResidueCategory(this.name, this.icon, this.description);
  final String name;
  final IconData icon;
  final String description;
}

const categories = [
  ResidueCategory('Eletrônicos', Icons.devices_other, 'Celulares, computadores e acessórios'),
  ResidueCategory('Pilhas', Icons.battery_charging_full, 'Pilhas e baterias usadas'),
  ResidueCategory('Óleo', Icons.water_drop_outlined, 'Óleo de cozinha usado'),
  ResidueCategory('Móveis', Icons.chair_outlined, 'Móveis e objetos volumosos'),
];

class CollectionPoint {
  const CollectionPoint(this.name, this.category, this.address, this.description);
  final String name;
  final String category;
  final String address;
  final String description;
}

// Dados fictícios criados apenas para demonstrar a navegação na Etapa 1.
// Substituir por pontos verificados durante a pesquisa e validação local.
const samplePoints = [
  CollectionPoint('Ponto demonstrativo A', 'Eletrônicos', 'Endereço a confirmar', 'Recebimento de eletrônicos: informação ainda não verificada.'),
  CollectionPoint('Ponto demonstrativo B', 'Pilhas', 'Endereço a confirmar', 'Recebimento de pilhas: informação ainda não verificada.'),
  CollectionPoint('Ponto demonstrativo C', 'Óleo', 'Endereço a confirmar', 'Recebimento de óleo: informação ainda não verificada.'),
  CollectionPoint('Ponto demonstrativo D', 'Móveis', 'Endereço a confirmar', 'Recebimento de móveis: informação ainda não verificada.'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selected = 'Todos';
  String query = '';
  int page = 0;

  List<CollectionPoint> get filtered => samplePoints.where((p) {
    final matchesCategory = selected == 'Todos' || p.category == selected;
    final search = query.toLowerCase().trim();
    final matchesQuery = search.isEmpty ||
        p.name.toLowerCase().contains(search) ||
        p.category.toLowerCase().contains(search);
    return matchesCategory && matchesQuery;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Icon(Icons.recycling, color: green, size: 29),
          SizedBox(width: 9),
          Text('DescarteCerto', style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
      body: SafeArea(
        child: page == 0 ? _home() : page == 1 ? _allPoints() : _about(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (value) => setState(() => page = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.place_outlined), selectedIcon: Icon(Icons.place), label: 'Pontos'),
          NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: 'Sobre'),
        ],
      ),
    );
  }

  Widget _home() => ListView(padding: const EdgeInsets.all(18), children: [
    Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(22)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.eco_outlined, color: Colors.white, size: 38),
        SizedBox(height: 12),
        Text('Descarte corretamente.\nCuide do futuro.', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Encontre orientações e pontos de coleta para cada tipo de resíduo.', style: TextStyle(color: Colors.white)),
      ]),
    ),
    const SizedBox(height: 24),
    const Text('O que você deseja descartar?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.65),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final item = categories[index];
        return InkWell(
          onTap: () => setState(() { selected = item.name; page = 1; }),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(16)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(item.icon, color: green, size: 31),
              const SizedBox(height: 8),
              Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
          ),
        );
      },
    ),
    const SizedBox(height: 22),
    OutlinedButton.icon(
      onPressed: () => setState(() { selected = 'Todos'; page = 1; }),
      icon: const Icon(Icons.location_on_outlined),
      label: const Text('Ver pontos de coleta'),
    ),
    const SizedBox(height: 12),
    const Text('Protótipo acadêmico: os locais exibidos são fictícios.', style: TextStyle(color: Colors.black54, fontSize: 12)),
  ]);

  Widget _allPoints() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Pontos de coleta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    const SizedBox(height: 6),
    const Text('Dados demonstrativos. Nenhum endereço foi validado.', style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 16),
    TextField(
      decoration: InputDecoration(
        hintText: 'Pesquisar por resíduo ou ponto',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onChanged: (value) => setState(() => query = value),
    ),
    const SizedBox(height: 12),
    SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
      for (final value in ['Todos', ...categories.map((e) => e.name)])
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(label: Text(value), selected: selected == value, onSelected: (_) => setState(() => selected = value)),
        ),
    ])),
    const SizedBox(height: 14),
    if (filtered.isEmpty) const Padding(padding: EdgeInsets.all(25), child: Text('Nenhum ponto encontrado.')),
    for (final point in filtered)
      Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(13),
          leading: const CircleAvatar(backgroundColor: pale, child: Icon(Icons.recycling, color: green)),
          title: Text(point.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${point.category}\n${point.address}'),
          isThreeLine: true,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointDetails(point: point))),
        ),
      ),
  ]);

  Widget _about() => ListView(padding: const EdgeInsets.all(20), children: [
    const Icon(Icons.eco, color: green, size: 64),
    const SizedBox(height: 16),
    const Text('Sobre o DescarteCerto', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    const SizedBox(height: 14),
    const Text('O DescarteCerto é um projeto acadêmico de extensão voltado à sustentabilidade. Seu objetivo é facilitar a identificação de locais adequados para o descarte de resíduos específicos.'),
    const SizedBox(height: 18),
    const Text('Versão 0.1 • Etapa 1', style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 12),
    const Text('As informações atuais são exemplos para testes de interface, não locais reais de coleta.'),
  ]);
}

class PointDetails extends StatelessWidget {
  const PointDetails({required this.point, super.key});
  final CollectionPoint point;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalhes do ponto')),
    body: ListView(padding: const EdgeInsets.all(22), children: [
      const Icon(Icons.location_on_outlined, size: 75, color: green),
      const SizedBox(height: 18),
      Text(point.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      Text('Resíduo: ${point.category}'),
      const SizedBox(height: 10),
      Text('Endereço: ${point.address}'),
      const SizedBox(height: 16),
      Text(point.description),
      const SizedBox(height: 22),
      const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('ATENÇÃO: ponto fictício usado apenas no protótipo. Não se dirija a este local.'))),
    ]),
  );
}
