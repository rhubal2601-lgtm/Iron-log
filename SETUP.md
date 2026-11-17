# logbook – Cloud Edition (GitHub Pages + Supabase Free)

## Was enthalten ist
- E-Mail/Passwort-Login
- Mehrere Personenprofile pro Login/Workspace
- Gemeinsame Editor-Einstellungen für alle Profile dieses Workspaces
- PPL und Torso/Limbs A/B Trainingsvorlagen, Übungen austauschbar/ergänzbar
- Cloud-Workout-Speicherung
- JSON-Backup für Profile, Workouts und Editor-Einstellungen
- RLS-Schutz pro Workspace

## Einrichtung
1. Supabase: https://supabase.com/dashboard – neues Free-Projekt erstellen.
2. Im Supabase Dashboard > SQL Editor > New query den Inhalt `supabase_setup.sql` ausführen.
3. In Project Settings > API (oder Connect) die Project URL und den publishable/anon key kopieren.
4. `supabase-config.js` öffnen und `DEINE_SUPABASE_PROJECT_URL` sowie `DEIN_SUPABASE_PUBLISHABLE_ODER_ANON_KEY` ersetzen. Nur den publishable/anon key verwenden – niemals service_role/secret.
5. GitHub Repository `iron-log`: Upload/Commit aller Dateien aus diesem Ordner im Repository-Hauptverzeichnis. Vorhandene gleichnamige Dateien ersetzen.
6. GitHub Settings > Pages: Deploy from branch, `main`, `/(root)`.
7. GitHub Pages URL in Safari öffnen. Konto erstellen. Wenn E-Mail-Bestätigung aktiviert ist, Bestätigungslink öffnen und anschließend anmelden.
8. Profile erstellen und verwenden.

## Datenmodell / Login
Jede E-Mail-Anmeldung erhält einen eigenen Workspace. In diesem Workspace können mehrere Personenprofile verwaltet werden. Die Editor-Einstellungen gelten gemeinsam für alle Profile dieses Workspaces. Separate Logins sehen aus Sicherheitsgründen NICHT automatisch die Profile anderer Logins. Ein gemeinsamer Workspace mit mehreren eingeloggten Mitgliedern/Einladungen ist eine separate Erweiterung.

## Sicherheit
- `supabase-config.js` enthält nur URL + publishable/anon key. Das ist für Browser-Apps vorgesehen.
- Niemals den `service_role` / secret key veröffentlichen.
- RLS-Policies in `supabase_setup.sql` begrenzen alle Datensätze auf den Workspace des angemeldeten Users.
- Aktiviere E-Mail-Bestätigung in Supabase Auth, wenn gewünscht.
- Nutze ein starkes, einzigartiges Passwort.

## Backup-Hinweis
Der Export lädt einen JSON-Backup herunter. Der aktuelle Import stellt Profile und Editor-Einstellungen wieder her; Workout-Datensätze sind im Export enthalten, der direkte Workout-Import ist in dieser ersten Cloud-Ausgabe noch nicht aktiviert. Supabase Free bietet keine automatischen täglichen Datenbank-Backups; exportiere regelmäßig.

## Grenzen der Free-Version
Supabase Free kann Projekte nach Inaktivität pausieren; Free-Projekte haben begrenzte Quoten. GitHub Pages hostet nur die App-Dateien. Siehe aktuelle Supabase Free Limits und Pausenregeln in der offiziellen Dokumentation.


## Neuer Trainingsbereich (Version 2)

- Einseitige Übungen: In jeder Übung lässt sich "Einseitig" aktivieren. Links und rechts werden Gewicht und Wiederholungen getrennt protokolliert.
- Gerätebibliothek: Enthält beispielhafte Geräte-/Gerätefamilien von Prime Fitness, Cybex, Hammer Strength, Nautilus, Technogym, Life Fitness, Matrix, Panatta, gym80, Precor und Freemotion sowie einen Eintrag für eigene Geräte. Die Bibliothek ist eine erweiterbare Startauswahl, keine vollständige Hersteller- oder Modell-Datenbank.
- Geräteeinstellungen: Sitzhöhe, Polster, Arm-/Griffposition, Startposition und weitere passende Felder lassen sich je Gerät und Personenprofil speichern. Die Werte liegen im bestehenden JSON-Feld der Tabelle `app_settings`; für diese Erweiterung ist keine zusätzliche SQL-Migration nötig.
- Übungszuordnung: Bei jeder Übung kann ein Gerät aus der Bibliothek zugeordnet werden.

Nach dem Ersetzen der Dateien auf GitHub Pages bitte die Seite einmal vollständig neu laden. Falls eine alte Version angezeigt wird, Browser-Cache bzw. installierte PWA schließen und erneut öffnen.
