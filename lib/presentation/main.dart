import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_shell.dart';
import 'pages/category_detail_page.dart';
import 'pages/partner_collection_page.dart';
import 'pages/course_detail_page.dart';
import 'pages/hashtag_page.dart';
import 'data/categories_data.dart';
import 'data/partner_collections.dart';
import 'data/sample_extra_content.dart';
import 'components/categories_grid.dart';
import 'theme/theme_controller.dart';

void main() {
	runApp(const PresentationApp());
}

class PresentationApp extends StatelessWidget {
	const PresentationApp({super.key});

	ThemeData _buildTheme(ColorScheme scheme, Color scaffoldColor, bool isDark) {
		return ThemeData(
			colorScheme: scheme,
			useMaterial3: true,
			primaryColor: scheme.primary,
			scaffoldBackgroundColor: scaffoldColor,
			appBarTheme: AppBarTheme(
				backgroundColor: scheme.surfaceContainerHighest,
				foregroundColor: scheme.onSurface,
				elevation: isDark ? 0 : 1,
				systemOverlayStyle: SystemUiOverlayStyle(
					statusBarColor: scheme.surfaceContainerHighest,
					statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
				),
			),
			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ElevatedButton.styleFrom(
					backgroundColor: scheme.primary,
					foregroundColor: scheme.onPrimary,
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
				),
			),
			inputDecorationTheme: InputDecorationTheme(
				filled: true,
				fillColor: scheme.surface.withAlpha(20),
				border: OutlineInputBorder(
					borderRadius: BorderRadius.circular(8),
					borderSide: BorderSide.none,
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		const seed = Color(0xFF5B00D4);
		final darkScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
		final lightScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);

		return AnimatedBuilder(
			animation: themeController,
			builder: (context, _) {
				return MaterialApp(
					title: 'Quiz Editor',
					debugShowCheckedModeBanner: false,
					theme: _buildTheme(lightScheme, Colors.white, false),
					darkTheme: _buildTheme(darkScheme, const Color(0xFF1F1F1F), true),
					themeMode: themeController.mode,
					home: const HomeShell(),
					onGenerateRoute: (settings) {
					final name = settings.name ?? '';
					if (name.startsWith('/categoria/')) {
						final slug = name.substring('/categoria/'.length);
						final arg = settings.arguments;
						final category = arg is CategoryItem ? arg : categoryFromSlug(slug);
						return MaterialPageRoute(
							builder: (_) => CategoryDetailPage(category: category),
							settings: RouteSettings(name: name, arguments: category),
						);
					}
					if (name.startsWith('/coleccion/')) {
						final id = name.substring('/coleccion/'.length);
						final arg = settings.arguments;
						final collection = arg is PartnerCollection ? arg : partnerCollectionById(id);
						return MaterialPageRoute(
							builder: (_) => PartnerCollectionPage(collection: collection),
							settings: RouteSettings(name: name, arguments: collection),
						);
					}
					if (name.startsWith('/curso/')) {
						final id = name.substring('/curso/'.length);
						final arg = settings.arguments;
						final course = arg is Course ? arg : courseById(id);
						return MaterialPageRoute(
							builder: (_) => CourseDetailPage(course: course),
							settings: RouteSettings(name: name, arguments: course),
						);
					}
					if (name.startsWith('/hashtag/')) {
						final slug = name.substring('/hashtag/'.length);
						final arg = settings.arguments;
						final group = arg is HashtagGroup ? arg : hashtagBySlug(slug);
						return MaterialPageRoute(
							builder: (_) => HashtagPage(group: group),
							settings: RouteSettings(name: name, arguments: group),
						);
					}
					return null;
				},
				);
			},
		);
	}
}