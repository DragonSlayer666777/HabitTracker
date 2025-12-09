import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  int _selectedIconCodePoint = Icons.book.codePoint;
  DateTime? _reminderTime;
  bool _setReminder = false;

  void _selectIconPicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Pilih Icon', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: GridView.count(
            crossAxisCount: 5,
            children: [
              _iconButton(Icons.book, "Baca"),
              _iconButton(Icons.directions_run, "Lari"),
              _iconButton(Icons.fitness_center, "Gym"),
              _iconButton(Icons.water_drop, "Minum Air"),
              _iconButton(Icons.bedtime, "Tidur"),
              _iconButton(Icons.menu_book, "Belajar"),
              _iconButton(Icons.self_improvement, "Meditasi"),
              _iconButton(Icons.code, "Coding"),
              _iconButton(Icons.brush, "Gambar"),
              _iconButton(Icons.music_note, "Musik"),
              _iconButton(Icons.camera_alt, "Foto"),
              _iconButton(Icons.cleaning_services, "Bersih"),
              _iconButton(Icons.spa, "Relaks"),
              _iconButton(Icons.school, "Kuliah"),
              _iconButton(Icons.work, "Kerja"),
              _iconButton(Icons.coffee, "Ngopi"),
              _iconButton(Icons.restaurant, "Makan Sehat"),
              _iconButton(Icons.directions_walk, "Jalan Kaki"),
              _iconButton(Icons.sunny, "Bangun Pagi"),
              _iconButton(Icons.nights_stay, "Tidur Tepat Waktu"),
              // Tambah icon lain di sini kalau perlu
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        setState(() => _selectedIconCodePoint = icon.codePoint);
        Navigator.pop(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  void _selectTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() => _reminderTime = DateTime(0, 0, 0, time.hour, time.minute));
    } else {
      setState(() => _setReminder = false); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Habit'),
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                filled: true,
                fillColor: Colors.grey,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: Colors.grey,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(IconData(_selectedIconCodePoint, fontFamily: 'MaterialIcons')),
              label: const Text('Select Icon'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: _selectIconPicker,  // Fixed typo here!
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Set reminders', style: TextStyle(color: Colors.white)),
              value: _setReminder,
              onChanged: (val) {
                setState(() => _setReminder = val);
                if (val) _selectTime();
              },
              activeColor: Colors.redAccent,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty) return;
                    context.read<HabitProvider>().addHabit(
                      _nameController.text,
                      _descController.text,
                      _selectedIconCodePoint,
                      _setReminder ? _reminderTime : null,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}