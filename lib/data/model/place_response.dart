class PlaceResponse {
  String? type;
  List<String>? query;
  List<Features>? features;
  String? attribution;

  PlaceResponse({this.type, this.query, this.features, this.attribution});

  PlaceResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    query = json['query'].cast<String>();
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['query'] = this.query;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    data['attribution'] = this.attribution;
    return data;
  }
}

class Features {
  String? id;
  String? type;
  List<String>? placeType;
  int? relevance;
  Properties? properties;
  String? text;
  String? placeName;
  List<double>? center;
  Geometry? geometry;
  List<Context>? context;

  Features(
      {this.id,
        this.type,
        this.placeType,
        this.relevance,
        this.properties,
        this.text,
        this.placeName,
        this.center,
        this.geometry,
        this.context});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    placeType = json['place_type'].cast<String>();
    relevance = json['relevance'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    text = json['text'];
    placeName = json['place_name'];
    center = json['center'].cast<double>();
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    if (json['context'] != null) {
      context = <Context>[];
      json['context'].forEach((v) {
        context!.add(new Context.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['place_type'] = this.placeType;
    data['relevance'] = this.relevance;
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    data['text'] = this.text;
    data['place_name'] = this.placeName;
    data['center'] = this.center;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    if (this.context != null) {
      data['context'] = this.context!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Properties {
  String? foursquare;
  bool? landmark;
  String? category;
  String? maki;
  String? address;
  String? wikidata;

  Properties(
      {this.foursquare,
        this.landmark,
        this.category,
        this.maki,
        this.address,
        this.wikidata});

  Properties.fromJson(Map<String, dynamic> json) {
    foursquare = json['foursquare'];
    landmark = json['landmark'];
    category = json['category'];
    maki = json['maki'];
    address = json['address'];
    wikidata = json['wikidata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foursquare'] = this.foursquare;
    data['landmark'] = this.landmark;
    data['category'] = this.category;
    data['maki'] = this.maki;
    data['address'] = this.address;
    data['wikidata'] = this.wikidata;
    return data;
  }
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordinates'] = this.coordinates;
    data['type'] = this.type;
    return data;
  }
}

class Context {
  String? id;
  String? mapboxId;
  String? text;
  String? wikidata;
  String? shortCode;

  Context({this.id, this.mapboxId, this.text, this.wikidata, this.shortCode});

  Context.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mapboxId = json['mapbox_id'];
    text = json['text'];
    wikidata = json['wikidata'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mapbox_id'] = this.mapboxId;
    data['text'] = this.text;
    data['wikidata'] = this.wikidata;
    data['short_code'] = this.shortCode;
    return data;
  }
}