class LoginRequestBody {

	String username;
	String password;


	LoginRequestBody({this.username, this.password,});

	LoginRequestBody.fromJson(Map<String, dynamic> json) {

		username = json['TenDangNhap'];
		password = json['MatKhau'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if(this.username != null){
			data['TenDangNhap'] = this.username;
		}
		if(this.password != null){
			data['MatKhau'] = this.password;
		}
		return data;
	}
}
