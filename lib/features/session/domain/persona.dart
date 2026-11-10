/// These are the backend's development seed people, not authentication roles.
enum Persona {
  demo('Demo Member'),
  contributor('Sample Contributor'),
  newcomer('New Member');

  new(this.label);
  final String label;
}
