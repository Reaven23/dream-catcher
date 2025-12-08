# Instructions pour supprimer config/master.key de l'historique Git

## Option 1 : Utiliser git filter-repo (Recommandé)

### Installation de git-filter-repo
```bash
# macOS
brew install git-filter-repo

# Ou avec pip
pip install git-filter-repo
```

### Supprimer le fichier de l'historique
```bash
git filter-repo --path config/master.key --invert-paths
```

### Forcer le push sur GitHub
```bash
git push origin --force --all
git push origin --force --tags
```

⚠️ **ATTENTION** : Cette commande réécrit tout l'historique Git. Tous les collaborateurs devront re-cloner le dépôt.

---

## Option 2 : Utiliser git filter-branch (Ancienne méthode)

```bash
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch config/master.key" \
  --prune-empty --tag-name-filter cat -- --all

git push origin --force --all
git push origin --force --tags
```

---

## Option 3 : Supprimer et recréer le dépôt (Si très peu de commits)

### Sur GitHub :
1. Allez sur https://github.com/Reaven23/dream-catcher/settings
2. Scroll jusqu'en bas → "Delete this repository"
3. Recréez le dépôt

### En local :
```bash
# Supprimer la remote
git remote remove origin

# Recréer le dépôt sur GitHub, puis :
git remote add origin git@github.com:Reaven23/dream-catcher.git
git push -u origin master
```

---

## Option 4 : Utiliser BFG Repo-Cleaner (Plus simple)

### Installation
```bash
brew install bfg
# Ou télécharger depuis https://rtyley.github.io/bfg-repo-cleaner/
```

### Utilisation
```bash
# Créer une copie du dépôt
cd ..
git clone --mirror git@github.com:Reaven23/dream-catcher.git dream-catcher-backup.git

# Supprimer le fichier
bfg --delete-files config/master.key dream-catcher-backup.git

# Nettoyer
cd dream-catcher-backup.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Forcer le push
git push --force
```

---

## ⚠️ IMPORTANT : Après avoir supprimé l'historique

1. **Régénérez la master key** (elle a été exposée) :
```bash
rm config/master.key
EDITOR="code --wait" rails credentials:edit
```

2. **Changez toutes les clés API/mots de passe** qui étaient dans `config/credentials.yml.enc`

3. **Informez tous les collaborateurs** qu'ils doivent re-cloner le dépôt

4. **Vérifiez que le fichier est bien supprimé** :
```bash
git log --all --full-history -- config/master.key
# Ne doit rien retourner
```
