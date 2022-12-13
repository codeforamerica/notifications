# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# announcements = Program.create!(
#   name: "ANNOUNCEMENTS",
#   opt_in_keywords: {en: ["STARTANNOUNCEMENTS"], es: ["STARTANNOUNCEMENTSSPANISH"]},
#   opt_out_keywords: {en: ["STOPANNOUNCEMENTS"], es: ["ALTOANNOUNCEMENTS"]},
#   opt_in_response: "Hello",
#   opt_out_response: "Goodbye"
# )
# Mobility.with_locale(:es) do
#   announcements.opt_in_response = "Hola"
#   announcements.opt_out_response = "Adios"
# end
# announcements.save

snap = Program.new(
  name: "SNAP",
  opt_in_keywords: {
    en: %w(START UNSTOP),
    es: %w(COMENZAR DESATASCAR) },
  opt_out_keywords: {
    en: %w(STOP END CANCEL UNSUBSCRIBE QUIT SNAPSTOP),
    es: %w(DETENER FIN CANCELAR SUSCRIBIRSE DEJAR) },
  help_keywords: {
    en: %w(HELP INFO),
    es: %w(AYUDA) },
)
Mobility.with_locale(:en) do
  snap.opt_in_response = "Thanks for joining DSS reminders! You will receive 5 messages per month. Message/data rates may apply. Reply HELP for help, STOP to cancel."
  snap.opt_out_response = "You have successfully unsubscribed from DSS reminders. You will not receive any more messages from this number. Reply START to resubscribe."
  snap.help_response = "CT DSS messages. Get help by logging into mydss.ct.gov or calling 855-626-6632. Five messages per month. Message/data rates may apply. Reply STOP to cancel."
end
Mobility.with_locale(:es) do
  snap.opt_in_response = "Gracias por inscribirse a recibir los recordatorios de DSS! Tarifas de mensajes y datos pueden aplicar. Responda AYUDA para recibir ayuda, o DETENER para cancelar."
  snap.opt_out_response = "Se ha dado de baja de recibir recordatorios de DSS. No recibirá más mensajes de este número. Responda COMENZAR para reinscribirse."
  snap.help_response = "Mensajes de CT DSS. Para ayuda llamando al 1-855-626-6632. 5 mensajes al mes. Tarifas de mensajes y datos pueden aplicar. Responda ALTO para cancelar."
end
snap.save!