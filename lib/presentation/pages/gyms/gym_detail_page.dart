// TODO(Person3): Implement fully.
import 'package:flutter/material.dart';

import '../../../domain/entities/gym_entity.dart';

class GymDetailPage extends StatelessWidget {
  const GymDetailPage({super.key, required this.gym});
  final GymEntity gym;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gym.name)),
      body: const Center(child: Text('Gym Detail — TODO(Person3)')),
    );
  }
}
