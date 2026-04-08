const express = require("express");
const jwt = require("jsonwebtoken");

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const SECRET = "mysecretkey";

// ----------------------
// Login Page (UI)
// ----------------------
app.get("/", (req, res) => {
  res.send(`
    <html>
      <body>
        <h2>Login</h2>
        <form method="POST" action="/login">
          <input type="text" name="username" placeholder="Username" required /><br/><br/>
          <input type="password" name="password" placeholder="Password" required /><br/><br/>
          <button type="submit">Login</button>
        </form>
      </body>
    </html>
  `);
});

// ----------------------
// Health Check (ALB)
// ----------------------
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

// ----------------------
// Login API
// ----------------------
app.post("/login", (req, res) => {
  const { username, password } = req.body;

  // Mock authentication
  if (username === "admin" && password === "admin123") {
    const token = jwt.sign({ user: username }, SECRET, {
      expiresIn: "1h",
    });

    return res.send(`
      <h3>Login Successful</h3>
      <p><b>Your Token:</b></p>
      <textarea rows="5" cols="60">${token}</textarea>
      <p>Use this token in Authorization header:</p>
      <code>Authorization: Bearer ${token}</code>
      <br/><br/>
      <a href="/protected">Go to Protected Route</a>
    `);
  }

  return res.status(401).send("<h3>Invalid credentials</h3>");
});

// ----------------------
// JWT Middleware
// ----------------------
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

// ----------------------
// Protected Endpoint
// ----------------------
app.get("/protected", authMiddleware, (req, res) => {
  const items = [
    { id: 1, name: "Item One" },
    { id: 2, name: "Item Two" },
    { id: 3, name: "Item Three" },
  ];

  res.json({
    message: "Protected data accessed",
    user: req.user,
    items: items,
  });
});

// ----------------------
// Start Server
// ----------------------
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});