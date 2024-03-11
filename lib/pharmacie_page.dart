import 'package:finder_med/pharmacy_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Pharmacy.dart';

class PharmaciesPage extends StatefulWidget {
  const PharmaciesPage({Key? key}) : super(key: key);

  @override
  _PharmaciesPageState createState() => _PharmaciesPageState();
}

class _PharmaciesPageState extends State<PharmaciesPage> {
  late TextEditingController _searchController;
  bool _showMap = true; // Etat pour contrôler l'affichage de la carte
  final LatLng _yaoundeCenter = const LatLng(3.848, 11.502); // Coordonnées de Yaoundé

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacies'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Rechercher une pharmacie...',
              contentPadding: EdgeInsets.all(16.0),
            ),
            onChanged: (value) {
              setState(() {
                // Si le champ de recherche n'est pas vide, on ne montre plus la carte
                _showMap = value.isEmpty;
              });
            },
          ),
          Expanded(
            child: _showMap ? _buildMap() : _buildPharmaciesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _yaoundeCenter,
        zoom: 12,
      ),
      markers: {
        Marker(
          markerId: MarkerId('yaounde'),
          position: _yaoundeCenter,
          infoWindow: InfoWindow(title: 'Yaoundé'),
        ),
      },
    );
  }

  Widget _buildPharmaciesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Pharmacies').orderBy('nomPharmacie').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }
        final pharmacies = snapshot.data!.docs
            .where((doc) => doc['nomPharmacie'].toString().toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
        if (pharmacies.isEmpty) {
          return Center(child: Text('Aucune pharmacie trouvée.'));
        }

        return ListView.builder(
          itemCount: pharmacies.length,
          itemBuilder: (context, index) {
            var pharmacyData = pharmacies[index];
            return ListTile(
              title: Text(pharmacyData['nomPharmacie']),
              onTap: () {
                List<String> contacts = [];
                if (pharmacyData['contact1'] != null) {
                  contacts.add(pharmacyData['contact1']);
                }
                if (pharmacyData['contact2'] != null) {
                  contacts.add(pharmacyData['contact2']);
                }
                if (pharmacyData['contact3'] != null) {
                  contacts.add(pharmacyData['contact3']);
                }

                final positionGeographique = pharmacyData['positionGeographique'];
                final double? latitude = positionGeographique != null ? positionGeographique['latitude'] : null;
                final double? longitude = positionGeographique != null ? positionGeographique['longitude'] : null;

                var pharmacy = Pharmacy(
                  nomPharmacie: pharmacyData['nomPharmacie'],
                  type: pharmacyData['type'],
                  emplacement: pharmacyData['emplacement'],
                  contacts: contacts,
                  longitude: longitude,
                  latitude: latitude,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PharmacyDetailsPage(pharmacy: pharmacy)),
                );

              },
            );
          },
        );

          },
        );
  }
  }
