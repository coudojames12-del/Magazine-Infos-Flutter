import 'package:flutter/material.dart';

void main() {
  // On ne peut pas mettre const ici si on met const à la ligne 17
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    // CORRECTION MAJEURE : Retrait de 'const' devant MaterialApp car ThemeData n'est pas const.
    return MaterialApp(
      title: 'Magazine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      // Il faut mettre const PageAccueil() si on veut que MonAppli soit const
      home: const PageAccueil(),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Magazine Infos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade700,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            debugPrint('Menu cliqué');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              debugPrint('Recherche cliquée');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/images.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const PartieTitre(),
            const PartieTexte(),
            const Partielcone(),
            const PartieRubrique(),
          ],
        ),
      ),
    );
  }
}

// --- CLASSE PartieTitre ---
class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Votre magazine numérique, votre source d\'inspiration',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: const Text(
        'Magazine Infos est bien plus qu\'un simple magazine d\'informations. C\'est votre passerelle vers le monde, une source inestimable de connaissances et d\'actualités soigneusement sélectionnées pour vous éclairer sur les enjeux mondiaux, la culture, la science, et voir même le divertissement (le jeux).',
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black54),
      ),
    );
  }
}

class Partielcone extends StatelessWidget {
  const Partielcone({super.key});

  Widget _buildIconAction(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: Colors.pink, size: 30),
        const SizedBox(height: 5),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildIconAction(Icons.phone, 'TEL'),
          _buildIconAction(Icons.mail, 'MAIL'),
          _buildIconAction(Icons.share, 'PARTAGE'),
        ],
      ),
    );
  }
}

// --- CLASSE PartieRubrique ---
class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  Widget _buildRubriqueImage(String text, String imageUrl) {
    return Column(
      children: [
        ClipRRect(
          // La documentation demandait un rayon de 10.0
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            imageUrl,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        // Ajout du texte sous l'image pour identifier la rubrique
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // CORRECTION 2 : Utilisation d'une URL de placeholder valide pour "Presse"
          _buildRubriqueImage('Presse', 'assets/images/images_Rubrique.png'),
          // CORRECTION 3 : Utilisation d'une URL de placeholder valide pour "Mode"
          _buildRubriqueImage('Mode', 'assets/images/images_presse.png'),
        ],
      ),
    );
  }
}
