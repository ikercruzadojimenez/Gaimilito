import 'package:flutter/material.dart';
import 'app_colors.dart';

class EmpresaResultado {
  final String nombre;
  final String origen;
  final String resumen;
  final String? fechaContactoPrevio; // Si no es null, ya fue contactada
  bool enviadaAlRedactor;

  EmpresaResultado({
    required this.nombre,
    required this.origen,
    required this.resumen,
    this.fechaContactoPrevio,
    this.enviadaAlRedactor = false,
  });

  bool get yaContactada => fechaContactoPrevio != null;
}

class PantallaBuscador extends StatefulWidget {
  const PantallaBuscador({super.key});

  @override
  State<PantallaBuscador> createState() => _PantallaBuscadorState();
}

class _PantallaBuscadorState extends State<PantallaBuscador> {
  final TextEditingController _puestoController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();

  String _origenSeleccionado = 'LinkedIn';
  List<EmpresaResultado> _resultados = [];

  // TODO: Cargar este mapa desde la colección 'empresas_contactadas' en Firestore
  final Map<String, String> _historialContactadas = {
    'cloudbit systems': '18/11/2026',
  };

  @override
  void dispose() {
    _puestoController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  String? _buscarFechaContacto(String nombreEmpresa) {
    return _historialContactadas[nombreEmpresa.toLowerCase().trim()];
  }

  void _buscarEmpresas() {
    final puesto = _puestoController.text.trim();
    final ubicacion = _ubicacionController.text.trim();

    if (puesto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un puesto para buscar.')),
      );
      return;
    }

    final simuladas = [
      (
      'TechNova Solutions',
      'Consultora tecnológica en ${ubicacion.isEmpty ? "España" : ubicacion}. Buscan perfil junior/prácticas para $puesto con stack Flutter y Java.',
      ),
      (
      'CloudBit Systems',
      'Empresa de desarrollo de software a medida. Equipo de 40 personas, modalidad híbrida y programa activo de prácticas DAM.',
      ),
      (
      'NubeCore Labs',
      'Startup enfocada en automatización e IA. Proyectos móviles y backend en la nube con incorporación flexible.',
      ),
    ];

    setState(() {
      _resultados = simuladas.map((e) {
        return EmpresaResultado(
          nombre: e.$1,
          origen: _origenSeleccionado,
          resumen: e.$2,
          fechaContactoPrevio: _buscarFechaContacto(e.$1),
        );
      }).toList();
    });
  }

  // TODO: Guardar en Firestore ('borradores' y registrar en 'empresas_contactadas')
  void _enviarAlRedactor(int index) {
    final empresa = _resultados[index];
    setState(() {
      empresa.enviadaAlRedactor = true;
      _historialContactadas[empresa.nombre.toLowerCase().trim()] = 'Hoy';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${empresa.nombre} enviada al redactor.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: AppColors.textoSecundario),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: AppColors.tarjeta,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.borde),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _puestoController,
                    style: const TextStyle(color: AppColors.textoPrincipal),
                    decoration: _inputDecoration(
                      'Puesto',
                      'Ej: Prácticas DAM, Flutter...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ubicacionController,
                    style: const TextStyle(color: AppColors.textoPrincipal),
                    decoration: _inputDecoration(
                      'Ubicación',
                      'Ej: Madrid, Remoto...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Google', 'LinkedIn'].map((fuente) {
                      final seleccionado = _origenSeleccionado == fuente;
                      return ChoiceChip(
                        label: Text(fuente),
                        selected: seleccionado,
                        backgroundColor: AppColors.tarjeta,
                        selectedColor: AppColors.primarioSuave,
                        labelStyle: TextStyle(
                          color: seleccionado
                              ? AppColors.primario
                              : AppColors.textoSecundario,
                          fontWeight: seleccionado
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: seleccionado
                              ? AppColors.primario
                              : AppColors.borde,
                        ),
                        onSelected: (_) {
                          setState(() => _origenSeleccionado = fuente);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _buscarEmpresas,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primario,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Buscar empresas',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _resultados.isEmpty
                ? const Center(
              child: Text(
                'Sin resultados.',
                style: TextStyle(color: AppColors.textoSecundario),
              ),
            )
                : ListView.separated(
              itemCount: _resultados.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final empresa = _resultados[index];
                final bool bloqueada =
                    empresa.yaContactada || empresa.enviadaAlRedactor;

                return Card(
                  elevation: 0,
                  color: AppColors.tarjeta,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: empresa.yaContactada
                          ? AppColors.aviso.withValues(alpha: 0.4)
                          : AppColors.borde,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                empresa.nombre,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textoPrincipal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (empresa.yaContactada) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.avisoSuave,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Ya contactada (${empresa.fechaContactoPrevio})',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.aviso,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.campoFondo,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.borde,
                                ),
                              ),
                              child: Text(
                                empresa.origen,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textoSecundario,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          empresa.resumen,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textoSecundario,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: bloqueada
                                ? null
                                : () => _enviarAlRedactor(index),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primario,
                              side: BorderSide(
                                color: bloqueada
                                    ? AppColors.borde
                                    : AppColors.primario,
                              ),
                            ),
                            child: Text(
                              empresa.yaContactada
                                  ? 'Ya contactada'
                                  : empresa.enviadaAlRedactor
                                  ? 'Enviada al redactor'
                                  : 'Enviar al redactor',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}