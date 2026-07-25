import 'package:flutter/material.dart';

class FlexibleCollectionView<T> extends StatelessWidget
{
    final List<T> _items;
    final ScrollController _scrollController;
    final Widget Function(T item) _itemBuilder;
    final double _gridAspectRatio;
    final int _gridCrossAxisCount;

    const FlexibleCollectionView({
        super.key,
        required this._items,
        required this._scrollController,
        required this._itemBuilder,
        this._gridAspectRatio = 1.8,
        this._gridCrossAxisCount = 2,
    });

    @override
    Widget build(BuildContext context)
    {
        final esTableta = MediaQuery.of(context).size.width > 600;

        if (esTableta)
        {
            return GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridCrossAxisCount,
                    childAspectRatio: _gridAspectRatio,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) => _itemBuilder(_items[index]),
            );
        }

        return ListView.builder(
            controller: _scrollController,
            itemCount: _items.length,
            itemBuilder: (context, index) => _itemBuilder(_items[index]),
        );
    }
}