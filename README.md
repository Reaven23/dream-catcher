# DreamCatcher - Interprétation Mystique des Rêves

Une application Rails moderne pour l'interprétation des rêves avec intelligence artificielle.

## 🌐 Accès et fonctionnalités IA

Dream Catcher a été conçue principalement pour un usage personnel. L'application propose des **fonctionnalités d'interprétation des rêves par IA** (analyse de rêves, analyse globale) ; pour les utiliser en conditions réelles, il faut disposer du statut **special user**.

**Vous souhaitez tester l'app et les features IA ?** N'hésitez pas à me contacter pour demander un accès special user — je serai ravi de vous le proposer pour que vous puissiez essayer.

## 🎯 Fonctionnalités

- **Authentification** : Système d'authentification complet avec Devise
- **Quiz initial** : Collecte d'informations personnelles pour personnaliser les analyses (signe astrologique, âge, situation amoureuse, etc.)
- **Enregistrement de rêves** : Interface intuitive pour décrire vos rêves en détail
- **Analyse IA** : Interprétation automatique de vos rêves par intelligence artificielle
- **Analyse globale** : Synthèse de tous vos rêves pour identifier les patterns récurrents
- **Historique** : Journal personnel de tous vos rêves et leurs analyses
- **Design mystique** : Interface dark avec une ambiance mystique et onirique

## 🚀 Installation

### Prérequis

- Ruby 3.1.2
- PostgreSQL
- Node.js et Yarn
- Clé API OpenAI (optionnelle, pour les analyses IA réelles)

### Étapes

1. Clonez le repository
```bash
git clone <repository-url>
cd dream-weaver
```

2. Installez les dépendances
```bash
bundle install
yarn install
```

3. Configurez la base de données
```bash
rails db:create
rails db:migrate
```

4. (Optionnel) Configurez votre clé API OpenAI
Créez un fichier `.env` à la racine du projet :
```
OPENAI_API_KEY=votre_cle_api_ici
```

5. Lancez l'application
```bash
bin/dev
```

L'application sera accessible sur `http://localhost:3000`

## 📝 Utilisation

1. **Inscription/Connexion** : Créez un compte ou connectez-vous
2. **Quiz initial** : Complétez le quiz avec vos informations personnelles
3. **Enregistrer un rêve** : Utilisez le formulaire sur la page d'accueil pour décrire votre rêve
4. **Consulter les analyses** : Accédez à vos rêves depuis le menu "Mes Rêves"
5. **Analyse globale** : Consultez une synthèse de tous vos rêves depuis "Analyse Globale"

## 🛠 Technologies

- **Rails 7.1** : Framework web Ruby
- **PostgreSQL** : Base de données
- **Devise** : Authentification
- **Stimulus** : Framework JavaScript léger
- **Turbo** : Accélération des pages
- **Bootstrap 5** : Framework CSS
- **HTTParty** : Client HTTP pour les appels API
- **OpenAI API** : Intelligence artificielle (optionnel)

## 🎨 Design

L'interface utilise un thème dark mystique avec :
- Dégradés sombres (noir, bleu foncé, violet)
- Accents dorés et violets
- Effets de lumière et d'ombre
- Typographie élégante
- Animations subtiles

## 📦 Structure

```
app/
  ├── controllers/     # Contrôleurs Rails
  ├── models/         # Modèles ActiveRecord
  ├── views/          # Vues ERB
  ├── services/       # Services (interprétation IA)
  └── assets/         # CSS et JavaScript

db/
  └── migrate/        # Migrations de base de données
```

## 🔧 Configuration

### Variables d'environnement

- `OPENAI_API_KEY` : Clé API OpenAI pour les analyses IA (optionnel)

Sans cette clé, l'application utilisera des analyses de démonstration.

## 📄 Licence

Ce projet est sous licence MIT.

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou une pull request.
