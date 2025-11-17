import 'package:flutter/material.dart';
import 'pages/kahoot_editor_page.dart';

void main() {
	runApp(const PresentationApp());
}

class PresentationApp extends StatelessWidget {
	const PresentationApp({super.key});

	@override
	Widget build(BuildContext context) {
		final seed = Colors.purple;
		final colorScheme = ColorScheme.fromSeed(seedColor: seed);

			return MaterialApp(
				title: 'Quiz Editor',
				debugShowCheckedModeBanner: false,
			theme: ThemeData(
				colorScheme: colorScheme,
				useMaterial3: true,
				primaryColor: colorScheme.primary,
				scaffoldBackgroundColor: colorScheme.background,
				appBarTheme: AppBarTheme(
					backgroundColor: colorScheme.primary,
					foregroundColor: colorScheme.onPrimary,
					elevation: 2,
				),
				elevatedButtonTheme: ElevatedButtonThemeData(
					style: ElevatedButton.styleFrom(
						backgroundColor: colorScheme.primary,
						foregroundColor: colorScheme.onPrimary,
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
					),
				),
				inputDecorationTheme: InputDecorationTheme(
					filled: true,
					fillColor: colorScheme.surface.withOpacity(0.04),
					border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
				),

			),
					home: const KahootEditorPage(),
		);
	}
}
