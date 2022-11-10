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

snap = Program.create!(
  name: "SNAP",
  opt_in_keywords: {
    en: %w(START UNSTOP STARTSNAP),
    es: %w(COMENZAR COMENZARSNAP)},
  opt_out_keywords: {
    en: %w(STOP END CANCEL UNSUBSCRIBE QUIT STOPSNAP),
    es: %w(DETENER FIN CANCELAR SUSCRIBIRSE DEJAR ALTOSNAP)},
  opt_in_response: "Hello",
  opt_out_response: "You have successfully unsubscribed from DSS reminders. You will not receive any more messages from this number. Reply START to resubscribe."
)
Mobility.with_locale(:es) do
  snap.opt_in_response = "Hola"
  snap.opt_out_response = "Se ha dado de baja de recibir recordatorios de DSS. No recibirá más mensajes de este número. Responda COMENZAR para reinscribirse."
end
snap.save