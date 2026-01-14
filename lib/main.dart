import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/theme/app_theme.dart';
import 'src/services/local_storage_service.dart';
import 'src/screens/member_form_screen.dart';
import 'src/screens/diagnostic_form_screen.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<LocalStorageService> _initStorage() async {
    final storage = LocalStorageService();
    await storage.init();
    return storage;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalStorageService>(
      future: _initStorage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Careline',
            theme: AppTheme.light(),
            home: MyHomePage(
              title: 'Careline - Diagnostic Platform',
              storageService: snapshot.data!,
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        }
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.storageService,
  });

  final String title;
  final LocalStorageService storageService;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> _members = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() {
    setState(() {
      _members = widget.storageService.getAllMembers();
    });
  }

  void _navigateToMemberForm({dynamic member}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberFormScreen(
          storageService: widget.storageService,
          existingMember: member,
        ),
      ),
    );
    if (result != null) {
      _loadMembers();
    }
  }

  void _navigateToDiagnosticForm(dynamic member) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiagnosticFormScreen(
          storageService: widget.storageService,
          member: member,
        ),
      ),
    );
    if (result != null) {
      _loadMembers();
    }
  }

  void _deleteMember(String memberId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text(
          'Are you sure you want to delete this member? All associated diagnostic records will also be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await widget.storageService.deleteMemberRecords(memberId);
              await widget.storageService.deleteMember(memberId);
              if (mounted) {
                Navigator.pop(context);
                _loadMembers();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Member deleted successfully')),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: _members.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No members added yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a new member to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        member.firstName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text('${member.firstName} ${member.lastName}'),
                    subtitle: Text(member.email),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Edit'),
                          onTap: () => _navigateToMemberForm(member: member),
                        ),
                        PopupMenuItem(
                          child: const Text('Add Diagnostic'),
                          onTap: () => _navigateToDiagnosticForm(member),
                        ),
                        PopupMenuItem(
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () => _deleteMember(member.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMemberForm(),
        tooltip: 'Add Member',
        child: const Icon(Icons.add),
      ),
    );
  }
}
