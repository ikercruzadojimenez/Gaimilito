import 'package:flutter/material.dart';
import 'app_colors.dart';

class BorradorItem {
  final String id;
  final String empresa;
  final TextEditingController asuntoController;
  final TextEditingController cuerpoController;

  BorradorItem({
    required this.id,
    required this.empresa,
    required String asunto,
    required String cuerpo,
  })  : asuntoController = TextEditingController(text: asunto),
        cuerpoController = TextEditingController(text: cuerpo);

  void dispose() {
    asuntoController.dispose();
    cuerpoController.dispose();
  }
}

class EmpresaSeleccionadaItem {
  final String id;
  final String empresa;
  final String fecha;
  final String mensajeIntegro;
  final String? entrevistaDetectada; // Extraído por Gemini si proponen cita
  bool agendadaEnCalendar;

  EmpresaSeleccionadaItem({
    required this.id,
    required this.empresa,
    required this.fecha,
    required this.mensajeIntegro,
    this.entrevistaDetectada,
    this.agendadaEnCalendar = false,
  });
}

class PantallaCorreosCRM extends StatefulWidget {
  const PantallaCorreosCRM({super.key});

  @override
  State<PantallaCorreosCRM> createState() => _PantallaCorreosCRMState();
}

class _PantallaCorreosCRMState extends State<PantallaCorreosCRM> {
  bool _borradoresExpandidos = true;

  // Datos de ejemplo para validar la UI antes de conectar Firestore e IA
  final List<BorradorItem> _borradores = [
    BorradorItem(
      id: 'draft_1',
      empresa: 'TechNova Solutions',
      asunto: 'Candidatura para prácticas DAM - Desarrollo Flutter / Java',
      cuerpo:
      'Estimado equipo de TechNova Solutions,\n\nSoy estudiante de 2º de DAM con experiencia práctica en Flutter, Dart, Java y Firebase. Adjunto mi CV para optar a una plaza de prácticas en vuestro equipo de desarrollo.\n\nQuedo a vuestra disposición para una breve entrevista.\nUn saludo,\nIker',
    ),
    BorradorItem(
      id: 'draft_2',
      empresa: 'CloudBit Systems',
      asunto: 'Solicitud de incorporación en prácticas (Grado Superior DAM)',
      cuerpo:
      'Buenos días,\n\nMe pongo en contacto con CloudBit Systems interesado en realizar mis prácticas de DAM en modalidad híbrida. Desarrollo aplicaciones multiplataforma y automatizaciones con APIs.\n\nAdjunto mi currículum actualizado.\nUn saludo,\nIker',
    ),
  ];

  final List<EmpresaSeleccionadaItem> _seleccionadas = [
    EmpresaSeleccionadaItem(
      id: 'sel_1',
      empresa: 'NubeCore Labs',
      fecha: 'Hoy, 10:24',
      entrevistaDetectada: 'Jueves 26 Nov · 11:00h (Videollamada)',
      mensajeIntegro:
      'Hola Iker,\n\nHemos revisado tu perfil y nos interesa mucho tu experiencia con Flutter y Java. ¿Te vendría bien el jueves 26 de noviembre a las 11:00h para una entrevista técnica breve de 20 minutos por videollamada?\n\nUn saludo,\nEquipo de Talento - NubeCore Labs',
    ),
    EmpresaSeleccionadaItem(
      id: 'sel_2',
      empresa: 'DevSpark Iberia',
      fecha: 'Ayer, 16:45',
      mensajeIntegro:
      'Buenos días Iker,\n\nGracias por enviarnos tu CV. Estamos buscando un perfil de prácticas DAM para nuestro equipo de apps multiplataforma. Indícanos por favor las fechas de inicio y horas totales de tus prácticas.\n\nSaludos,\nRRHH DevSpark',
    ),
  ];

  @override
  void dispose() {
    for (final b in _borradores) {
      b.dispose();
    }
    super.dispose();
  }

