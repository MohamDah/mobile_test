// TODO(Person5): Implement fully.
import 'package:flutter/material.dart';

import '../../../domain/entities/gym_entity.dart';

class GymFormPage extends StatelessWidget {
  const GymFormPage({super.key, this.existingGym});
  final GymEntity? existingGym;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(existingGym == null ? 'Add Gym' : 'Edit Gym')),
      body: const Center(child: Text('Gym Form — TODO(Person5)')),
    );
  }
}
