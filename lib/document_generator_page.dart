// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentGeneratorPage extends StatefulWidget {
  const DocumentGeneratorPage({super.key});

  @override
  _DocumentGeneratorPageState createState() => _DocumentGeneratorPageState();
}

class _DocumentGeneratorPageState extends State<DocumentGeneratorPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  String? selectedDocumentType;
  String? selectedDepartmentCode;

  final TextEditingController _yearController = TextEditingController();

  String? generatedCode;

  final List<String> documentTypes = ['NOT', 'REP', 'LET', 'CON'];
  final List<String> departmentCodes = ['MGT', 'IT', 'HR', 'FIN'];

  Future<void> generateDocumentCode() async {
    final year = int.tryParse(_yearController.text);

    if (selectedDocumentType == null || selectedDepartmentCode == null || year == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      final response = await supabase
          .from('documents')
          .select('sequence_number')
          .eq('document_type', selectedDocumentType!)
          .eq('department_code', selectedDepartmentCode!)
          .eq('year', year)
          .order('sequence_number', ascending: false)
          .limit(1)
          .maybeSingle();

      final lastSequenceNumber = response != null ? response['sequence_number'] as int : 0;
      final newSequenceNumber = lastSequenceNumber + 1;

      final fullDocumentCode =
          'Az-$selectedDocumentType-$selectedDepartmentCode-$year-${newSequenceNumber.toString().padLeft(3, '0')}';

      final insertResponse = await supabase.from('documents').insert({
        'document_type': selectedDocumentType,
        'department_code': selectedDepartmentCode,
        'year': year,
        'sequence_number': newSequenceNumber,
        'full_document_code': fullDocumentCode,
      }).select();

      if (insertResponse.isEmpty) {
        throw Exception('Failed to insert document.');
      }

      setState(() {
        generatedCode = fullDocumentCode;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document inserted successfully!')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Generator')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Document Type', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    autofocus: true,
                    isExpanded: true,
                    icon: const Icon(Icons.expand_more_outlined),
                    value: selectedDocumentType,
                    hint: const Text('Select Document Type'),
                    items: documentTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDocumentType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Department Code', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    autofocus: true,
                    isExpanded: true,
                    icon: const Icon(Icons.expand_more_outlined),
                    value: selectedDepartmentCode,
                    hint: const Text('Select Department Code'),
                    items: departmentCodes.map((code) {
                      return DropdownMenuItem<String>(
                        value: code,
                        child: Text(code),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDepartmentCode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _yearController,
                    decoration: const InputDecoration(labelText: 'Year'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 50), // ارتفاع دکمه 50 پیکسل
                      padding: const EdgeInsets.symmetric(vertical: 16), // فضای داخلی عمودی
                    ),
                    onPressed: generateDocumentCode,
                    child: const Text('Generate Document Code'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
