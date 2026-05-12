import 'package:agenda_nusantara/screens/settings/settings_screen.dart';
import 'package:agenda_nusantara/screens/task/add_task_important.dart';
import 'package:agenda_nusantara/screens/task/add_task_normal.dart';
import 'package:agenda_nusantara/screens/task/task_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/databases/db_helper.dart';
import '../../models/task.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _getCurrentDate() {
    final now = DateTime.now();

    return DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(now);
  }

  List<Task> tasks = [];

  int completedTask = 0;
  int pendingTask = 0;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final data = await DBHelper.instance.getAllTasks();

    final loadedTasks = data.map((e) => Task.fromMap(e)).toList();

    final done = loadedTasks.where((e) => e.isDone).length;

    setState(() {
      tasks = loadedTasks;
      completedTask = done;
      pendingTask = loadedTasks.length - done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A9E8F),
        elevation: 0,
        title: const Text(
          'Beranda',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            _buildGreetingSection(),
            const SizedBox(height: 16),

            // Stats Cards
            _buildStatsRow(),
            const SizedBox(height: 16),

            // Chart Card
            _buildChartCard(),
            const SizedBox(height: 16),

            // Action Buttons Grid
            _buildActionGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Halo, ${widget.user['name']}!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text('👋', style: TextStyle(fontSize: 22)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _getCurrentDate(),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'TUGAS SELESAI',
            value: completedTask.toString(),
            valueColor: const Color(0xFF3A9E8F),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'BELUM SELESAI',
            value: pendingTask.toString(),
            valueColor: const Color(0xFFE53935),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TUGAS SELESAI / HARI',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_chart_outlined,
                    size: 42,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Belum Ada Data Grafik',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final List<String> days = [
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min',
    ];

    List<double> data = List.filled(7, 0);

    for (var task in tasks) {
      if (task.isDone) {
        final date = DateTime.parse(task.date);

        final index = date.weekday - 1;

        data[index] += 1;
      }
    }

    double maxVal = 1;

    if (data.any((e) => e > 0)) {
      maxVal = data.reduce((a, b) => a > b ? a : b);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TUGAS SELESAI / HARI [BONUS]',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(data.length, (index) {
                final double barHeight = (data[index] / maxVal) * 80;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 28,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A9E8F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      days[index],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildActionButton(
          icon: Icons.add,
          label: 'Tambah Tugas Penting',
          iconBgColor: const Color(0xFFE53935),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTaskImportant(),
              ),
            );
            loadTasks();

            // optional: ambil data yang dikirim balik
            if (result != null) {
              debugPrint('Data dari halaman tambah tugas: $result');
            }
          },
        ),
        _buildActionButton(
          icon: Icons.add,
          label: 'Tambah Tugas Biasa',
          iconBgColor: const Color(0xFF43A047),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTaskNormal(),
              ),
            );
            loadTasks();

            // optional: ambil data yang dikirim balik
            if (result != null) {
              debugPrint('Data dari halaman tambah tugas: $result');
            }
          },
        ),
        _buildActionButton(
          icon: Icons.list_alt,
          label: 'Daftar Tugas',
          iconBgColor: const Color(0xFF1E88E5),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaskListScreen(),
              ),
            );

            loadTasks();
          },
        ),
        _buildActionButton(
          icon: Icons.settings,
          label: 'Pengaturan',
          iconBgColor: const Color.fromARGB(82, 71, 82, 88),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(
                  user: widget.user,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
