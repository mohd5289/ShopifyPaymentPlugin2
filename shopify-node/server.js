// server.js
const express = require("express");
const dotenv = require("dotenv");
const axios = require("axios");

dotenv.config();
const app = express();
app.use(express.json());

const PSP_URL = process.env.PSP_URL || "https://bank9jacollectapi.example";

app.post("/payment", async (req, res) => {
  console.log("Payment request:", req.body);
  const resp = await axios.post(`${PSP_URL}/payment`, req.body);
  res.json(resp.data);
});

app.post("/capture", async (req, res) => {
  console.log("Capture request:", req.body);
  const resp = await axios.post(`${PSP_URL}/capture`, req.body);
  res.json(resp.data);
});

app.post("/refund", async (req, res) => {
  console.log("Refund request:", req.body);
  const resp = await axios.post(`${PSP_URL}/refund`, req.body);
  res.json(resp.data);
});

app.post("/void", async (req, res) => {
  console.log("Void request:", req.body);
  const resp = await axios.post(`${PSP_URL}/void`, req.body);
  res.json(resp.data);
});

app.listen(8080, () => {
  console.log("HTTP server running on http://localhost:8080");
});
