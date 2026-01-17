# UnIntern - Πλατφόρμα Πρακτικής Άσκησης

## Περιγραφή Εφαρμογής

Η εφαρμογή **UnIntern** είναι μια πλατφόρμα που συνδέει φοιτητές με εταιρείες για θέσεις πρακτικής άσκησης. Αποτελείται από:

- **Backend (FastAPI):** REST API server με βάση δεδομένων SQLite
- **Frontend (Flutter):** Cross-platform εφαρμογή για Windows, Web, Android

## Δυνατότητες

- ✅ Εγγραφή και σύνδεση χρηστών (φοιτητές & εταιρείες)
- ✅ Προβολή και αναζήτηση θέσεων πρακτικής
- ✅ Διαχείριση προφίλ
- ✅ News feed με posts
- ✅ Αλληλεπίδραση (likes, comments, saves)
- ✅ Σύστημα chat
- ✅ Ανέβασμα media files

---

## 🚀 Γρήγορη Εγκατάσταση (Βήμα προς Βήμα)

### Προαπαιτούμενα Συστήματος

- **Λειτουργικό Σύστημα:** Windows
- **Python:** 3.10 ή νεότερο ([Download](https://www.python.org/downloads/))
- **Flutter:** Τελευταία σταθερή έκδοση ([Download](https://flutter.dev/docs/get-started/install/windows))
- **Git:** ([Download](https://git-scm.com/download/win))
- **Chrome Browser:** (για εκτέλεση σε web)

---

## Μέρος 1: Εγκατάσταση Backend

### Βήμα 1.1: Κατέβασμα Backend

Άνοιξε PowerShell και τρέξε:

```powershell
cd C:\Users\marti\Documents
git clone https://github.com/elenippn/Unintend_backend.git
cd Unintend_backend
```

### Βήμα 1.2: Δημιουργία Virtual Environment

```powershell
py -m venv .venv
```

### Βήμα 1.3: Ενεργοποίηση Virtual Environment

```powershell
.venv\Scripts\Activate.ps1
```

❗ **Αν εμφανιστεί σφάλμα execution policy**, τρέξε μία φορά:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Πάτησε **Y** (Yes) και μετά ξανατρέξε:

```powershell
.venv\Scripts\Activate.ps1
```

Θα δεις το `(.venv)` μπροστά από το prompt.

### Βήμα 1.4: Εγκατάσταση Python Packages

```powershell
pip install -r requirements.txt
```

### Βήμα 1.5: Αρχικοποίηση Βάσης Δεδομένων

```powershell
py -m app.seed
```

Αυτό θα δημιουργήσει τη βάση `unintern.db` και θα προσθέσει αρχικά δεδομένα (test users, posts, κλπ.).

**Σημαντικό:** Κράτα τους κωδικούς που εμφανίζονται για να συνδεθείς αργότερα!

### Βήμα 1.6: Εκκίνηση Backend Server

```powershell
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

✅ **Επιβεβαίωση:** Άνοιξε το browser και πήγαινε στο:
- http://127.0.0.1:8000 (θα δείς μήνυμα health check)
- http://127.0.0.1:8000/docs (Swagger API documentation)

**Άφησε αυτό το terminal ανοιχτό!** Ο server πρέπει να τρέχει για να λειτουργήσει το frontend.

---

## Μέρος 2: Εγκατάσταση Frontend

### Βήμα 2.1: Εγκατάσταση Flutter (αν δεν το έχεις)

1. Κατέβασε το Flutter SDK: https://flutter.dev/docs/get-started/install/windows
2. Αποσυμπίεσε το σε φάκελο (π.χ. `C:\src\flutter`)
3. Πρόσθεσε το `C:\src\flutter\bin` στο PATH:
   - Windows Search → "Environment Variables"
   - User Variables → Path → Edit → New
   - Πρόσθεσε: `C:\src\flutter\bin`
4. Άνοιξε **νέο** PowerShell terminal και τρέξε:

```powershell
flutter doctor
```

Ακολούθησε τις οδηγίες για να διορθώσεις προβλήματα (αν υπάρχουν).

### Βήμα 2.2: Κατέβασμα Frontend

Άνοιξε **νέο** PowerShell terminal (το backend πρέπει να τρέχει στο άλλο):

```powershell
cd C:\Users\marti\Documents
git clone https://github.com/elenippn/UnIntend-project.git
cd UnIntend-project
```

### Βήμα 2.3: Εγκατάσταση Flutter Packages

```powershell
flutter pub get
```

### Βήμα 2.4: Εκτέλεση της Εφαρμογής

Επιλογή 1 - **Windows Desktop** (συνιστάται):
```powershell
flutter run -d windows
```

Επιλογή 2 - **Chrome Web**:
```powershell
flutter run -d chrome
```

Επιλογή 3 - **Android Emulator**:
1. Άνοιξε Android Studio
2. AVD Manager → Start emulator
3. Μετά τρέξε:
```powershell
flutter run
```

---

## 📱 Χρήση της Εφαρμογής

### Δοκιμαστικοί Λογαριασμοί

Μετά το seed, μπορείς να συνδεθείς με:

**Φοιτητής:**
- Username: `eleni`
- Password: `pass1234`

**Εταιρεία:**
- Username: `techcorp`
- Password: `pass1234`

(Περισσότεροι λογαριασμοί εμφανίζονται κατά το `py -m app.seed`)

### Βασικές Λειτουργίες

1. **Είσοδος:** Χρησιμοποίησε έναν από τους παραπάνω λογαριασμούς
2. **Home Feed:** Δες posts από εταιρείες και φοιτητές
3. **Search:** Αναζήτησε θέσεις πρακτικής
4. **Profile:** Επεξεργασία του προφίλ σου
5. **Chat:** Επικοινώνησε με άλλους χρήστες
6. **Interactions:** Κάνε like, comment, save σε posts

---

## 🛠 Αντιμετώπιση Προβλημάτων

### Backend δεν ξεκινάει

**Πρόβλημα:** `ModuleNotFoundError`
```powershell
# Ενεργοποίησε το venv πρώτα
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

**Πρόβλημα:** Port 8000 already in use
```powershell
# Βρες ποια διεργασία χρησιμοποιεί το port
netstat -ano | findstr :8000
# Σκότωσε τη διεργασία (αντικατέστησε <PID>)
taskkill /PID <PID> /F
```

### Frontend δεν συνδέεται με Backend

1. **Έλεγξε αν το backend τρέχει:**
   - Πήγαινε στο http://127.0.0.1:8000
   - Πρέπει να δεις health check response

2. **Firewall:**
   - Windows Defender Firewall μπορεί να μπλοκάρει τη σύνδεση
   - Επίτρεψε το Python/uvicorn στο firewall

3. **Restart:**
   ```powershell
   # Σταμάτα το backend (Ctrl+C)
   # Σταμάτα το frontend (Ctrl+C)
   # Ξανα-ξεκίνα και τα δύο
   ```

### Flutter Errors

**Πρόβλημα:** `flutter command not found`
- Βεβαιώσου ότι το Flutter είναι στο PATH
- Κλείσε και ξανάνοιξε το terminal

**Πρόβλημα:** Dependencies conflicts
```powershell
flutter clean
flutter pub get
```

---

## 📋 Δομή Project

```
Documents/
├── Unintern_backend/          # Backend (FastAPI + SQLite)
│   ├── app/
│   │   ├── main.py            # Entry point
│   │   ├── models.py          # Database models
│   │   ├── schemas.py         # Pydantic schemas
│   │   ├── auth.py            # Authentication
│   │   ├── routers/           # API endpoints
│   │   └── ...
│   ├── requirements.txt       # Python dependencies
│   ├── unintern.db           # SQLite database (created after seed)
│   └── README.md
│
└── UnIntern-project/          # Frontend (Flutter)
    ├── lib/
    │   ├── main.dart          # Entry point
    │   ├── screens/           # UI screens
    │   ├── models/            # Data models
    │   ├── api/               # API client
    │   └── widgets/           # Reusable widgets
    ├── pubspec.yaml           # Flutter dependencies
    └── README.md
```

---

## 🔄 Reset της Εφαρμογής

Αν θέλεις να ξεκινήσεις από την αρχή:

1. **Κλείσε το backend** (Ctrl+C στο terminal)
2. **Διέγραψε τη βάση:**
   ```powershell
   cd C:\Users\marti\Documents\Unintern_backend
   Remove-Item unintern.db
   ```
3. **Ξανα-δημιούργησε:**
   ```powershell
   .venv\Scripts\Activate.ps1
   py -m app.seed
   uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
   ```

---

## 📝 Τεχνολογίες που Χρησιμοποιούνται

### Backend
- **FastAPI:** Modern Python web framework
- **SQLAlchemy:** ORM για τη βάση
- **SQLite:** Lightweight database
- **JWT:** Token-based authentication
- **Uvicorn:** ASGI server

### Frontend
- **Flutter:** Cross-platform framework
- **Dart:** Programming language
- **HTTP:** API calls
- **Provider/State Management:** Διαχείριση state

---

## ✅ Checklist Επιτυχημένης Εγκατάστασης

- [ ] Python 3.10+ εγκατεστημένο
- [ ] Flutter SDK εγκατεστημένο και στο PATH
- [ ] Backend dependencies εγκατεστημένα (`pip install -r requirements.txt`)
- [ ] Database seeded (`py -m app.seed`)
- [ ] Backend server τρέχει στο http://127.0.0.1:8000
- [ ] Flutter packages εγκατεστημένα (`flutter pub get`)
- [ ] Frontend τρέχει (`flutter run -d windows`)
- [ ] Μπορείς να συνδεθείς με δοκιμαστικό λογαριασμό

---

## 📞 Υποστήριξη

Για προβλήματα ή ερωτήσεις:
1. Έλεγξε το section "Αντιμετώπιση Προβλημάτων"
2. Δες τα logs στα terminals (backend & frontend)
3. Επικοινώνησε με την ομάδα ανάπτυξης

---

**Καλή χρήση!** 🚀
