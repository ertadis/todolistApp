enum APIRoutesEnum {
  ///API linki
  baseUrl('https://reqres.in/api/'),

  ///Kullanıcı endpointi
  listUsers('users'),
  ///kayıt endpointi
  register('register'),
  ///login endpointi
  login('login'),
  ///logout endpointi
  logout('logout');

  final String routeName;
  const APIRoutesEnum(this.routeName);
}
