import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final Function onDelete;
  final Function onTap;
  final List<Color> noteColors;

  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onTap,
    required this.noteColors,
  });

  @override
  Widget build(BuildContext context) {
    final colorIndex = note['color'] as int;
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: noteColors[colorIndex],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note['date'],
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            SizedBox(height: 8),
            Text(
              note['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Expanded(
              child: Text(
                note['description'],
                style: TextStyle(color: Colors.black54, height: 1.5),
                overflow: TextOverflow.fade,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => onDelete(),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.black54,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
