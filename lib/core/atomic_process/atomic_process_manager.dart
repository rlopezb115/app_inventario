import 'atomic_session.dart';

/// Contrato global para el administrador de procesos atómicos.
/// Garantiza la regla del "todo o nada": si algo falla o se aborta, 
/// se revierte cualquier cambio colateral.
abstract class AtomicProcessManager
{
    /// Ejecuta un bloque de operaciones dentro de un entorno seguro y reversible.
    Future<T> runInAtomicProcess<T>(Future<T> Function(AtomicSession session) action);
}