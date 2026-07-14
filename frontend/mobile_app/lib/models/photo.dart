class Photo {

  final int id;
  final String fileName;
  final String sender;
  final String caption;
  final DateTime timestamp;


  Photo({
    required this.id,
    required this.fileName,
    required this.sender,
    required this.caption,
    required this.timestamp,
  });


  factory Photo.fromJson(
      Map<String,dynamic> json)
  {
    return Photo(

      id: json['id'],

      fileName:
      json['fileName'],

      sender:
      json['sender'],

      caption:
      json['caption'],

      timestamp:
      DateTime.parse(
          json['timestamp']
      ),

    );
  }
}