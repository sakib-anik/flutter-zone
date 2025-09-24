import 'package:flutter/material.dart';
import 'package:notes_app/database/notes_database.dart';
import 'package:notes_app/screens/note_card.dart';
import 'package:notes_app/screens/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDatabase.instance.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    const Color(0xFFF3E5F5), // Light Purple
    const Color(0xFFE1BEE7), // Lavender
    const Color(0xFFD1C4E9), // Light Indigo
    const Color(0xFFC5CAE9), // Periwinkle
    const Color(0xFFBBDEFB), // Light Blue
    const Color(0xFFB3E5FC), // Sky Blue
    const Color(0xFFB2EBF2), // Aqua
    const Color(0xFFB2DFDB), // Teal
    const Color(0xFFC8E6C9), // Mint Green
    const Color(0xFFDCEDC8), // Light Green
    const Color(0xFFF0F4C3), // Lime
    const Color(0xFFFFF9C4), // Light Yellow
    const Color(0xFFFFECB3), // Light Amber
    const Color(0xFFFFCCBC), // Peach
    const Color(0xFFFFCDD2), // Light Pink
  ];

  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NoteDialog(
          colorIndex: colorIndex,
          noteColors: noteColors,
          onNoteSaved:
              (
                newTitle,
                newDescription,
                selectedColorIndex,
                currentDate,
              ) async {
                if (id == null) {
                  await NotesDatabase.instance.addNote(
                    newTitle,
                    newDescription,
                    currentDate,
                    selectedColorIndex,
                  );
                } else {
                  await NotesDatabase.instance.updateNote(
                    newTitle,
                    newDescription,
                    currentDate,
                    selectedColorIndex,
                    id,
                  );
                }
                fetchNotes();
              },
          noteId: id,
          title: title,
          content: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notes_outlined, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 20),
                  Text(
                    'No Notes Found',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return NoteCard(
                    note: note,
                    onDelete: () async {
                      await NotesDatabase.instance.deleteNote(note['id']);
                      fetchNotes();
                    },
                    onTap: () {
                      showNoteDialog(
                        id: note['id'],
                        title: note['title'],
                        content: note['description'],
                        colorIndex: note['color'],
                      );
                    },
                    noteColors: noteColors,
                  );
                },
              ),
            ),
    );
  }
}
