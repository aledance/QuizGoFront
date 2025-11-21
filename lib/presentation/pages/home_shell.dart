import 'package:flutter/material.dart';
import 'explore_page.dart';
import 'create_template_page.dart';
import 'home_page.dart';

class HomeShell extends StatefulWidget {
	const HomeShell({super.key});

	@override
	State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
	int _currentIndex = 0;

	late final List<_NavigationItem> _items = [
		_NavigationItem(
			label: 'Inicio',
			icon: Icons.home_outlined,
			selectedIcon: Icons.home,
			builder: () => HomePage(onCreateTap: () => _onSelect(2)),
		),
		_NavigationItem(
			label: 'Descubre',
			icon: Icons.explore_outlined,
			selectedIcon: Icons.explore,
			builder: () => const ExplorePage(),
		),
		_NavigationItem(
			label: 'Crear',
			icon: Icons.add_circle_outline,
			selectedIcon: Icons.add_circle,
			builder: () => const CreateTemplatePage(),
		),
		_NavigationItem(
			label: 'Biblioteca',
			icon: Icons.collections_bookmark_outlined,
			selectedIcon: Icons.collections_bookmark,
			builder: () => const _PlaceholderPage(title: 'Biblioteca'),
		),
		_NavigationItem(
			label: 'Unirse',
			icon: Icons.group_outlined,
			selectedIcon: Icons.group,
			builder: () => const _PlaceholderPage(title: 'Unirse'),
		),
	];

	late final List<Widget> _pages = _items.map((item) => item.builder()).toList();

	void _onSelect(int index) {
		if (_currentIndex == index) return;
		setState(() => _currentIndex = index);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			extendBody: true,
			body: IndexedStack(
				index: _currentIndex,
				children: _pages,
			),
			bottomNavigationBar: _RoundedNavBar(
				items: _items,
				currentIndex: _currentIndex,
				onSelect: _onSelect,
			),
		);
	}
}

class _NavigationItem {
	final String label;
	final IconData icon;
	final IconData selectedIcon;
	final Widget Function() builder;

	const _NavigationItem({
		required this.label,
		required this.icon,
		required this.selectedIcon,
		required this.builder,
	});
}

class _RoundedNavBar extends StatelessWidget {
	final List<_NavigationItem> items;
	final int currentIndex;
	final ValueChanged<int> onSelect;

	const _RoundedNavBar({
		required this.items,
		required this.currentIndex,
		required this.onSelect,
	});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final scheme = theme.colorScheme;
		final selectedGradient = LinearGradient(
			colors: [scheme.primary, scheme.primaryContainer],
			begin: Alignment.topLeft,
			end: Alignment.bottomRight,
		);
		final navBackground = scheme.surface;
		final shadowColor = scheme.primary.withValues(alpha: 0.12);

		return SafeArea(
			minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
			child: Container(
				padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
				decoration: BoxDecoration(
					color: navBackground,
					borderRadius: BorderRadius.circular(36),
					boxShadow: [
						BoxShadow(color: shadowColor, blurRadius: 30, offset: const Offset(0, 12)),
					],
				),
				child: Row(
					children: List.generate(items.length, (index) {
						final item = items[index];
						final selected = index == currentIndex;
						final iconColor = selected ? Colors.white : scheme.onSurface.withValues(alpha: 0.7);
						final labelColor = selected ? scheme.primary : scheme.onSurfaceVariant;

						return Expanded(
							child: GestureDetector(
								onTap: () => onSelect(index),
								behavior: HitTestBehavior.opaque,
								child: AnimatedContainer(
									duration: const Duration(milliseconds: 200),
									padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
									decoration: BoxDecoration(
										color: selected ? scheme.primary.withValues(alpha: 0.08) : Colors.transparent,
										borderRadius: BorderRadius.circular(30),
									),
									child: Column(
										mainAxisSize: MainAxisSize.min,
										children: [
											Container(
												padding: const EdgeInsets.all(8),
												decoration: BoxDecoration(
													gradient: selected ? selectedGradient : null,
													color: selected ? null : scheme.surfaceContainerHigh,
													borderRadius: BorderRadius.circular(999),
												),
												child: Icon(
													selected ? item.selectedIcon : item.icon,
													color: iconColor,
												),
											),
											const SizedBox(height: 6),
											Text(
												item.label,
												style: TextStyle(
													fontSize: 11,
													fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
													color: labelColor,
												),
											),
										],
									),
								),
							),
						);
					}),
				),
			),
		);
	}
}

class _PlaceholderPage extends StatelessWidget {
	final String title;

	const _PlaceholderPage({required this.title});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text(title)),
			body: Center(
				child: Text(
					'Pantalla "$title" pendiente',
					style: Theme.of(context).textTheme.titleLarge,
					textAlign: TextAlign.center,
				),
			),
		);
	}
}