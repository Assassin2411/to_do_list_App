import 'package:flutter/material.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/main.dart';

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({
    super.key,
    required this.buttonName,
    required this.docId,
    required this.heading,
    required this.body,
  });

  final String buttonName;
  final String docId;
  final String heading;
  final String body;

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  String userId = firebaseAuth.currentUser!.uid;
  TextEditingController? _headingTextController;
  TextEditingController? _bodyTextController;

  @override
  void initState() {
    _bodyTextController = TextEditingController();
    _headingTextController = TextEditingController();

    if (widget.buttonName == 'Update') {
      _headingTextController!.text = widget.heading;
      _bodyTextController!.text = widget.body;
    }

    super.initState();
  }

  void _saveToDo() async {
    await fireStore.collection('users').doc(userId).collection('todos').add({
      'heading': _headingTextController?.text,
      'body': _bodyTextController?.text,
      'time': DateTime.now(),
    });
    _headingTextController?.clear();
    _bodyTextController?.clear();
    Navigator.pop(context);
  }

  void _updateToDo() async {
    print('update ToDO');
    await fireStore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(widget.docId)
        .update({
      'heading': _headingTextController!.text,
      'body': _bodyTextController!.text,
    });
    _headingTextController?.clear();
    _bodyTextController?.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          TextField(
            maxLines: 1,
            decoration: kTextFieldInputDecoration(context, 'Heading', 'Heading')
                .copyWith(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).canvasColor,
                  width: 1.0, // Specify the border width here
                ),
              ),
            ),
            style: TextStyle(color: Theme.of(context).canvasColor),
            controller: _headingTextController,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _bodyTextController,
            maxLines: 16,
            style: TextStyle(color: Theme.of(context).canvasColor),
            decoration: InputDecoration(
              hintText: 'Start Typing...',
              hintStyle: const TextStyle(color: Color(0xff6a7a94)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Theme.of(context).canvasColor,
                  width: 1.0, // Specify the border width here
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: widget.buttonName == 'Save' ? _saveToDo : _updateToDo,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff334e6a),
              fixedSize: Size(screenWidth - 30, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              widget.buttonName,
              style: kButtonTextStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}
