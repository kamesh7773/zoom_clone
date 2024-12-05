import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../routes/route_names.dart';
import '../../services/firebase_firestore_methods.dart';

class MeetingHistroy extends StatefulWidget {
  const MeetingHistroy({super.key});

  @override
  State<MeetingHistroy> createState() => _MeetingHistroyState();
}

class _MeetingHistroyState extends State<MeetingHistroy> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (value, result) {
        if (!value) {
          //! On press redirect user to homePage.
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.homePage,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        //! AppBar
        appBar: AppBar(
          title: const Text(
            "Meeting history",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: "Lato",
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 36, 36, 36),
          leading: IconButton(
            onPressed: () {
              //! On press redirect user to Welcome Page.
              //! On press redirect user to homePage.
              Navigator.of(context).pushNamedAndRemoveUntil(
                RoutesNames.homePage,
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromRGBO(46, 119, 255, 1),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FireStoreCurdMethods.readMeetingDetails(),
          builder: (context, snapshot) {
            // While snapshot is fetching data, show loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), // Change the color here
              );
            }

            // if snapshot has data.
            if (snapshot.hasData) {
              // Storing list of documents from collection
              List meetingDetailsList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: meetingDetailsList.length,
                itemBuilder: (context, index) {
                  // Getting individual document from list of documents
                  DocumentSnapshot document = meetingDetailsList[index];

                  // Getting individual document ID
                  String docID = document.id;

                  // Getting map data of each document
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                  // retriving Information.
                  String imageURL = data['imageURL'];
                  String meetingType = data['meetingType'];
                  Timestamp joinTime = data['joinTime'];
                  Timestamp leaveTime = data['leaveTime'];
                  int totalDuration = data['totalDuration'];

                  // calculating total meeting duration.
                  int seconds = totalDuration; // Example seconds

                  // Calculate minutes and remaining seconds
                  int minutes = seconds ~/ 60; // Integer division
                  int remainingSeconds = seconds % 60; // Modulo to get the remainder

                  // Format as "min:sec"
                  String formattedTime = '${minutes.toString().padLeft(2, '0')} min : ${remainingSeconds.toString().padLeft(2, '0')} sec';

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color.fromARGB(255, 48, 48, 48),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                fit: BoxFit.fitHeight,
                                width: 50,
                                height: 50,
                                imageUrl: imageURL,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              children: [
                                meetingType == "MeetingCreated"
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Meeting created at : ${DateFormat('hh:mm a').format(joinTime.toDate())}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Meeting end at : ${DateFormat('hh:mm a').format(leaveTime.toDate())}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Total Duration : $formattedTime",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Meeting join at : ${DateFormat('hh:mm a').format(joinTime.toDate())}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Meeting end at : ${DateFormat('hh:mm a').format(leaveTime.toDate())}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Total Duration : $formattedTime",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            const SizedBox(width: 38),
                            IconButton(
                              onPressed: () {
                                FireStoreCurdMethods.deleteMeetingDetails(docID: docID);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 236, 84, 73),
                                size: 25,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            // Else return nothing
            else {
              return const Center(
                child: Text("No Data"),
              );
            }
          },
        ),
      ),
    );
  }
}
