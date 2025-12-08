# Instructions pour créer le dépôt GitHub et supprimer l'historique

## Étape 1 : Créer le dépôt sur GitHub

1. Allez sur https://github.com/new
2. **Repository name** : `dream-catcher`
3. **Description** : (optionnel) "Application d'interprétation des rêves avec IA"
4. **Visibilité** : Public ou Private (selon votre choix)
5. **NE COCHEZ PAS** "Add a README file", "Add .gitignore", ou "Choose a license"
6. Cliquez sur **"Create repository"**

## Étape 2 : Nettoyer l'historique Git (supprimer master.key)

Une fois le dépôt créé, exécutez ces commandes pour supprimer `config/master.key` de tout l'historique :

```bash
# Supprimer le fichier de l'historique
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch config/master.key" \
  --prune-empty --tag-name-filter cat -- --all

# Nettoyer les références
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Vérifier que c'est supprimé (ne doit rien retourner)
git log --all --full-history -- config/master.key
```

## Étape 3 : Pousser sur GitHub

```bash
# Forcer le push (nécessaire car l'historique a été réécrit)
git push origin --force --all
git push origin --force --tags
```

## Étape 4 : Régénérer la master key

⚠️ **IMPORTANT** : La master key a été exposée, vous devez la régénérer :

```bash
rm config/master.key
EDITOR="code --wait" rails credentials:edit
```

Puis changez toutes les clés API/mots de passe qui étaient dans les credentials.

## Alternative : Si vous préférez un historique propre dès le début

Si vous voulez repartir de zéro avec un historique propre :

```bash
# Supprimer l'historique Git local
rm -rf .git

# Réinitialiser Git
git init
git add .
git commit -m "Initial commit - DreamWeaver app"

# Créer le dépôt sur GitHub (via l'interface web), puis :
git remote add origin git@github.com:Reaven23/dream-catcher.git
git push -u origin master
```

Cette méthode est plus simple mais vous perdez l'historique des commits précédents.
