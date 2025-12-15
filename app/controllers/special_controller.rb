class SpecialController < ApplicationController
  skip_before_action :check_quiz_completion
  before_action :check_special_user

  def show
    @alarm_sounds = [
      { name: "Son par défaut", path: nil },
      { name: "🏳️‍🌈 T'es gay toi", path: "/sounds/gaydar.mp3" },
      { name: "🧠 Il faut sacher", path: "/sounds/amelie.mp3" },
      { name: "🙅‍♂️ Rien à voir", path: "/sounds/bigflo.mp3" },
      { name: "🍆 T'es malade Bernard", path: "/sounds/bernard.mp3" }
    ]

    @citations = [
      "Les rêves sont les étoiles qui guident notre âme dans la nuit. ✨",
      "Dans chaque rêve se cache un message de ton subconscient. 🌙",
      "Tes rêves sont le reflet de tes désirs les plus profonds. 💫",
      "La nuit révèle ce que le jour cache. 🌌",
      "Chaque rêve est une porte vers ton monde intérieur. 🚪",
      "Les rêves sont les contes que notre âme se raconte. 📖",
      "Dans l'obscurité, la lumière de tes rêves brille le plus fort. 🌟",
      "Tes rêves sont des cartes du trésor de ton âme. 🗺️",
      "Chaque nuit, ton subconscient t'offre un cadeau. 🎁",
      "Les rêves sont les messagers silencieux de ton cœur. 💌",
      "Dans tes rêves, tu es libre d'être qui tu veux être. 🦋",
      "Tes rêves sont les couleurs de ton âme peintes sur le ciel de la nuit. 🎨",
      "Chaque rêve est une étoile filante dans le ciel de ta conscience. ☄️",
      "Les rêves sont les murmures de ton âme qui cherche à être entendus. 🗣️",
      "Dans le royaume des rêves, tout est possible. 👑"
    ]
    @citation_aleatoire = @citations.sample

    @plant = Plant.new
    @plants = current_user.plants.order(created_at: :desc)
  end

  private

  def check_special_user
    unless helpers.special_user?
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
end
