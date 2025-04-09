# Perplex Clone 🧠🔍

A clone of the Perplex AI chatbot with integrated search and modern UI.

## 🚀 Features

- 💬 Chat with AI (LLM integration)
- 🌐 Web search results included in responses
- 📱 Flutter-based frontend
- ⚡ FastAPI backend for handling requests
- 🔐 Environment variable support via `.env`

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend**: Python + FastAPI
- **Others**: Firebase (optional), GitHub, REST APIs

## 📦 Getting Started

### 🔧 Backend Setup (FastAPI)

```bash
cd server
pip install -r requirements.txt
uvicorn main:app --reload
```

Create a `.env` file in the `server/` directory:

```env
API_KEY=your_api_key_here
```

> Make sure `.env` and `server/venv/` are excluded (already in `.gitignore`).

---

### 💻 Frontend Setup (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```

## 📁 Project Structure

```
.
├── frontend/              # Flutter code
├── server/                # FastAPI backend
│   ├── main.py
│   ├── .env
│   └── requirements.txt
└── README.md
```

## 🔒 Git Setup Notes

- `.env` is excluded in `.gitignore`
- `server/venv/` is excluded
- Avoid pushing large files like model weights or DLLs

