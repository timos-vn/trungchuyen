class LoginResponse {
	LoginResponseData data;
	int statusCode;
	String message;

	LoginResponse({this.data, this.statusCode, this.message});

	LoginResponse.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new LoginResponseData.fromJson(json['data']) : null;
		statusCode = json['statusCode'];
		message = json['message'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
			data['data'] = this.data.toJson();
		}
		data['statusCode'] = this.statusCode;
		data['message'] = this.message;
		return data;
	}
}

class LoginResponseData {
	String accessToken;
	String refreshToken;
	TaiKhoan taiKhoan;

	LoginResponseData({this.accessToken, this.refreshToken, this.taiKhoan});

	LoginResponseData.fromJson(Map<String, dynamic> json) {
		accessToken = json['accessToken'];
		refreshToken = json['refreshToken'];
		taiKhoan = json['taiKhoan'] != null
				? new TaiKhoan.fromJson(json['taiKhoan'])
				: null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['accessToken'] = this.accessToken;
		data['refreshToken'] = this.refreshToken;
		if (this.taiKhoan != null) {
			data['taiKhoan'] = this.taiKhoan.toJson();
		}
		return data;
	}
}

class TaiKhoan {
	String id;
	String tenDangNhap;
	String dienThoai;
	String email;
	String hoTen;
	int chucVu;
	int nhaXe;

	TaiKhoan(
			{this.id,
				this.tenDangNhap,
				this.dienThoai,
				this.email,
				this.hoTen,
				this.chucVu,
				this.nhaXe});

	TaiKhoan.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		tenDangNhap = json['tenDangNhap'];
		dienThoai = json['dienThoai'];
		email = json['email'];
		hoTen = json['hoTen'];
		chucVu = json['chucVu'];
		nhaXe = json['nhaXe'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['tenDangNhap'] = this.tenDangNhap;
		data['dienThoai'] = this.dienThoai;
		data['email'] = this.email;
		data['hoTen'] = this.hoTen;
		data['chucVu'] = this.chucVu;
		data['nhaXe'] = this.nhaXe;
		return data;
	}
}

