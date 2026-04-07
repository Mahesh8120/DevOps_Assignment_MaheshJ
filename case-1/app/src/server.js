const express = require("express");
const jwt = require("jsonwebtoken");

const app = express();
app.use(express.json());

const SECRET = "mysecretkey";

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
    const decoded = jwt.verify(token, SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ message: "Invalid token" });
  }
}

// Protected route
app.get("/items", authMiddleware, (req, res) => {
  res.json({
    user: req.user,
    items: [
      "item-1",
      "item-2",
      "item-3"
    ]
  });
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});