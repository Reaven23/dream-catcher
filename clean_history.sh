#!/bin/bash
echo "🧹 Nettoyage de l'historique Git pour supprimer config/master.key..."
echo ""

# Supprimer le fichier de l'historique
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch config/master.key" \
  --prune-empty --tag-name-filter cat -- --all

# Nettoyer les références
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Vérifier
echo ""
echo "✅ Vérification..."
if git log --all --full-history -- config/master.key | grep -q .; then
    echo "❌ ERREUR : Le fichier est toujours dans l'historique !"
    exit 1
else
    echo "✅ Le fichier a été supprimé de l'historique !"
    echo ""
    echo "📤 Vous pouvez maintenant pousser sur GitHub :"
    echo "   git push origin --force --all"
fi
