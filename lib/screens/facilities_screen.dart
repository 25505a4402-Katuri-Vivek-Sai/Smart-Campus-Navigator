import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _brandBlue = Color(0xFF2F80ED);
const _facilityTypes = <String>[
  'Classroom',
  'Laboratory',
  'Library',
  'Office',
  'Cafeteria',
  'Auditorium',
  'Sports Facility',
  'Other',
];

class CampusFacility {
  const CampusFacility({
    required this.id,
    required this.name,
    required this.type,
    required this.building,
    required this.floor,
    required this.description,
  });

  final String id;
  final String name;
  final String type;
  final String building;
  final String floor;
  final String description;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'building': building,
        'floor': floor,
        'description': description,
      };

  factory CampusFacility.fromJson(Map<String, dynamic> json) => CampusFacility(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        building: json['building'] as String,
        floor: json['floor'] as String,
        description: (json['description'] as String?) ?? '',
      );
}

/// Facility records are stored by shared_preferences. On Flutter Web this uses
/// browser local storage, persisting on refresh in the same browser and origin.
class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  static const _storageKey = 'smart_campus_facilities_v1';
  List<CampusFacility> _facilities = [];
  bool _loading = true;
  String? _loadError;
  String _search = '';
  String _filterType = 'All';

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      final loaded = <CampusFacility>[];
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map) {
              try {
                loaded.add(CampusFacility.fromJson(Map<String, dynamic>.from(item)));
              } catch (_) {
                // Ignore malformed individual records rather than crashing the page.
              }
            }
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _facilities = loaded;
        _loading = false;
        _loadError = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Browser storage could not be read. Check browser privacy settings and reload.';
      });
    }
  }

  Future<bool> _saveFacilities(List<CampusFacility> records) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = await prefs.setString(
        _storageKey,
        jsonEncode(records.map((facility) => facility.toJson()).toList()),
      );
      if (!saved) throw StateError('Storage returned false');
      if (!mounted) return true;
      setState(() {
        _facilities = records;
        _loadError = null;
      });
      return true;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save. Browser storage may be disabled or full.')),
        );
      }
      return false;
    }
  }

  List<CampusFacility> get _visibleFacilities {
    final query = _search.trim().toLowerCase();
    return _facilities.where((facility) {
      final matchesType = _filterType == 'All' || facility.type == _filterType;
      final text = '${facility.name} ${facility.type} ${facility.building} ${facility.floor} ${facility.description}'.toLowerCase();
      return matchesType && (query.isEmpty || text.contains(query));
    }).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<void> _openEditor({CampusFacility? facility}) async {
    final result = await showDialog<CampusFacility>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _FacilityEditor(facility: facility),
    );
    if (result == null) return;
    final updated = [..._facilities];
    final index = updated.indexWhere((item) => item.id == result.id);
    if (index >= 0) {
      updated[index] = result;
    } else {
      updated.add(result);
    }
    if (await _saveFacilities(updated) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(index >= 0 ? 'Facility updated.' : 'Facility added.')),
      );
    }
  }

  Future<void> _confirmDelete(CampusFacility facility) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove facility?'),
        content: Text('“${facility.name}” will be removed from this browser’s saved records.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final updated = _facilities.where((item) => item.id != facility.id).toList();
    if (await _saveFacilities(updated) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Facility removed.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleFacilities;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text('Campus Facilities', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _brandBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Reload saved records',
            onPressed: _loadFacilities,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        backgroundColor: _brandBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add facility'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Manage campus locations', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Create, find, update and remove rooms and facilities.', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _SummaryTile(label: 'Saved facilities', value: '${_facilities.length}', icon: Icons.apartment_rounded),
                      _SummaryTile(label: 'Types available', value: '${_facilities.map((f) => f.type).toSet().length}', icon: Icons.category_rounded),
                    ],
                  ),
                  const SizedBox(height: 18),
                  LayoutBuilder(builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 560;
                    final search = TextField(
                      onChanged: (value) => setState(() => _search = value),
                      decoration: InputDecoration(
                        hintText: 'Search name, building or type',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    );
                    final filter = DropdownButtonFormField<String>(
                      value: _filterType,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Facility type',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                      items: ['All', ..._facilityTypes]
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) => setState(() => _filterType = value ?? 'All'),
                    );
                    if (narrow) {
                      return Column(children: [search, const SizedBox(height: 10), filter]);
                    }
                    return Row(children: [Expanded(flex: 3, child: search), const SizedBox(width: 12), Expanded(flex: 2, child: filter)]);
                  }),
                  const SizedBox(height: 14),
                  if (_loadError != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                      child: Text(_loadError!, style: TextStyle(color: Colors.orange.shade900)),
                    ),
                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : visible.isEmpty
                            ? _EmptyState(hasAnyRecords: _facilities.isNotEmpty, onAdd: () => _openEditor())
                            : LayoutBuilder(builder: (context, constraints) {
                                final columns = constraints.maxWidth >= 850 ? 3 : constraints.maxWidth >= 560 ? 2 : 1;
                                if (columns == 1) {
                                  return ListView.separated(
                                    padding: const EdgeInsets.only(bottom: 90),
                                    itemCount: visible.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                                    itemBuilder: (context, index) => _FacilityCard(
                                      facility: visible[index],
                                      onEdit: () => _openEditor(facility: visible[index]),
                                      onDelete: () => _confirmDelete(visible[index]),
                                    ),
                                  );
                                }
                                return GridView.builder(
                                  padding: const EdgeInsets.only(bottom: 90),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    mainAxisExtent: 205,
                                  ),
                                  itemCount: visible.length,
                                  itemBuilder: (context, index) => _FacilityCard(
                                    facility: visible[index],
                                    onEdit: () => _openEditor(facility: visible[index]),
                                    onDelete: () => _confirmDelete(visible[index]),
                                  ),
                                );
                              }),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4, top: 8),
                    child: Text(
                      'Storage: this browser and website only. Records do not sync across users or devices.',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
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

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(backgroundColor: _brandBlue.withOpacity(.1), child: Icon(icon, color: _brandBlue)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ]),
        ]),
      );
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.facility, required this.onEdit, required this.onDelete});
  final CampusFacility facility;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  IconData get _icon {
    switch (facility.type) {
      case 'Classroom': return Icons.meeting_room_rounded;
      case 'Laboratory': return Icons.science_rounded;
      case 'Library': return Icons.local_library_rounded;
      case 'Office': return Icons.business_rounded;
      case 'Cafeteria': return Icons.restaurant_rounded;
      case 'Auditorium': return Icons.theater_comedy_rounded;
      case 'Sports Facility': return Icons.sports_basketball_rounded;
      default: return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(backgroundColor: _brandBlue.withOpacity(.1), child: Icon(_icon, color: _brandBlue)),
              const SizedBox(width: 10),
              Expanded(child: Text(facility.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              PopupMenuButton<String>(
                tooltip: 'Facility actions',
                onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('Edit'))),
                  PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete_outline), title: Text('Remove'))),
                ],
              ),
            ]),
            const SizedBox(height: 10),
            Align(alignment: Alignment.centerLeft, child: Chip(label: Text(facility.type), visualDensity: VisualDensity.compact)),
            const SizedBox(height: 4),
            Text('${facility.building} • ${facility.floor}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade800)),
            if (facility.description.isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(facility.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ]),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasAnyRecords, required this.onAdd});
  final bool hasAnyRecords;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(hasAnyRecords ? Icons.search_off_rounded : Icons.apartment_rounded, size: 54, color: Colors.blueGrey.shade200),
            const SizedBox(height: 12),
            Text(hasAnyRecords ? 'No matching facilities' : 'No facilities yet', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(hasAnyRecords ? 'Try another search or facility type.' : 'Add a classroom, lab, library or other campus location.', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            if (!hasAnyRecords) FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Add first facility')),
          ]),
        ),
      );
}

