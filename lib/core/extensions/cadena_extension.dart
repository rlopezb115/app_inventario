extension CadenaExtension on String?
{
    bool get esDiferenteDeNuloYVacio => this != null && this!.trim() != '';
}