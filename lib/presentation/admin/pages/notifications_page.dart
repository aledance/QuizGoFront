import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/infrastructure/datasources/notification_remote_data_source.dart';

class NotificationsPage extends StatefulWidget {
	const NotificationsPage({super.key});

	@override
	State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
	final _userIdCtrl = TextEditingController();
	final _titleCtrl = TextEditingController();
	final _messageCtrl = TextEditingController();
	String _audience = 'all';
	bool _sending = false;
	List<Map<String, dynamic>> _history = [];

	late final NotificationRemoteDataSource _ds;

	static const _adminToken = 'admin_token';

	@override
	void initState() {
		super.initState();
		_ds = NotificationRemoteDataSource(client: http.Client());
		_loadHistory();
	}

	Future<void> _loadHistory() async {
		try {
			final list = await _ds.listNotifications(authToken: _adminToken);
			setState(() => _history = list);
		} catch (e) {
			// ignore errors for quick demo
		}
	}

	Future<void> _send() async {
		final title = _titleCtrl.text.trim();
		final message = _messageCtrl.text.trim();
		final userId = _userIdCtrl.text.trim();
		if (title.isEmpty || message.isEmpty) {
			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title and message are required')));
			return;
		}
		if (_audience == 'user' && userId.isEmpty) {
			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User id is required for audience=user')));
			return;
		}
		setState(() => _sending = true);
		try {
			final payload = <String, dynamic>{'title': title, 'message': message, 'audience': _audience};
			if (_audience == 'user') payload['userId'] = userId;
			await _ds.sendNotification(payload, authToken: _adminToken);
			// Show friendly success message in Spanish
			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mensaje enviado exitosamente')));
			_titleCtrl.clear();
			_messageCtrl.clear();
			_userIdCtrl.clear();
			await _loadHistory();
			} catch (e) {
				// Show generic error message in Spanish; include detail in console
				ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al enviar mensaje')));
				// Log error to console for debugging
				// ignore: avoid_print
				print('Notification send error: $e');
		} finally {
			setState(() => _sending = false);
		}
	}

	@override
	void dispose() {
		_userIdCtrl.dispose();
		_titleCtrl.dispose();
		_messageCtrl.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Notificaciones')),
			body: Padding(
				padding: const EdgeInsets.all(12.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text('Enviar notificación (rápido demo)', style: TextStyle(fontWeight: FontWeight.bold)),
						const SizedBox(height: 8),
						Row(children: [
							const Text('Audience: '),
							const SizedBox(width: 8),
							DropdownButton<String>(
								value: _audience,
								items: const [DropdownMenuItem(value: 'all', child: Text('All')), DropdownMenuItem(value: 'user', child: Text('User'))],
								onChanged: (v) => setState(() => _audience = v ?? 'all'),
							)
						]),
						if (_audience == 'user') ...[
							const SizedBox(height: 8),
							TextField(controller: _userIdCtrl, decoration: const InputDecoration(labelText: 'User id (target)')),
						],
						const SizedBox(height: 8),
						TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
						const SizedBox(height: 8),
						TextField(controller: _messageCtrl, decoration: const InputDecoration(labelText: 'Message'), maxLines: 3),
						const SizedBox(height: 12),
						Row(children: [
							ElevatedButton.icon(onPressed: _sending ? null : _send, icon: const Icon(Icons.send), label: Text(_sending ? 'Enviando...' : 'Enviar')),
							const SizedBox(width: 12),
							ElevatedButton.icon(onPressed: _loadHistory, icon: const Icon(Icons.refresh), label: const Text('Refrescar'))
						]),
						const Divider(height: 24),
						const Text('Historial (últimos)') ,
						const SizedBox(height: 8),
						Expanded(
							child: _history.isEmpty
									? const Center(child: Text('No hay notificaciones enviadas'))
									: ListView.separated(
											itemBuilder: (context, idx) {
												final n = _history[idx];
												return ListTile(
													title: Text(n['title'] ?? '(sin título)'),
													subtitle: Text('${n['message'] ?? ''}\nAudience: ${n['audience'] ?? 'all'}'),
													isThreeLine: true,
													trailing: Text((n['createdAt'] ?? '').toString().split('.').first),
												);
											},
											separatorBuilder: (_, __) => const Divider(),
											itemCount: _history.length,
										),
						)
					],
				),
			),
		);
	}
}

