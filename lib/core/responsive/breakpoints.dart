/// Puntos de quiebre para diseño responsive.
///
/// El proyecto es "mobile-first con web-ready arquitectónico":
/// el desarrollo se enfoca en móvil pero la arquitectura soporta web/tablet.
abstract class Breakpoints {
  /// < 600px = móvil (default)
  static const double mobile = 600;

  /// 600-900px = tablet
  static const double tablet = 900;

  /// > 900px = desktop / web grande
  static const double desktop = 1200;
}
