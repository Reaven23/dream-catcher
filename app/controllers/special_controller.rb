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
      "La vie c'est pas un parapluie, quand elle te tombe sur la gueule, elle te tombe sur la gueule ! ☔️",
      "'When a person is lucky enough to live inside a story, to live inside an imaginary world, the pains of this world disappear. For as long as the story goes on, reality no longer exists.' - Paul Auster, The Brooklyn Follies 📚",
      "'Escaping into a film is not like escaping into a book. Books force you to give something back to them, to exercise your intelligence and imagination, where as you can watch a film-and even enjoy it-in a state of mindless passivity.' - Paul Auster, Man in the Dark 📚",
      "'The pictures do not lie, but neither do they tell the whole story. They are merely a record of time passing, the outward evidence.' - Paul Auster, Travels in the Scriptorium 📚",
      "'Memories, even your most precious ones, fade surprisingly quickly. But I don’t go along with that. The memories I value most, I don’t ever see them fading.' - Kazuo Ishiguro, Never Let Me Go 📚",
      "'As a writer, I'm more interested in what people tell themselves happened rather than what actually happened' - Kazuo Ishiguro 📚",
      "'I like it when somebody gets excited about something. It's nice.' JD Salinger, The Catcher in the Rye 📚",
      "'I'm quite illiterate, but I read a lot.' - JD Salinger, The Catcher in the Rye 📚",
      "'Mothers are all slightly insane' - JD Salinger, The Catcher in the Rye 📚",
      "'If a girl looks swell when she meets you, who gives a damn if she's late?' - JD Salinger, The Catcher in the Rye 📚",
      "La vie c’est pas un kiwi, tu peux pas juste la couper en deux et choisir la meilleure partie. 🥝",
      "La vie c’est pas un biscuit, y a des jours sans croustillant. 🍪",
      "La vie c’est pas un raccourci, des fois il faut savoir prendre le temps. 🛣️",
      "Je te jure que tu manges un piment si la dernière fois que tu t'es vue dans un miroir tu as dit que tu avais une coupe de folle ! 🌶️" ,
      "Dis encore une seule fois que tu cours lentement et tu me fais un massage tous les soirs pendant un mois ! (Ouai j'avoue il faut se faire plaiz des fois) 💆‍♂️",
      "Je te jure que tu n'as pas une coupe de folle, wallah, non vraiment, vraiment, magnifique la coupe 👩‍🦱",
      "Ton pétard n'a d'égal que ta beauté ma bewlle, il faut que tu le sacher! 🍑",
      "Tu ne serais pas une sortie de sec*urs ? Parce que tu m’exit. 💾",
      "Si tu étais un sandwich à McDo, tu serais le Mc-nifique. 💾",
      "Tu ne ferais pas de la boxe ? Parce que tu es hyper cute. 💾",
      "On a pas encore fait notre bowling au moment où j'écris ça, mais je te jure si je perds c'est magic mike direeect 🕺",
      "Non Johnny, sa tête n'est pas un oreiller, mais bon je comprends, j'avoue elle a l'air confortable ... 🐈",
      "Ton père travaille chez Nintendo si j’en crois ton corps de DS 💾",
      "Ça se voit t'a mangé des graines aujourd'hui, voilà c'est tout 🌱",
      "Allez, si tu tombes sur ce message, tu te prends un petit carré de chocolat, je te jure ça fait du bien 🍫",
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
