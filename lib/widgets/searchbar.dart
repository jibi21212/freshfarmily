import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// TODO implement search bar
/// The search and filter bar widget.
class SearchFilterBar extends StatefulWidget {
  final Function(String) onSearch;
  final List<FilterOption> filterOptions;
  final VoidCallback onFilterApplied;

  const SearchFilterBar({
    Key? key,
    required this.onSearch,
    required this.filterOptions,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        filterOptions: widget.filterOptions,
        onApply: () {
          widget.onFilterApplied();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search input field with filter button.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: widget.onSearch,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Model for a filter option.
class FilterOption {
  final String name;
  final FilterType type;
  final List<String>? options; // For dropdown or multi-select filters.
  double? minValue; // For range inputs.
  double? maxValue;
  List<String>? selectedOptions; // For multi-select or dropdown.

  FilterOption({
    required this.name,
    required this.type,
    this.options,
    this.minValue,
    this.maxValue,
    this.selectedOptions,
  });
}

/// Enum defining the filter types.
enum FilterType {
  range,
  dropdown,
  multiSelect,
}

/// A dialog widget that displays filter options.
class FilterDialog extends StatefulWidget {
  final List<FilterOption> filterOptions;
  final VoidCallback onApply;

  const FilterDialog({
    Key? key,
    required this.filterOptions,
    required this.onApply,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Options'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.filterOptions.map((option) {
            switch (option.type) {
              case FilterType.range:
                return RangeFilterWidget(option: option);
              case FilterType.dropdown:
                return DropdownFilterWidget(option: option);
              case FilterType.multiSelect:
                return MultiSelectFilterWidget(option: option);
            }
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Reset all filter options.
            for (var option in widget.filterOptions) {
              if (option.type == FilterType.range) {
                option.minValue = null;
                option.maxValue = null;
              } else {
                option.selectedOptions = [];
              }
            }
            setState(() {}); // Rebuild to reflect cleared values.
            widget.onApply();
            Navigator.pop(context);
          },
          child: const Text('Clear'),
        ),
        ElevatedButton(
          onPressed: widget.onApply,
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

/// A widget to filter by a numeric range.
class RangeFilterWidget extends StatefulWidget {
  final FilterOption option;

  const RangeFilterWidget({Key? key, required this.option}) : super(key: key);

  @override
  State<RangeFilterWidget> createState() => _RangeFilterWidgetState();
}

class _RangeFilterWidgetState extends State<RangeFilterWidget> {
  late TextEditingController _minController;
  late TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: widget.option.minValue?.toString() ?? '',
    );
    _maxController = TextEditingController(
      text: widget.option.maxValue?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant RangeFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if the option values have been cleared externally.
    _minController.text = widget.option.minValue?.toString() ?? '';
    _maxController.text = widget.option.maxValue?.toString() ?? '';
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.option.name),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minController,
                decoration: InputDecoration(
                  hintText: 'Min ${widget.option.name}',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  widget.option.minValue = double.tryParse(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _maxController,
                decoration: InputDecoration(
                  hintText: 'Max ${widget.option.name}',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  widget.option.maxValue = double.tryParse(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A widget for dropdown filter options.
class DropdownFilterWidget extends StatefulWidget {
  final FilterOption option;

  const DropdownFilterWidget({Key? key, required this.option}) : super(key: key);

  @override
  State<DropdownFilterWidget> createState() => _DropdownFilterWidgetState();
}

class _DropdownFilterWidgetState extends State<DropdownFilterWidget> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    if (widget.option.selectedOptions != null &&
        widget.option.selectedOptions!.isNotEmpty) {
      _selectedOption = widget.option.selectedOptions!.first;
    }
  }

  @override
  void didUpdateWidget(covariant DropdownFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.option.selectedOptions != null &&
        widget.option.selectedOptions!.isNotEmpty) {
      _selectedOption = widget.option.selectedOptions!.first;
    } else {
      _selectedOption = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.option.name),
        DropdownButton<String>(
          value: _selectedOption,
          hint: Text('Select ${widget.option.name}'),
          items: widget.option.options?.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
              widget.option.selectedOptions = value != null ? [value] : [];
            });
          },
        ),
      ],
    );
  }
}

/// A widget for multi-select filter options.
class MultiSelectFilterWidget extends StatefulWidget {
  final FilterOption option;

  const MultiSelectFilterWidget({Key? key, required this.option})
      : super(key: key);

  @override
  _MultiSelectFilterWidgetState createState() =>
      _MultiSelectFilterWidgetState();
}

class _MultiSelectFilterWidgetState extends State<MultiSelectFilterWidget> {
  late List<String> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = widget.option.selectedOptions != null
        ? List.from(widget.option.selectedOptions!)
        : [];
  }

  @override
  void didUpdateWidget(covariant MultiSelectFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedOptions = widget.option.selectedOptions != null
        ? List.from(widget.option.selectedOptions!)
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.option.name),
        Wrap(
          spacing: 8.0,
          children: widget.option.options?.map((option) {
                final isSelected = _selectedOptions.contains(option);
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedOptions.add(option);
                      } else {
                        _selectedOptions.remove(option);
                      }
                      widget.option.selectedOptions = _selectedOptions;
                    });
                  },
                );
              }).toList() ??
              [],
        ),
      ],
    );
  }
}
