import 'package:flutter/material.dart';
import 'package:app_fitoterappia/models/Card_memory_item.dart';

class MemoryCard extends StatelessWidget {
  final CardMemoryItem cardItem;
  final Function(int) onCardPressed;
  final int index;
  const MemoryCard({
    Key? key,
    required this.cardItem,
    required this.index,
    required this.onCardPressed,
  }) :super(key:key);

  void handleCardTap(){
    if(cardItem.state == CardState.hidden){
      onCardPressed(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:handleCardTap,
      child: Card(
        margin: const EdgeInsets.all(4),
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: cardItem.state == CardState.visible ||
              cardItem.state == CardState.guessed
            ? cardItem.color
            : Colors.grey,
        child:Center(
          child: cardItem.state == CardState.hidden
                ? null
                : LayoutBuilder(builder:(context, constrains){
                    return Icon(
                      cardItem.icon,
                      size: constrains.biggest.height + 0.8,
                      color: Colors.white,
                    );
                  }),
        ),
      ),
    );
  }
}