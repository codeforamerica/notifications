# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

snap = Program.new(
  name: "SNAP",
  opt_in_keywords: {
    en: %w(START UNSTOP STARTSNAP),
    es: %w(COMENZAR DESATASCAR) },
  opt_out_keywords: {
    en: %w(STOP END CANCEL UNSUBSCRIBE QUIT OPTOUTSNAP),
    es: %w(DETENER FIN CANCELAR SUSCRIBIRSE DEJAR) },
  help_keywords: {
    en: %w(HELP INFO),
    es: %w(AYUDA) },
)
Mobility.with_locale(:en) do
  snap.opt_in_response = "You subscribed to CT DSS SNAP messages. We'll send you less than 5 texts each month to help you get and keep your SNAP benefits. Message/data rates may apply. Reply HELP for help, OptOutSNAP to cancel."
  snap.opt_out_response = "You have unsubscribed from CT DSS SNAP messages. You will not get any more texts about your SNAP benefits. Reply StartSNAP to resubscribe."
  snap.help_response = "CT DSS messages. Get help by logging into mydss.ct.gov or calling 855-626-6632. Message/data rates may apply. Reply STOP to cancel."
end
Mobility.with_locale(:es) do
  snap.opt_in_response = "Se suscribió a los mensajes de CT DSS SNAP. Le enviaremos menos de 5 mensajes de texto cada mes para ayudarlo a obtener y mantener sus beneficios de SNAP. Se pueden aplicar tarifas de mensajes/datos. Responda HELP para obtener ayuda, OptOutSNAP para cancelar."
  snap.opt_out_response = "Se ha dado de baja de los mensajes de CT DSS SNAP. No recibirá más mensajes de texto sobre sus beneficios de SNAP. Responda StartSNAP para volver a suscribirse."
  snap.help_response = "Mensajes de CT DSS. Obtenga ayuda iniciando sesión en mydss.ct.gov o llamando 855-626-6632. Se pueden aplicar tarifas de mensajes/datos. Responda STOP para cancelar."
end
snap.save!