class _FacilityEditor extends StatefulWidget {
  const _FacilityEditor({this.facility});
  final CampusFacility? facility;

  @override
  State<_FacilityEditor> createState() => _FacilityEditorState();
}

class _FacilityEditorState extends State<_FacilityEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _building;
  late final TextEditingController _floor;
  late final TextEditingController _description;
  late String _type;

  @override
  void initState() {
    super.initState();
    final facility = widget.facility;
    _name = TextEditingController(text: facility?.name ?? '');
    _building = TextEditingController(text: facility?.building ?? '');
    _floor = TextEditingController(text: facility?.floor ?? '');
    _description = TextEditingController(text: facility?.description ?? '');
    _type = facility?.type ?? _facilityTypes.first;
    if (!_facilityTypes.contains(_type)) _type = _facilityTypes.last;
  }

  @override
  void dispose() {
    _name.dispose();
    _building.dispose();
    _floor.dispose();
    _description.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) => value == null || value.trim().isEmpty ? 'Enter $label' : null;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final old = widget.facility;
    Navigator.pop(context, CampusFacility(
      id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      type: _type,
      building: _building.text.trim(),
      floor: _floor.text.trim(),
      description: _description.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.facility == null ? 'Add facility' : 'Edit facility'),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(controller: _name, autofocus: true, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Facility name *', prefixIcon: Icon(Icons.apartment)), validator: (value) => _required(value, 'a facility name')),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _type,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Facility type *', prefixIcon: Icon(Icons.category_outlined)),
                  items: _facilityTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) { if (value != null) setState(() => _type = value); },
                ),
                const SizedBox(height: 10),
                TextFormField(controller: _building, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Building / block *', prefixIcon: Icon(Icons.location_city)), validator: (value) => _required(value, 'a building or block')),
                const SizedBox(height: 10),
                TextFormField(controller: _floor, decoration: const InputDecoration(labelText: 'Floor / room *', prefixIcon: Icon(Icons.layers_outlined)), validator: (value) => _required(value, 'a floor or room')),
                const SizedBox(height: 10),
                TextFormField(controller: _description, maxLines: 3, maxLength: 180, decoration: const InputDecoration(labelText: 'Description (optional)', alignLabelWithHint: true)),
              ]),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: _submit, child: Text(widget.facility == null ? 'Save facility' : 'Save changes')),
        ],
      );
}
