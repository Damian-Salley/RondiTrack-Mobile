/// These are the backend's development seed people, not authentication roles.
enum Persona {
  demo('Demo Member'),
  contributor('Sample Contributor'),
  newcomer('New Member');

  new(this.label);
  final String label;

  String get email => switch (this) {
    demo => 'assignment71-demo@ronditrack.example',
    contributor => 'assignment71-contributor@ronditrack.example',
    newcomer => 'assignment101-new@ronditrack.example',
  };
}
