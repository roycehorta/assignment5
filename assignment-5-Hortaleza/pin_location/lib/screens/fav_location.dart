import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritePlace {
  final LatLng position;
  final String location;
  final String title;
  final String description;

  FavoritePlace({
    required this.position,
    required this.location,
    required this.title,
    required this.description,
  });
}

class FavLocation extends StatefulWidget {
  const FavLocation({Key? key}) : super(key: key);

  @override
  State<FavLocation> createState() => _FavLocationState();
}

class _FavLocationState extends State<FavLocation> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  List<FavoritePlace> _favplace = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final _databaseReference = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadFavPlace();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _loadFavPlace() async {
    final snapshot = await _databaseReference.collection('favplace').get();
    final placesData = snapshot.docs;
    if (placesData.isNotEmpty) {
      setState(() {
        _favplace = placesData.map((doc) {
          final position = doc['position'];
          final latitude = (position is Map<String, dynamic>)
              ? position['latitude'] ?? 0.0
              : 0.0;
          final longitude = (position is Map<String, dynamic>)
              ? position['longitude'] ?? 0.0
              : 0.0;

          return FavoritePlace(
            position: LatLng(latitude, longitude),
            location: doc['location'],
            title: doc['title'],
            description: doc['description'],
          );
        }).toList();
        _loadMarkers();
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  Future<void> _saveFavPlace() async {
    final collectionReference = _databaseReference.collection('favplace');

    // Clear existing documents in the collection
    await collectionReference.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    // Add new documents to the collection
    for (var place in _favplace) {
      final placeData = {
        'position': {
          'latitude': place.position.latitude,
          'longitude': place.position.longitude,
        },
        'location': place.location,
        'title': place.title,
        'description': place.description,
      };
      await collectionReference.add(placeData);
    }
  }

  void _loadMarkers() {
    _markers.clear();
    for (var place in _favplace) {
      final marker = Marker(
        markerId: MarkerId(place.position.toString()),
        position: place.position,
        infoWindow: InfoWindow(
          title: place.title,
          snippet: place.description,
        ),
      );
      _markers.add(marker);
    }
  }

  void _addFavoritePlace(
    LatLng position,
    String title,
    String description,
    String location,
  ) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String address = 'Unknown Address';
    if (placemarks.isNotEmpty) {
      final Placemark firstPlace = placemarks.first;
      address =
          '${firstPlace.street ?? ''}, ${firstPlace.locality ?? ''}, ${firstPlace.administrativeArea ?? ''}';
    }

    setState(() {
      _favplace.add(
        FavoritePlace(
          position: position,
          location: address,
          title: title,
          description: description,
        ),
      );
      _loadMarkers();
      _saveFavPlace();
    });
  }

  void _deleteFavoritePlace(FavoritePlace place) {
    setState(() {
      _favplace.remove(place);
      _loadMarkers();
      _saveFavPlace();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('DriveHub'),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              15.9758,
              120.5707,
            ),
            zoom: 14,
          ),
          onTap: (position) async {
            showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder<List<Placemark>>(
                            future: placemarkFromCoordinates(
                              position.latitude,
                              position.longitude,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final List<Placemark> placemarks =
                                    snapshot.data!;
                                final String address =
                                    placemarks.first.street ??
                                        'Unknown Address';
                                return TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Pinned Location',
                                    prefixIcon: Icon(Icons.location_on),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    enabled: false,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller:
                                      TextEditingController(text: address),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error retrieving address');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Driving School Location Name',
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: _descriptionController,
                            decoration:
                                InputDecoration(labelText: 'Description'),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            child: Text('Add Place'),
                            onPressed: () {
                              final title = _titleController.text;
                              final description = _descriptionController.text;
                              final location = _titleController.text;
                              _addFavoritePlace(
                                  position, title, description, location);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        drawer: Drawer(
          child: Column(
            children: [
              ListTile(
                title: Text('Favorite Places'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _favplace.length,
                  itemBuilder: (ctx, index) {
                    final place = _favplace[index];
                    return ListTile(
                      title: Text(place.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.location),
                          Text(place.description),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Delete Place'),
                              content: Text(
                                  'Are you sure you want to delete this favorite place?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    _deleteFavoritePlace(place);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
