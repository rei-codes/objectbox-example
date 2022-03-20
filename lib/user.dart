import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class User {
  int id = 0;
  final String name;

  User(this.name);
}
