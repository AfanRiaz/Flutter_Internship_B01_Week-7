class AuthModel {
  final String name;
  final String email;
  final String password;
  final bool isLoading;
  final bool isPasswordHidden;

  AuthModel({
    this.name='',
    this.email='',
    this.password='',
    this.isLoading=false,
    this.isPasswordHidden=false,
  });
  AuthModel copyWith({
    String? name,
    String? email,
    String? password,
    bool? isLoading,
    bool? isPasswordHidden,
  }){
    return AuthModel(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        isLoading: isLoading ?? this.isLoading,
        isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden
    );
  }

}