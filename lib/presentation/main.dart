import 'package:flutter/material.dart';
import 'pages/kahoot_editor_page.dart';

void main() {
	runApp(const PresentationApp());
}

class PresentationApp extends StatelessWidget {
	const PresentationApp({super.key});

	@override
	Widget build(BuildContext context) {
			final seed = Colors.deepPurple;
			return MaterialApp(
				title: 'Quiz Editor',
				theme: ThemeData(
					useMaterial3: false,
					colorScheme: ColorScheme.fromSeed(seedColor: seed),
					primarySwatch: Colors.deepPurple,
					primaryColor: Colors.deepPurple[700],
					appBarTheme: AppBarTheme(
						backgroundColor: Colors.deepPurple[600],
						foregroundColor: Colors.white,
						elevation: 2,
					),
					elevatedButtonTheme: ElevatedButtonThemeData(
						style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[600]),
					),
					textButtonTheme: TextButtonThemeData(
						style: TextButton.styleFrom(foregroundColor: Colors.deepPurple[600]),
					),
					floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.deepPurple[600]),
			// cardTheme omitted to avoid SDK type mismatch; individual Cards keep local styling
				),
				home: const KahootEditorPage(),
			);
	}
}
