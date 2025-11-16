import 'package:flutter/material.dart';
import 'pages/kahoot_editor_page.dart';

void main() {
	runApp(const PresentationApp());
}

class PresentationApp extends StatelessWidget {
	const PresentationApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Quiz Editor',
			theme: ThemeData(useMaterial3: false, primarySwatch: Colors.purple),
			home: const KahootEditorPage(),
		);
	}
}
