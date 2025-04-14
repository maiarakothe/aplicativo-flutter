importScripts("https://www.gstatic.com/firebasejs/10.11.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.11.0/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: "AIzaSyC0DolBmlyDs293z6IWw5UBi92xPg1xkmU",
  authDomain: "aplicativo-flutter-a2d67.firebaseapp.com",
  projectId: "aplicativo-flutter-a2d67",
  storageBucket: "aplicativo-flutter-a2d67.firebasestorage.app",
  messagingSenderId: "77824107659",
  appId: "1:77824107659:web:5e2b7ab9b9342416be608e",
  measurementId: "G-GK0E97XN87"
};

// Inicializar o Firebase
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();
