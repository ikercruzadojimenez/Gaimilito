import 'package:flutter/material.dart';
import 'app_colors.dart';

class _ObjetivoGlobalItem {
  final String id;
  final TextEditingController controller;
  bool completado;

  _ObjetivoGlobalItem({
    required this.id,
    String textoInicial = '',
    this.completado = false,
  }) : controller = TextEditingController(text: textoInicial);
}

class PantallaObjetivos extends StatefulWidget {
  const PantallaObjetivos({super.key});

  @override
  State<PantallaObjetivos> createState() => _PantallaObjetivosState();
}

class _PantallaObjetivosState extends State<PantallaObjetivos> {
  bool _diarioCompletado = false;
  bool _semanalCompletado = false;

  final TextEditingController _diarioController = TextEditingController();
  final TextEditingController _semanalController = TextEditingController();

  final List<_ObjetivoGlobalItem> _objetivosGlobales = [
    _ObjetivoGlobalItem(id: 'global_1'),
  ];

  @override
  void dispose() {
    _diarioController.dispose();
    _semanalController.dispose();
    for (final item in _objetivosGlobales) {
      item.controller.dispose();
    }
    super.dispose();
  }

  // TODO: Conectar con Firestore (colección 'objetivos')
  void _guardarObjetivoUnico(String tipo, String texto, bool completado) {}

  // TODO: Conectar con Firestore (colección 'objetivos_globales')
  void _guardarObjetivoGlobal(_ObjetivoGlobalItem item) {}

  void _anadirObjetivoGlobal() {
    setState(() {
      _objetivosGlobales.add(
        _ObjetivoGlobalItem(
          id: 'global_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
    });
  }

  void _eliminarObjetivoGlobal(int index) {
    final item = _objetivosGlobales[index];
    setState(() {
      _objetivosGlobales.removeAt(index);
    });
    item.controller.dispose();
    // TODO: Borrar también el documento item.id en Firestore
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textoSecundario),
      filled: true,
      fillColor: AppColors.campoFondo,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borde),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borde),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primario, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        _buildTarjetaObjetivoUnico(
          titulo: 'Objetivo Diario',
          subtitulo: 'Caduca a medianoche',
          completado: _diarioCompletado,
          controller: _diarioController,
          onCheckChanged: (val) {
            setState(() => _diarioCompletado = val ?? false);
            _guardarObjetivoUnico(
              'diario',
              _diarioController.text,
              _diarioCompletado,
            );
          },
          onTextChanged: (text) {
            _guardarObjetivoUnico('diario', text, _diarioCompletado);
          },
        ),
        const SizedBox(height: 16),
        _buildTarjetaObjetivoUnico(
          titulo: 'Objetivo Semanal',
          subtitulo: 'Caduca el domingo',
          completado: _semanalCompletado,
          controller: _semanalController,
          onCheckChanged: (val) {
            setState(() => _semanalCompletado = val ?? false);
            _guardarObjetivoUnico(
              'semanal',
              _semanalController.text,
              _semanalCompletado,
            );
          },
          onTextChanged: (text) {
            _guardarObjetivoUnico('semanal', text, _semanalCompletado);
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Objetivos Globales',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoPrincipal,
                  ),
                ),
                Text(
                  'A largo plazo',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: _anadirObjetivoGlobal,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Añadir'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primario,
                backgroundColor: AppColors.primarioSuave,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_objetivosGlobales.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'Sin objetivos globales.',
                style: TextStyle(color: AppColors.textoSecundario),
              ),
            ),
          )
        else
          ...List.generate(_objetivosGlobales.length, (index) {
            final item = _objetivosGlobales[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                elevation: 0,
                color: AppColors.tarjeta,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: item.completado ? AppColors.primario : AppColors.borde,
                    width: item.completado ? 1.5 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: item.completado,
                        activeColor: AppColors.primario,
                        onChanged: (val) {
                          setState(() => item.completado = val ?? false);
                          _guardarObjetivoGlobal(item);
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: item.controller,
                          maxLines: 3,
                          minLines: 1,
                          onChanged: (_) => _guardarObjetivoGlobal(item),
                          style: TextStyle(
                            decoration: item.completado
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: item.completado
                                ? AppColors.textoSecundario
                                : AppColors.textoPrincipal,
                          ),
                          decoration: _inputDecoration(
                            'Objetivo global ${index + 1}...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.textoSecundario,
                        ),
                        tooltip: 'Eliminar objetivo',
                        onPressed: () => _eliminarObjetivoGlobal(index),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildTarjetaObjetivoUnico({
    required String titulo,
    required String subtitulo,
    required bool completado,
    required TextEditingController controller,
    required ValueChanged<bool?> onCheckChanged,
    required ValueChanged<String> onTextChanged,
  }) {
    return Card(
      elevation: 0,
      color: AppColors.tarjeta,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: completado ? AppColors.primario : AppColors.borde,
          width: completado ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: completado,
                  activeColor: AppColors.primario,
                  onChanged: onCheckChanged,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textoPrincipal,
                        decoration: completado
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              minLines: 2,
              onChanged: onTextChanged,
              style: TextStyle(
                decoration: completado
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: completado
                    ? AppColors.textoSecundario
                    : AppColors.textoPrincipal,
              ),
              decoration: _inputDecoration('Escribe el objetivo...'),
            ),
          ],
        ),
      ),
    );
  }
}