// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'DēGlitch';

  @override
  String get home => 'Inicio';

  @override
  String get servers => 'Servidores';

  @override
  String get diagnostics => 'Diagnóstico';

  @override
  String get profile => 'Perfil';

  @override
  String get more => 'Más';

  @override
  String get connected => 'Conectado';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get connecting => 'Conectando';

  @override
  String get connectionError => 'Error de conexión';

  @override
  String get received => 'Recibido';

  @override
  String get sent => 'Enviado';

  @override
  String get lastHandshake => 'Último intercambio';

  @override
  String get quickAccess => 'Acceso rápido';

  @override
  String get serverRecommendation => 'Recomendación de servidor';

  @override
  String get serverRecommendationDescription =>
      'Sugerencias de servidores asistidas por IA según tu conexión';

  @override
  String get runDiagnostics => 'Ejecutar diagnóstico';

  @override
  String get diagnosticsDescription => 'Comprobar el estado de tu conexión';

  @override
  String get viewConnectionHistory => 'Ver historial de conexión';

  @override
  String get pastConnections => 'Ver conexiones anteriores';

  @override
  String get profileAndSettings => 'Perfil y ajustes';

  @override
  String get accountInformation => 'Información de la cuenta';

  @override
  String get language => 'Idioma';

  @override
  String get activityPreferences => 'Preferencias de actividad';

  @override
  String get networkProfiles => 'Perfiles de red';

  @override
  String get securityAndPrivacy => 'Seguridad y privacidad';

  @override
  String get helpAndSupport => 'Ayuda y soporte';

  @override
  String get aboutDeGlitch => 'Acerca de DēGlitch';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get logOutQuestion => '¿Cerrar sesión?';

  @override
  String get logoutPrompt => '¿Seguro que quieres cerrar sesión en DēGlitch?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get chooseLanguage => 'Elegir idioma';

  @override
  String get languageSaved => 'Preferencia de idioma guardada.';

  @override
  String get languageChangeNotConfigured =>
      'El cambio de idioma todavía no está conectado a toda la aplicación. Conecta el controlador de idioma en la raíz de la aplicación.';

  @override
  String get premium => 'Premium';

  @override
  String get yourConnectivityToolkit =>
      'Tu conjunto de herramientas de conectividad';

  @override
  String get manageToolsDescription =>
      'Administra herramientas, comportamiento de conexión y soporte.';

  @override
  String get quickTools => 'Herramientas rápidas';

  @override
  String get recommend => 'Recomendar';

  @override
  String get findBetterRoute => 'Encontrar una mejor ruta';

  @override
  String get history => 'Historial';

  @override
  String get connectionPreferences => 'Preferencias de conexión';

  @override
  String get autoConnect => 'Conexión automática';

  @override
  String get autoConnectDescription =>
      'Conectarse automáticamente cuando la aplicación active esta opción';

  @override
  String get liteMode => 'Modo ligero';

  @override
  String get liteModeDescription =>
      'Reducir la actividad en segundo plano que no sea esencial';

  @override
  String get dataSaver => 'Ahorro de datos';

  @override
  String get dataSaverDescription =>
      'Limitar el uso opcional de datos en segundo plano';

  @override
  String get moreOptions => 'Más opciones';

  @override
  String get manageSavedConnectionPreferences =>
      'Administrar preferencias de conexión guardadas';

  @override
  String get splitTunneling => 'Túnel dividido';

  @override
  String get splitTunnelingDescription => 'Elegir qué aplicaciones usan la VPN';

  @override
  String get soon => 'Próximamente';

  @override
  String get reviewPermissionsAndDataControls =>
      'Revisar permisos y controles de datos';

  @override
  String get aiAssistant => 'Asistente de IA';

  @override
  String get aiAssistantDescription =>
      'Obtener ayuda para entender tu conexión';

  @override
  String get networkBoost => 'Optimización de red';

  @override
  String get networkBoostDescription =>
      'Comprobar las métricas disponibles y aplicar optimizaciones compatibles.';

  @override
  String get networkBoostDisclaimer =>
      'Los resultados dependen de la red, el dispositivo, el punto de conexión y el proveedor. No se garantiza un aumento fijo de velocidad.';

  @override
  String get askAssistant => 'Preguntar a DēGlitch';

  @override
  String get send => 'Enviar';

  @override
  String get assistantGreeting =>
      '¡Hola! Puedo ayudarte a entender el estado de conexión, los diagnósticos, la elección del servidor, el modo ligero y los ajustes compatibles.';

  @override
  String get assistantUnavailable =>
      'El servicio del asistente aún no está conectado. Puedes seguir usando los ajustes disponibles.';

  @override
  String get connectionStatus => 'Estado de conexión';

  @override
  String get connectedFor => 'Conectado durante';

  @override
  String get connectionHealth => 'Salud de la conexión';

  @override
  String get speed => 'Velocidad';

  @override
  String get stability => 'Estabilidad';

  @override
  String get security => 'Seguridad';

  @override
  String get high => 'Alta';

  @override
  String get stable => 'Estable';

  @override
  String get protected => 'Protegido';

  @override
  String get aiRecommended => 'Recomendado por IA';

  @override
  String get allServers => 'Todos los servidores';

  @override
  String get favorites => 'Favoritos';

  @override
  String get recommended => 'Recomendado';

  @override
  String get lowestMeasuredLatency => 'Menor latencia medida';

  @override
  String get latency => 'Latencia';

  @override
  String get packetLoss => 'Pérdida de paquetes';

  @override
  String get healthScore => 'Puntuación de salud';

  @override
  String get otherAvailableServers => 'Otros servidores disponibles';

  @override
  String get bestChoice => 'Mejor opción';

  @override
  String connectToServer(String serverName) {
    return 'Conectar a $serverName';
  }

  @override
  String get diagnosticsComplete => 'Diagnóstico completado';

  @override
  String get checksHaveResults =>
      'Todas las comprobaciones completadas tienen resultados';

  @override
  String get internetConnection => 'Conexión a Internet';

  @override
  String get dns => 'DNS';

  @override
  String get packetLossTest => 'Prueba de pérdida de paquetes';

  @override
  String get latencyTest => 'Prueba de latencia';

  @override
  String get jitterTest => 'Prueba de fluctuación';

  @override
  String get serverLoad => 'Carga del servidor';

  @override
  String get vpnEndpoint => 'Punto de conexión VPN';

  @override
  String get unavailable => 'No disponible';

  @override
  String get passed => 'Correcto';

  @override
  String get runAgain => 'Ejecutar de nuevo';

  @override
  String get serverTelemetryUnavailable =>
      'La telemetría del servidor no está conectada.';

  @override
  String get tunnelStatusUnavailable =>
      'El estado del túnel en tiempo real no está conectado al diagnóstico.';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get aiResponseDisclaimer =>
      'Puedo explicar las métricas disponibles y sugerir comprobaciones compatibles, pero no garantizar un aumento de velocidad concreto.';

  @override
  String get networkBoostStatus => 'Estado de optimización de red';

  @override
  String get noData => 'No hay datos';

  @override
  String get clearHistory => 'Borrar historial';

  @override
  String get clear => 'Borrar';

  @override
  String get save => 'Guardar';

  @override
  String get close => 'Cerrar';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get retry => 'Reintentar';

  @override
  String get errorTryAgain => 'Se produjo un error. Inténtalo de nuevo.';

  @override
  String get noServers => 'No hay servidores disponibles en este momento.';

  @override
  String get profileImported => 'Perfil importado';

  @override
  String get importSelectProfile => 'Importar/seleccionar el perfil local';

  @override
  String get activityGaming => 'Videojuegos';

  @override
  String get activityStreaming => 'Streaming';

  @override
  String get activityStudy => 'Estudio';

  @override
  String get activityWork => 'Trabajo';

  @override
  String get privacyControls => 'Controles de privacidad';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get languageRestartNote =>
      'El idioma elegido se aplica a toda la aplicación y se recuerda en este dispositivo.';

  @override
  String get aboutTagline => 'Conectividad más inteligente. Un mejor camino.';

  @override
  String get serverDetails => 'Detalles del servidor';

  @override
  String get reconnect => 'Reconectar';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get connect => 'Conectar';
}
