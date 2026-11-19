#  # 💙 Napoli Random Player — iOS App

Un'applicazione iOS sviluppata in **SwiftUI** che estrae in modo casuale i calciatori dalla storia della **S.S.C. Napoli**, recuperando in tempo reale le informazioni biografiche e le foto ufficiali direttamente dalle API di **Wikipedia**.

---

## 📸 Overview dell'App

L'applicazione offre un'interfaccia pulita, minimale e ispirata ai colori sociali del Napoli:
- **Estrazione Casuale**: Un semplice tap sul pulsante per scoprire un nuovo calciatore azzurro.
- **Scheda Dettaglio Biografica**: Card visiva rettangolare contenente la foto del giocatore, il badge del club e l'estratto enciclopedico fornito da Wikipedia.
- **Design Curato**: Layout responsivo ottimizzato con sfondi dinamici, ombreggiature delicate e typography curata.

---

## 🛠️ Architettura e Tecnologie

L'app segue l'architettura **MVVM (Model-View-ViewModel)** ed è realizzata interamente con tecnologie native Apple:

| Componente | Tecnologia / Protocollo | Descrizione |
| :--- | :--- | :--- |
| **UI & Layout** | `SwiftUI`, `NavigationStack` | Interfaccia utente dichiarativa e reattiva |
| **Stato & Reattività** | `@StateObject`, `ObservableObject` | Gestione dello stato dell'interfaccia e del caricamento |
| **Asincronia** | `async/await`, `Task` | Concorrenza moderna per le chiamate di rete REST API |
| **Immagini** | `AsyncImage` | Caricamento asincrono e caching delle immagini di Wikipedia |
| **Persistenza/Cache** | `UserDefaults` | Memorizzazione locale dell'elenco calciatori per avvii istantanei |

---

## 🌐 Integrazione API Wikipedia

L'applicazione sfrutta due differenti endpoint della MediaWiki API:

1. **MediaWiki Action API**:
   - `action=query&list=categorymembers`
   - Recupera l'elenco dei calciatori appartenenti alla categoria ufficiale `Categoria:Calciatori_della_S.S.C._Napoli`.
2. **Wikipedia REST API**:
   - `https://it.wikipedia.org/api/rest_v1/page/summary/{playerName}`
   - Ottiene l'estratto biografico (`extract`) e l'immagine del profilo (`thumbnail`).

---

## 📁 Struttura del Progetto

```text
goodmorning/
├── Assets.xcassets/          # AppIcon (1024x1024) e Logo Squadra (Image)
├── Models/
│   └── WikipediaSummary.swift # Struct Codable per decodificare la risposta API
├── Services/
│   ├── NapoliCategoryService.swift # Fetching dell'elenco giocatori da Wikipedia
│   └── WikipediaAPIService.swift  # Fetching biografia e foto del singolo giocatore
├── ViewModels/
│   └── PlayerViewModel.swift       # Logica di business, selezione random e cache
└── Views/
    └── ContentView.swift          # Interfaccia grafica principale SwiftUI

