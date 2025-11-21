import 'package:flutter/material.dart';
// Asegúrate de que las rutas de importación sean correctas para tu proyecto
import 'package:flutter_application_1/core/utils/colors.dart';
import 'package:flutter_application_1/presentation/authentication/pages/user_profile.dart';
import 'package:flutter_application_1/domain/user/models/user.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable para controlar qué pestaña está seleccionada
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Usamos LayoutBuilder para decidir qué interfaz mostrar
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint para cambiar entre layouts
        const double breakpoint = 600.0;

        if (constraints.maxWidth > breakpoint) {
          // Si la pantalla es ancha (escritorio), mostramos la barra lateral
          return _buildDesktopLayout();
        } else {
          // Si la pantalla es estrecha (móvil), mostramos la barra inferior
          return _buildMobileLayout();
        }
      },
    );
  }

  // --- Layout para Escritorio (con NavigationRail) ---
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryPurple, darkPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            // 3. Barra de navegación lateral
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                // No permitimos la selección de ítems desactivados
                if (index != 0) return;
                setState(() => _selectedIndex = index);
              },
              backgroundColor: darkPurple.withOpacity(0.5),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: accentPink, size: 30),
              unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(0.7), size: 30),
              selectedLabelTextStyle: const TextStyle(color: accentPink),
              unselectedLabelTextStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.videogame_asset_outlined, color: Colors.grey.withOpacity(0.5)),
                  selectedIcon: const Icon(Icons.videogame_asset),
                  label: Text('Juegos', style: TextStyle(color: Colors.grey.withOpacity(0.7))),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined, color: Colors.grey.withOpacity(0.5)),
                  selectedIcon: const Icon(Icons.settings),
                  label: Text('Opciones', style: TextStyle(color: Colors.grey.withOpacity(0.7))),
                ),
              ],
            ),
            // Línea vertical para separar
            const VerticalDivider(thickness: 1, width: 1, color: Colors.white24),
            // 4. El resto del contenido de la página
            Expanded(
              child: _HomePageContent(user: widget.user),
            ),
          ],
        ),
      ),
    );
  }

  // --- Layout para Móvil (con BottomNavigationBar) ---
  Widget _buildMobileLayout() {
    return Scaffold(
      // 5. El contenido de la página se coloca en el body
      body: _HomePageContent(user: widget.user),
      // 6. Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          // Para desactivar un ítem, lo hacemos visualmente gris
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset_outlined, color: Colors.grey.withOpacity(0.7)),
            label: 'Juegos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, color: Colors.grey.withOpacity(0.7)),
            label: 'Opciones',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: darkPurple.withOpacity(0.95),
        selectedItemColor: accentPink,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        onTap: (index) {
          // No permitimos la selección de ítems desactivados
          if (index != 0) return;
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

// --- Widget de Contenido Principal ---
class _HomePageContent extends StatelessWidget {
  const _HomePageContent({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Se añade el gradiente también aquí para que el fondo sea consistente
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryPurple, darkPurple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        // En móvil queremos SafeArea, pero en escritorio no en el lado izquierdo.
        // `left: false` evita un padding extra junto al NavigationRail.
        left: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con bienvenida y acceso al perfil
            _buildHeader(context, user),
            const SizedBox(height: 30),
            // Título de la sección principal
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Elige un modo de juego',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.add_circle_outline,
                      label: 'Crear Quiz',
                      color: accentPink,
                      onTap: () {
                        // TODO: Navegar a la página de creación de quizzes
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navegando a Crear Quiz...')),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.explore_outlined,
                      label: 'Explorar',
                      color: Colors.orange,
                      onTap: () {
                        // TODO: Navegar a la página de exploración de quizzes
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navegando a Explorar...')),
                        );
                      },
                    ),

                    _buildActionCard(
                      context,
                      icon: Icons.folder_shared_outlined,
                      label: 'Mis Quizzes',
                      color: Colors.lightBlue,
                      onTap: () {
                        // TODO: Navegar a la página que muestra los quizzes del usuario
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navegando a Mis Quizzes...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Widget para el encabezado
  Widget _buildHeader(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hola de nuevo,', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
              Text(user.username, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfilePage(user: user))),
            child: const CircleAvatar(radius: 30, backgroundColor: accentPink, child: Icon(Icons.person, color: Colors.white, size: 35)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
    }
}
