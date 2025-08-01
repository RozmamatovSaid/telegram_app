import 'package:flutter/material.dart';

class MultiFieldEditable extends StatefulWidget {
  final String label;
  final List<String> values;
  final List<String> hintTexts;
  final Function(List<String>) onSave;
  final String? Function(List<String>)? validator;

  const MultiFieldEditable({
    super.key,
    required this.label,
    required this.values,
    required this.hintTexts,
    required this.onSave,
    this.validator,
  });

  @override
  State<MultiFieldEditable> createState() => _MultiFieldEditableState();
}

class _MultiFieldEditableState extends State<MultiFieldEditable> {
  late List<TextEditingController> _controllers;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controllers = widget.values
        .map((value) => TextEditingController(text: value))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _save() {
    final values = _controllers.map((c) => c.text.trim()).toList();
    final error = widget.validator?.call(values);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    widget.onSave(values);
    setState(() => _isEditing = false);
  }

  void _cancel() {
    setState(() {
      _isEditing = false;
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].text = widget.values[i];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              GestureDetector(
                onTap: () => setState(() => _isEditing = !_isEditing),
                child: Icon(
                  _isEditing ? Icons.close : Icons.edit,
                  color: const Color(0xFF007AFF),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isEditing) ...[
            for (int i = 0; i < _controllers.length; i++) ...[
              TextField(
                controller: _controllers[i],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: widget.hintTexts[i],
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF007AFF)),
                  ),
                ),
              ),
              if (i < _controllers.length - 1) const SizedBox(height: 8),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                    ),
                    child: const Text('Saqlash'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancel,
                    child: const Text(
                      'Bekor qilish',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              widget.values.join(' ').trim().isEmpty
                  ? '${widget.label} kiritilmagan'
                  : widget.values.join(' ').trim(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}
