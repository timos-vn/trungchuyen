class NotificationResponse {
  List<NotificationDataResponse>? data;
  int? statusCode;
  String? message;
  int? pageIndex;
  int? pageSize;
  int? totalRecords;
  int? pageCount;

  NotificationResponse(
      {this.data,
        this.statusCode,
        this.message,
        this.pageIndex,
        this.pageSize,
        this.totalRecords,
        this.pageCount});

  NotificationResponse.fromJson(Map<String?, dynamic> json) {
    if (json['data'] != null) {
      data = <NotificationDataResponse>[];
      json['data'].forEach((v) {
        data?.add(new NotificationDataResponse.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    pageCount = json['pageCount'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    data['pageCount'] = this.pageCount;
    return data;
  }
}

class NotificationDataResponse {
  String? id;
  String? idTaiKhoan;
  String? tieuDe;
  String? noiDung;
  String? duLieu;
  bool? daDoc;
  String? ngayTao;
  String? nguoiTao;

  NotificationDataResponse(
      {this.id,
        this.idTaiKhoan,
        this.tieuDe,
        this.noiDung,
        this.duLieu,
        this.daDoc,
        this.ngayTao,
        this.nguoiTao});

  NotificationDataResponse.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    idTaiKhoan = json['idTaiKhoan'];
    tieuDe = json['tieuDe'];
    noiDung = json['noiDung'];
    duLieu = json['duLieu'];
    daDoc = json['daDoc'];
    ngayTao = json['ngayTao'];
    nguoiTao = json['nguoiTao'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this.id;
    data['idTaiKhoan'] = this.idTaiKhoan;
    data['tieuDe'] = this.tieuDe;
    data['noiDung'] = this.noiDung;
    data['duLieu'] = this.duLieu;
    data['daDoc'] = this.daDoc;
    data['ngayTao'] = this.ngayTao;
    data['nguoiTao'] = this.nguoiTao;
    return data;
  }
}


