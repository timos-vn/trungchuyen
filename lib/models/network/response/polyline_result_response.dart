class PolylineResultResponse {
  PolylineResultResponseBody? data;
  int? statusCode;
  String? message;

  PolylineResultResponse({this.data, this.statusCode, this.message});

  PolylineResultResponse.fromJson(Map<String?, dynamic> json) {
    data = json['data'] != null ? new PolylineResultResponseBody.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class PolylineResultResponseBody {
  Polyline? polyline;
  int? statusCode;
  String? message;

  PolylineResultResponseBody({this.polyline, this.statusCode, this.message});

  PolylineResultResponseBody.fromJson(Map<String?, dynamic> json) {
    polyline = json['polyline'] != null
        ? new Polyline.fromJson(json['polyline'])
        : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this.polyline != null) {
      data['polyline'] = this.polyline?.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Polyline {
  Distance? distance;
  Distance? duration;
  String? startAddress;
  String? endAddress;
  StartLocation? startLocation;
  StartLocation? endLocation;
  List<Points>? points;

  Polyline(
      {this.distance,
        this.duration,
        this.startAddress,
        this.endAddress,
        this.startLocation,
        this.endLocation,
        this.points});

  Polyline.fromJson(Map<String?, dynamic> json) {
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new Distance.fromJson(json['duration'])
        : null;
    startAddress = json['start_address'];
    endAddress = json['end_address'];
    startLocation = json['start_location'] != null
        ? new StartLocation.fromJson(json['start_location'])
        : null;
    endLocation = json['end_location'] != null
        ? new StartLocation.fromJson(json['end_location'])
        : null;
    if (json['points'] != null) {
      points = <Points>[];
      json['points'].forEach((v) {
        points?.add(new Points.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance?.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration?.toJson();
    }
    data['start_address'] = this.startAddress;
    data['end_address'] = this.endAddress;
    if (this.startLocation != null) {
      data['start_location'] = this.startLocation?.toJson();
    }
    if (this.endLocation != null) {
      data['end_location'] = this.endLocation?.toJson();
    }
    if (this.points != null) {
      data['points'] = this.points?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String?, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}

class StartLocation {
  double? lat;
  double? lng;

  StartLocation({this.lat, this.lng});

  StartLocation.fromJson(Map<String?, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Points {
  double? lat;
  double? lng;

  Points({this.lat, this.lng});

  Points.fromJson(Map<String?, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
