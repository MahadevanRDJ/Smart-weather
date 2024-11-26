import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<StatefulWidget> createState() => _Sample();
}

class _Sample extends State<Sample> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Text Fields'),
        ),
        body: DynamicTextFields(),
      ),
    );
  }
}

class DynamicTextFields extends StatefulWidget {
  @override
  _DynamicTextFieldsState createState() => _DynamicTextFieldsState();
}

class _DynamicTextFieldsState extends State<DynamicTextFields> {
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focuses = [];
  TextEditingController firstController = TextEditingController();
  FocusNode firstFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  Color genderColor = Colors.black;
  int _fieldCount = 1; // Start with 5 fields

  String? selectedGender;
  String? selectedRace;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> races = ['White', 'Black or African American', 'Asian', 'Hispanic or Latino', 'Native American', 'Other'];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for the initial fields
    for (int i = 0; i < _fieldCount; i++) {
      _controllers.add(TextEditingController());
      _focuses.add(FocusNode());
    }
  }

  void _addField() {
    setState(() {
      _controllers.add(TextEditingController());
      _focuses.add(FocusNode());
      _fieldCount++;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers to free up resources
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: WillPopScope(
          onWillPop: () async {return true;},
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "First",
                            style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the corner radius
                            ),
                            child: TextField(
                              focusNode: firstFocus,
                              controller: firstController,
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 2.0, bottom: 9, right: 2),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {},
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Select Gender:', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: genderColor, width: 5),
                            shape: BoxShape.rectangle
                          ),
                          child: DropdownButton<String>(
                            focusColor: Colors.red,
                            focusNode: genderFocus,
                            value: selectedGender,
                            hint: Text('Choose Gender'),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGender = newValue;
                              });
                            },
                            items: genders.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  // Race Dropdown
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: _fieldCount,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Field ${index + 1}",
                                style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0), // Adjust the value to change the corner radius
                                ),
                                child: TextField(
                                  controller: _controllers[index],
                                  textInputAction: TextInputAction.next,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 2.0, bottom: 9, right: 2),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) {},
                                ),
                              ),
                            ),
                            Focus(
                              descendantsAreFocusable: false,
                              canRequestFocus: false,
                              child: SizedBox(
                                height: 45,
                                width: 50,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 5),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {

                                      });
                                    },
                                    child: Card(
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            5.0),
                                      ),
                                      color: Colors.redAccent,
                                      child: SizedBox(
                                        height: 38,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.blueGrey,
                                              borderRadius:
                                              BorderRadius
                                                  .all(Radius
                                                  .circular(
                                                  5))),
                                          margin: const EdgeInsets
                                              .all(4),
                                          child: Container(
                                            margin:
                                            const EdgeInsets
                                                .only(
                                                left: 5,
                                                right: 5,
                                                top: 5,
                                                bottom: 1),
                                            child:  Image.asset(
                                              "assets/images/add_icon.png",
                                              width: 20,
                                              height: 20,

                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addField,
                    child: Text('➕ Add Field'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Select Race:', style: TextStyle(fontSize: 16)),
                      DropdownButton<String>(
                        value: selectedRace,
                        hint: Text('Choose Race'),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRace = newValue;
                          });
                        },
                        items: races.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(

                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
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
