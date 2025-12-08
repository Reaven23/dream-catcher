#!/bin/bash

# Script pour supprimer config/master.key de l'historique Git

echo "⚠️  ATTENTION : Ce script va réécrire l'historique Git"
echo "Tous les collaborateurs devront re-cloner le dépôt après cette opération"
echo ""
read -p "Voulez-vous continuer ? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Opération annulée"
    exit 1
fi

echo ""
echo "📝 Étape 1 : Suppression de config/master.key de l'historique..."

# Méthode avec git filter-branch (fonctionne sans installation supplémentaire)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch config/master.key" \
  --prune-empty --tag-name-filter cat -- --all

echo ""
echo "🧹 Étape 2 : Nettoyage des références..."
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo ""
echo "✅ Étape 3 : Vérification..."
if git log --all --full-history -- config/master.key | grep -q .; then
    echo "❌ ERREUR : Le fichier est toujours dans l'historique !"
    exit 1
else
    echo "✅ Le fichier a été supprimé de l'historique local"
fi

echo ""
echo "📤 Étape 4 : Push forcé sur GitHub..."
echo "⚠️  Vous allez devoir forcer le push avec :"
echo ""
echo "   git push origin --force --all"
echo "   git push origin --force --tags"
echo ""
read -p "Voulez-vous exécuter le push maintenant ? (yes/no): " push_confirm

if [ "$push_confirm" == "yes" ]; then
    git push origin --force --all
    git push origin --force --tags
    echo "✅ Push effectué"
else
    echo "⚠️  N'oubliez pas d'exécuter les commandes de push plus tard !"
fi

echo ""
echo "🔐 Étape 5 : Régénération de la master key..."
echo "⚠️  IMPORTANT : Régénérez votre master key car elle a été exposée"
echo ""
echo "   rm config/master.key"
echo "   EDITOR='code --wait' rails credentials:edit"
echo ""
echo "✅ Script terminé !"
echo ""
echo "📋 Actions à faire ensuite :"
echo "   1. Régénérez la master key (commandes ci-dessus)"
echo "   2. Changez toutes les clés API/mots de passe dans credentials"
echo "   3. Informez vos collaborateurs de re-cloner le dépôt"
