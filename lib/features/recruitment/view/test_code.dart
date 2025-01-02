import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // Controllers for Local Address
  final TextEditingController localAddressController = TextEditingController();

  // Controllers for Permanent Address
  final TextEditingController permanentAddressController = TextEditingController();

  // Checkbox state
  bool isPermanentSameAsLocal = false;

  // Tracks whether the checkbox was previously checked
  bool wasCheckboxPreviouslyChecked = false;

  @override
  void dispose() {
    // Dispose controllers to free resources
    localAddressController.dispose();
    permanentAddressController.dispose();
    super.dispose();
  }

  void _updatePermanentAddress() {
    if (isPermanentSameAsLocal) {
      // Update only if the checkbox is checked again
      permanentAddressController.text = localAddressController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: const Text(
          'Recruitment Step 2',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Local Address Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: const Text(
                    'Local Address Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  collapsedTextColor: Colors.black,
                  textColor: Colors.black,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: localAddressController,
                        decoration: InputDecoration(
                          labelText: 'Address Line 1',
                          hintText: 'Enter your address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Permanent Address Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: const Text(
                    'Permanent Address Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  collapsedTextColor: Colors.black,
                  textColor: Colors.black,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isPermanentSameAsLocal,
                                onChanged: (value) {
                                  setState(() {
                                    isPermanentSameAsLocal = value!;

                                    if (isPermanentSameAsLocal) {
                                      // Update permanent address if the checkbox was just checked
                                      if (!wasCheckboxPreviouslyChecked) {
                                        permanentAddressController.text = localAddressController.text;
                                      }
                                    }
                                    // Track the checkboxes previous state
                                    wasCheckboxPreviouslyChecked = isPermanentSameAsLocal;
                                  });
                                },
                              ),
                              const Text(
                                'Permanent Address same as above',
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: permanentAddressController,
                            decoration: InputDecoration(
                              labelText: 'Address Line 1',
                              hintText: 'Enter your address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            enabled: !isPermanentSameAsLocal, // Enable/Disable based on checkbox
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
