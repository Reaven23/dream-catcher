class TranscriptionsController < ApplicationController
  def create
    audio = params[:audio]

    unless audio.present?
      return render json: { error: "No audio file provided" }, status: :unprocessable_entity
    end

    unless helpers.special_user?
      return render json: {text: "L'utilisation du speech to text est réservé aux utilisateurs spéciaux, vous pouvez cependant écrire votre rêve à la main." }
    end

    extension = File.extname(audio.original_filename).presence || '.webm'

    temp_file = Tempfile.new(['audio', extension])
    begin
      temp_file.binmode
      temp_file.write(audio.read)
      temp_file.close

      client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

      response = client.audio.transcribe(
        parameters: {
          model: "whisper-1",
          file: File.open(temp_file.path, "rb"),
          language: "fr"
        }
      )

      render json: { text: response["text"] }
    rescue StandardError => e
      Rails.logger.error("Transcription error: #{e.message}")
      Rails.logger.error(e.backtrace.first(5).join("\n"))
      render json: { error: "Transcription failed: #{e.message}" }, status: :internal_server_error
    ensure
      temp_file.unlink
    end
  end
end
