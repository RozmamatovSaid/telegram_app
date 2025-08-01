import 'package:flutter/material.dart';

class EditableField extends StatefulWidget {
  final String label;
  final String value;
  final String hintText;
  final Color? valueColor;
  final TextInputType? keyboardType;
  final Function(String) onSave;
  final bool canEdit;
  final bool enabled;

  const EditableField({
    super.key,
    required this.label,
    required this.value,
    required this.hintText,
    required this.onSave,
    this.valueColor,
    this.keyboardType,
    this.canEdit = true,
    this.enabled = true,
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
  void didUpdateWidget(EditableField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final trimmedValue = _controller.text.trim();
    if (trimmedValue.isEmpty && widget.label != 'Familiya') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.label} bo\'sh bo\'lishi mumkin emas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSave(trimmedValue);
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
              if (widget.canEdit && !_isEditing && widget.enabled)
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
              enabled: widget.enabled,
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
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white12),
                ),
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.white54),
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.enabled ? _save : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.grey[700],
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
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                    ),
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
