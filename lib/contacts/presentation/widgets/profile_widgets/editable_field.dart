import 'package:flutter/material.dart';
class EditableField extends StatefulWidget {
  final String label;
  final String value;
  final String hintText;
  final Color? valueColor;
  final TextInputType? keyboardType;
  final Function(String) onSave;
  final bool canEdit;

  const EditableField({
    super.key,
    required this.label,
    required this.value,
    required this.hintText,
    required this.onSave,
    this.valueColor,
    this.keyboardType,
    this.canEdit = true,
  });

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(_controller.text.trim());
    setState(() => _isEditing = false);
  }

  void _cancel() {
    setState(() {
      _isEditing = false;
      _controller.text = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              if (widget.canEdit && !_isEditing)
                GestureDetector(
                  onTap: () => setState(() => _isEditing = true),
                  child: const Icon(Icons.edit, color: Colors.blue, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isEditing) ...[
            TextField(
              controller: _controller,
              style: TextStyle(
                color: widget.valueColor ?? Colors.white,
                fontSize: 16,
              ),
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Saqlash',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancel,
                    child: const Text(
                      'Bekor',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              widget.value.isEmpty ? '${widget.label} yoq' : widget.value,
              style: TextStyle(
                color: widget.valueColor ?? Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
