import 'dart:io';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'objetivos_view.dart';
import 'buscador_view.dart';
import 'correos_view.dart';

void main() {
  runApp(const gmAIl());
}

class gmAIl extends StatelessWidget {
  const gmAIl({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gmAIl',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primario,
          primary: AppColors.primario,
          surface: AppColors.fondo,
        ),
        scaffoldBackgroundColor: AppColors.fondo,
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _vistas = const [
    PantallaObjetivos(),
    PantallaCorreosCRM(),
    PantallaBuscador(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildLogoText({double fontSize = 22}) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.textoPrincipal,
          letterSpacing: -0.5,
        ),
        children: const [
          TextSpan(text: 'gm'),
          TextSpan(
            text: 'AI',
            style: TextStyle(color: AppColors.primario),
          ),
          TextSpan(text: 'l'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Platform.isAndroid;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: _buildLogoText(fontSize: 20),
          elevation: 0,
          backgroundColor: AppColors.tarjeta,
          foregroundColor: AppColors.textoPrincipal,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1, color: AppColors.borde),
          ),
        ),
        body: _vistas[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.borde, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppColors.primario,
            unselectedItemColor: AppColors.textoSecundario,
            backgroundColor: AppColors.tarjeta,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.track_changes),
                label: 'Objetivos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail_outline),
                label: 'Correos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Buscador',
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 220,
              color: AppColors.sidebarFondo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: _buildLogoText(fontSize: 24),
                  ),
                  _buildSidebarItem(
                    icon: Icons.track_changes,
                    label: 'Objetivos',
                    index: 0,
                  ),
                  _buildSidebarItem(
                    icon: Icons.mail_outline,
                    label: 'Correos',
                    index: 1,
                  ),
                  _buildSidebarItem(
                    icon: Icons.search,
                    label: 'Buscador',
                    index: 2,
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              thickness: 1,
              width: 1,
              color: AppColors.borde,
            ),
            Expanded(
              child: _vistas[_selectedIndex],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(icon),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primario,
        selectedTileColor: AppColors.primarioSuave,
        iconColor: AppColors.textoSecundario,
        textColor: AppColors.textoSecundario,
        onTap: () => _onItemTapped(index),
      ),
    );
  }
}