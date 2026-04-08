const express = require("express");
const jwt = require("jsonwebtoken");

const app = express();
app.use(express.json());

const SECRET = "mysecretkey";

// Root route (FIX FOR "Cannot GET /")
app.get("/", (req, res) => {
  res.status(200).send("🚀 Secure JWT App is running on ECS Fargate");
});

// Health check (ALB uses this)
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

// Login (mock authentication)
app.post("/login", (req, res) => {
  const { username, password } = req.body;

  if (username === "admin" && password === "admin123") {
    const token = jwt.sign({ user: username }, SECRET, { expiresIn: "1h" });
    return res.json({ token });
  }

  return res.status(401).json({ message: "Invalid credentials" });
});

// Middleware for JWT protection
function authMiddleware(req, res, next) {
  const authHeader = req.headers["authorization"];

  if (!authHeader) {
    return res.status(403).json({ message: "No token provided" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt