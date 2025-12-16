puts "Seeding plants for special user..."

special_email = ENV["SPECIAL_USER_EMAIL"]

if special_email.blank?
  puts "⚠️  ENV['SPECIAL_USER_EMAIL'] n'est pas défini, aucune plante créée."
else
  user = User.find_by(email: special_email)

  if user.nil?
    puts "⚠️  Aucun user trouvé avec l'email #{special_email}, aucune plante créée."
  else
    plants_data = [
      {
        name: "Monstera deliciosa",
        description: "Plante tropicale d'intérieur avec de grandes feuilles découpées, très décorative.",
        sun_need: "Lumière indirecte lumineuse, éviter le soleil direct brûlant.",
        water_need: "Arrosage modéré, laisser sécher légèrement le dessus du terreau entre deux arrosages.",
        soil_need: "Terreau bien drainé, riche en matière organique.",
        wind_need: "Éviter les courants d'air froid.",
        other_needs: "Apprécie une bonne humidité ambiante, vaporiser les feuilles régulièrement."
      },
      {
        name: "Ficus lyrata",
        description: "Grand ficus aux grandes feuilles en forme de violon, très prisé en décoration d'intérieur.",
        sun_need: "Lumière vive sans soleil direct prolongé.",
        water_need: "Arrosage régulier mais modéré, ne pas laisser d'eau stagner dans la soucoupe.",
        soil_need: "Sol bien drainé, mélange de terreau et de perlite.",
        wind_need: "Déteste les changements brusques de température et les courants d'air.",
        other_needs: "Tourner le pot régulièrement pour une croissance homogène."
      },
      {
        name: "Pilea peperomioides",
        description: "Petite plante d'intérieur aux feuilles rondes, aussi appelée plante à monnaie chinoise.",
        sun_need: "Lumière indirecte, tolère une lumière moyenne.",
        water_need: "Arrosage modéré, laisser sécher le terreau en surface.",
        soil_need: "Substrat léger et bien drainé.",
        wind_need: "Éviter les courants d'air froid.",
        other_needs: "Produit facilement des rejets, peut être multipliée aisément."
      }
    ]

    plants_data.each do |attrs|
      plant = user.plants.find_or_create_by!(name: attrs[:name]) do |p|
        p.description = attrs[:description]
        p.sun_need = attrs[:sun_need]
        p.water_need = attrs[:water_need]
        p.soil_need = attrs[:soil_need]
        p.wind_need = attrs[:wind_need]
        p.other_needs = attrs[:other_needs]
      end

      puts "✅ Plante seedée pour #{user.email}: #{plant.name}"
    end
  end
end

puts "Seeding terminé."
