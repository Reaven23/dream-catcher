module ApplicationHelper
  # Extrait un aperçu propre d'une analyse (sans les en-têtes Markdown)
  def clean_analysis_preview(text, length: 200)
    return "" if text.blank?

    # Supprime les en-têtes Markdown (## 🌙 Vue d'ensemble, etc.)
    cleaned = text.gsub(/^##\s*[^\n]+\n?/, '')
    # Supprime les emojis isolés au début
    cleaned = cleaned.gsub(/^[🌙🔮🎭🧠✨💡🌱📈🔄]+\s*/, '')
    # Supprime les lignes vides multiples
    cleaned = cleaned.gsub(/\n{2,}/, ' ')
    # Supprime le formatage Markdown (**, *, -)
    cleaned = cleaned.gsub(/\*\*([^*]+)\*\*/, '\1')
    cleaned = cleaned.gsub(/\*([^*]+)\*/, '\1')
    cleaned = cleaned.gsub(/^-\s+/, '')
    # Nettoie les espaces
    cleaned = cleaned.strip.gsub(/\s+/, ' ')

    truncate(cleaned, length: length)
  end
end
