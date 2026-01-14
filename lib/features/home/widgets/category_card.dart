import 'package:flutter/material.dart';
import '../../../data/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withOpacity(0.3),
                category.color.withOpacity(0.1),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),  // ← Reduced from 20
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),  // ← Reduced from 12
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 28,  // ← Reduced from 32
                  ),
                ),
                const Spacer(),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 18,  // ← Reduced from 20
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,  // ← Added
                  overflow: TextOverflow.ellipsis,  // ← Added
                ),
                const SizedBox(height: 4),
                Text(
                  category.description,
                  style: TextStyle(
                    fontSize: 12,  // ← Reduced from 14
                    color: Colors.grey[400],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),  // ← Reduced from 8
                Row(
                  children: [
                    Icon(
                      Icons.music_note,
                      size: 14,  // ← Reduced from 16
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${category.sounds.length} sounds',
                      style: TextStyle(
                        fontSize: 11,  // ← Reduced from 12
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}