  // TODO: Enviar asuntoController.text y cuerpoController.text a Apps Script para enviar en Gmail
  void _autorizarYEnviar(int index) {
    final borrador = _borradores[index];
    final nombreEmpresa = borrador.empresa;
    setState(() {
      _borradores.removeAt(index);
    });
    borrador.dispose();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Correo autorizado y enviado a $nombreEmpresa.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // TODO: Eliminar borrador en Firestore y Gmail
  void _descartarBorrador(int index) {
    final borrador = _borradores[index];
    final nombreEmpresa = borrador.empresa;
    setState(() {
      _borradores.removeAt(index);
    });
    borrador.dispose();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Borrador para $nombreEmpresa descartado.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // TODO: Eliminar documento de la colección 'empresas_seleccionadas' en Firestore
  void _borrarSeleccionada(int index) {
    final item = _seleccionadas[index];
    setState(() {
      _seleccionadas.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.empresa} eliminada del panel.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // TODO: Lanzar petición HTTP POST al backend (Apps Script + Gemini) para redactar seguimiento
  void _generarNuevaRespuesta(EmpresaSeleccionadaItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Solicitando nuevo borrador de seguimiento para ${item.empresa}...',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // TODO: Llamar a Apps Script (CalendarApp.createEvent) y actualizar Firestore
  void _agendarEnCalendar(EmpresaSeleccionadaItem item) {
    setState(() {
      item.agendadaEnCalendar = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Entrevista con ${item.empresa} agendada en Google Calendar.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  InputDecoration _editableDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 12,
        color: AppColors.textoSecundario,
      ),
      filled: true,
      fillColor: AppColors.campoFondo,
      isDense: true,
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
        // SECCIÓN 1: BORRADORES LISTOS (plegable + editables antes de enviar)
        InkWell(
          onTap: () {
            setState(() {
              _borradoresExpandidos = !_borradoresExpandidos;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCabeceraSeccion(
                  titulo: 'Borradores Listos',
                  contador: _borradores.length,
                  badgeColor: AppColors.primarioSuave,
                  badgeTextColor: AppColors.primario,
                ),
                Icon(
                  _borradoresExpandidos
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textoSecundario,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_borradoresExpandidos) ...[
          if (_borradores.isEmpty)
            _buildEstadoVacio('No hay borradores pendientes de autorización.')
          else
            ...List.generate(_borradores.length, (index) {
              final borrador = _borradores[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Card(
                  elevation: 0,
                  color: AppColors.tarjeta,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.borde),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      key: ValueKey(borrador.id),
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        16,
                      ),
                      leading: const Icon(
                        Icons.drafts_outlined,
                        color: AppColors.primario,
                        size: 20,
                      ),
                      title: Text(
                        borrador.empresa,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textoPrincipal,
                        ),
                      ),
                      subtitle: Text(
                        borrador.asuntoController.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textoSecundario,
                        ),
                      ),
                      iconColor: AppColors.primario,
                      collapsedIconColor: AppColors.textoSecundario,
                      children: [
                        TextField(
                          controller: borrador.asuntoController,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textoPrincipal,
                          ),
                          decoration: _editableDecoration('Asunto'),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: borrador.cuerpoController,
                          maxLines: 7,
                          minLines: 4,
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.45,
                            color: AppColors.textoPrincipal,
                          ),
                          decoration: _editableDecoration(
                            'Mensaje (editable antes de enviar)',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _descartarBorrador(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 18,
                              ),
                              label: const Text('Descartar'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.peligro,
                                backgroundColor: AppColors.peligroSuave,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () => _autorizarYEnviar(index),
                              icon: const Icon(
                                Icons.send_outlined,
                                size: 16,
                              ),
                              label: const Text('Autorizar y Enviar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primario,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],

        const SizedBox(height: 24),
        const Divider(color: AppColors.borde, thickness: 1),
        const SizedBox(height: 24),

        // SECCIÓN 2: EMPRESAS QUE ME HAN SELECCIONADO (filtradas por IA + Calendar)
        _buildCabeceraSeccion(
          titulo: 'Empresas que me han seleccionado',
          contador: _seleccionadas.length,
          badgeColor: AppColors.exitoSuave,
          badgeTextColor: AppColors.exito,
        ),
        const SizedBox(height: 12),
        if (_seleccionadas.isEmpty)
          _buildEstadoVacio('Sin respuestas positivas registradas todavía.')
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final bool dosColumnas = constraints.maxWidth >= 720;
              final double anchoTarjeta = dosColumnas
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(_seleccionadas.length, (index) {
                  final item = _seleccionadas[index];
                  return SizedBox(
                    width: anchoTarjeta,
                    child: Card(
                      elevation: 0,
                      color: AppColors.tarjeta,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.borde),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          key: ValueKey(item.id),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            16,
                          ),
                          leading: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.exito,
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            item.empresa,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textoPrincipal,
                            ),
                          ),
                          subtitle: Text(
                            item.entrevistaDetectada != null
                                ? '${item.fecha} · Entrevista propuesta'
                                : item.fecha,
                            style: TextStyle(
                              fontSize: 12,
                              color: item.entrevistaDetectada != null
                                  ? AppColors.primario
                                  : AppColors.textoSecundario,
                              fontWeight: item.entrevistaDetectada != null
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          iconColor: AppColors.primario,
                          collapsedIconColor: AppColors.textoSecundario,
                          children: [
                            if (item.entrevistaDetectada != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarioSuave,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.event_available,
                                      size: 18,
                                      color: AppColors.primario,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.entrevistaDetectada!,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textoPrincipal,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: item.agendadaEnCalendar
                                          ? null
                                          : () => _agendarEnCalendar(item),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primario,
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: Text(
                                        item.agendadaEnCalendar
                                            ? 'Agendada'
                                            : 'Agendar',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.campoFondo,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.borde),
                              ),
                              child: Text(
                                item.mensajeIntegro,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  height: 1.45,
                                  color: AppColors.textoPrincipal,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _borrarSeleccionada(index),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                  ),
                                  label: const Text('Borrar'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.peligro,
                                    backgroundColor: AppColors.peligroSuave,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _generarNuevaRespuesta(item),
                                  icon: const Icon(
                                    Icons.auto_awesome,
                                    size: 16,
                                  ),
                                  label: const Text('Generar nueva respuesta'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primario,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
      ],
    );
  }

  Widget _buildCabeceraSeccion({
    required String titulo,
    required int contador,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    return Row(
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textoPrincipal,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$contador',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: badgeTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstadoVacio(String mensaje) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.tarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borde),
      ),
      child: Center(
        child: Text(
          mensaje,
          style: const TextStyle(color: AppColors.textoSecundario),
        ),
      ),
    );
  }
}