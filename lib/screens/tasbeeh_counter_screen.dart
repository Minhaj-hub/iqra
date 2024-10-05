// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:vibration/vibration.dart';

// class TasbeehCounterScreen extends StatefulWidget {
//   @override
//   _TasbeehCounterScreenState createState() => _TasbeehCounterScreenState();
// }

// class _TasbeehCounterScreenState extends State<TasbeehCounterScreen> {
//   int _count = 0;
//   int _target = 0;
//   bool _isSoundOn = false;
//   bool _isVibrateOn = false;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final TextEditingController _customTargetController = TextEditingController();

//   void _selectTarget() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Target Count'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 _buildTargetOption(33),
//                 _buildTargetOption(100),
//                 _buildTargetOption(1000),
//                 _buildCustomTargetOption(),
//                 _buildResetTargetOption(),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Done'),
//               onPressed: () {
//                 setState(() {
//                   _target = int.tryParse(_customTargetController.text) ?? _target;
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTargetOption(int value) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _target = value;
//           _customTargetController.clear();
//         });
//         Navigator.of(context).pop();
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           '$value ✨',
//           style: TextStyle(fontSize: 20, color: _target == value ? Colors.blue : Colors.black),
//         ),
//       ),
//     );
//   }

//   Widget _buildCustomTargetOption() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: _customTargetController,
//         keyboardType: TextInputType.number,
//         decoration: const InputDecoration(
//           labelText: 'Custom 🎯',
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   Widget _buildResetTargetOption() {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _target = 0;
//           _customTargetController.clear();
//         });
//         Navigator.of(context).pop();
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           'Reset Target 🔄',
//           style: TextStyle(fontSize: 20, color: Colors.red),
//         ),
//       ),
//     );
//   }

//   void _resetCount() {
//     setState(() {
//       _count = 0;
//     });
//   }

//   void _toggleSound() {
//     setState(() {
//       _isSoundOn = !_isSoundOn;
//     });
//   }

//   void _toggleVibrate() {
//     setState(() {
//       _isVibrateOn = !_isVibrateOn;
//     });
//   }

//   void _incrementCount() {
//     setState(() {
//       _count++;
//       if (_target > 0 && _count >= _target) {
//         if (_isSoundOn) {
//           _playSound();
//         }
//         if (_isVibrateOn) {
//           _vibrate();
//         }
//       }
//     });
//   }

//   void _playSound() async {
//     if (_target > 0) {
//       await _audioPlayer.play(AssetSource('sound/notification.mp3'));
//     }
//   }

//   void _vibrate() {
//     if (Vibration.hasVibrator() != null) {
//       Vibration.vibrate();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tasbih Counter'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.filter_1, color: Colors.teal),
//                   onPressed: _selectTarget,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.refresh, color: Colors.teal),
//                   onPressed: _resetCount,
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     _isSoundOn ? Icons.volume_up : Icons.volume_off,
//                     color: _isSoundOn ? Colors.teal : Colors.grey,
//                   ),
//                   onPressed: _toggleSound,
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     _isVibrateOn ? Icons.vibration : Icons.notifications_off,
//                     color: _isVibrateOn ? Colors.teal : Colors.grey,
//                   ),
//                   onPressed: _toggleVibrate,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'TARGET',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               '$_target 🎯',
//               style: const TextStyle(fontSize: 40, color: Colors.teal),
//             ),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: _incrementCount,
//               child: Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.teal, width: 4),
//                   gradient: const LinearGradient(
//                     colors: [Colors.tealAccent, Colors.teal],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Tap here 🛎️',
//                     style: TextStyle(fontSize: 24, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'COUNT',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               '$_count ✨',
//               style: const TextStyle(fontSize: 40, color: Colors.teal),
//             ),
//             const SizedBox(height: 20),

//             // Text Container Implementation
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     spreadRadius: 5,
//                   ),
//                 ],
//               ),
//               child: const Text(
//                 'Hamare nabi Muhammad ﷺ ne farmaya ki "ungliyon se tasbih ginana afzal hai. Ungliyon se ginti qayamat ke din gawahi denge." Agar koi tasbih ke dane ya tasbih counter se ginti kare, toh yeh bhi jaiz hai. Sahaba Kiram bhi kabhi kabhi khajoor ke danon ya patthron se gina karte the.',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black87,
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.justify,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
