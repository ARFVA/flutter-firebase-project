# Development Guide

## Development Rules

1. Implement one phase at a time
2. Do not skip acceptance criteria
3. Do not introduce unnecessary technologies
4. Do not replace Firebase services without approval
5. Do not connect Flutter directly to PostgreSQL
6. Never commit secrets
7. Keep Firebase Security Rules under version control
8. Keep the application buildable after every phase
9. Update documentation when architecture changes
10. Do not over-engineer the MVP
11. Business-critical logic must not rely entirely on client-side calculations
12. Use Firebase Emulator Suite where practical
13. Explain major architectural decisions in documentation
14. Do not silently change the project scope
15. If a requirement conflicts with Firebase best practices, explain the issue before implementing the alternative

## Git Workflow

### Branching Strategy (sesuai SOP/GRC/DEV-COD/2026/002)

```
main            → production (stabil, tidak boleh di-push langsung)
  └── develop     → development
        ├── feat/*     → fitur baru
        ├── fix/*      → perbaikan bug
        ├── style/*    → tampilan/UI
        ├── chore/*    → instalasi/tooling
        └── hotfix/*   → perbaikan urgent
```

Aturan:
- Semua perubahan lewat branch `feat/`, `fix/`, `style/`, `chore/`, atau `hotfix/`
- Tidak boleh push langsung ke `main`; semua perubahan masuk lewat merge ke `develop`
- Gunakan `git merge` (atau Merge Request di remote) untuk menggabung ke `develop`

### Commit Message Format (sesuai SOP)

```
<type>: [XX] short description
```

- `<type>`: `feat`, `fix`, `style`, `chore`, `hotfix` (sesuai branch)
- `[XX]`: inisial nama pelaku (misal Riffat Arfa → `[RA]`)
- `short description`: bahasa Inggris, singkat

Contoh:
```
feat: [RA] add app check activation
fix: [RA] fix duplicate xp awarding
style: [RA] redesign login screen
chore: [RA] bump version to 1.1.0-beta.1
```

### Before Committing

1. Run `flutter analyze`
2. Test the changes
3. Ensure no secrets are committed
4. Update relevant documentation

## Code Style

### Dart/Flutter

- Follow Effective Dart guidelines
- Use dartfmt for formatting
- Keep functions small and focused
- Use meaningful variable names
- Add comments only when necessary

### GetX

- Use GetX controllers for state management
- Use GetX for routing
- Use GetX for dependency injection
- Keep controllers lightweight

## Testing

Will be implemented in Phase 13: Testing & Emulator Suite

## Firebase Development

### Using Emulator Suite

The Firebase Emulator Suite will be used for local development and testing (Phase 13).

### Firebase Commands

```bash
# Login to Firebase
firebase login

# Initialize Firebase
firebase init

# Start emulators
firebase emulators:start

# Deploy to production
firebase deploy
```

## Flutter Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Analyze code
flutter analyze

# Format code
dart format .

# Build APK
flutter build apk

# Build app bundle
flutter build appbundle
```

## Environment Configuration

### Development Environment

- Use Firebase Emulator Suite
- Debug builds
- App Check in debug mode

### Production Environment

- Production Firebase project
- Release builds
- App Check enforcement

## Documentation Updates

Always update documentation when:
- Architecture changes
- New features are added
- Dependencies are updated
- Security measures are implemented
- API changes occur

## Troubleshooting

### Common Issues

#### Firebase Configuration Issues
- Ensure firebase_options.dart is in .gitignore
- Check Firebase project configuration
- Verify platform-specific setup

#### Build Issues
- Run `flutter clean`
- Delete pubspec.lock
- Run `flutter pub get` again

#### Dependency Issues
- Check pubspec.yaml for version conflicts
- Run `flutter pub upgrade`
- Verify Flutter SDK version

## Phase Checklist

Before moving to the next phase:
- [ ] All acceptance criteria met
- [ ] Application builds successfully
- [ ] flutter analyze passes
- [ ] Documentation updated
- [ ] Git committed
- [ ] No secrets committed
- [ ] Learning checkpoint understood

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
