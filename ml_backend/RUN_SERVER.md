# 🚀 How to Run the ML Server

## Step-by-Step Instructions

### Step 1: Open Terminal/Command Prompt
- **Windows**: Press `Win + R`, type `cmd`, press Enter
- **Mac/Linux**: Open Terminal app
- **VS Code**: Press `` Ctrl + ` `` (backtick) to open integrated terminal

### Step 2: Navigate to ML Backend Folder
```bash
cd SpenZ/ml_backend
```

Or if you're in the SpenZ folder:
```bash
cd ml_backend
```

### Step 3: Install Dependencies (First Time Only)
```bash
pip install flask flask-cors
```

If you get permission errors, try:
```bash
pip install --user flask flask-cors
```

### Step 4: Run the Server
```bash
python ml_server.py
```

Or if `python` doesn't work, try:
```bash
python3 ml_server.py
```

### Step 5: Verify It's Running
You should see:
```
🚀 Starting Simple ML Backend...
📊 Endpoints:
   POST /api/analyze - Expense analysis
   POST /api/stocks - Stock recommendations
   POST /api/all - Both insights
 * Running on http://0.0.0.0:5000
 * Running on http://127.0.0.1:5000
```

**✅ Server is running!** Keep this terminal window open.

## Test the Server

Open a browser and go to:
```
http://localhost:5000/health
```

You should see: `{"status":"ok"}`

## Common Issues

### "python is not recognized"
- Try `python3` instead of `python`
- Or install Python from python.org

### "pip is not recognized"
- Install Python (pip comes with it)
- Or use `python -m pip install flask flask-cors`

### "Port 5000 already in use"
- Close other programs using port 5000
- Or change port in `ml_server.py` (line 156): `app.run(host='0.0.0.0', port=5001)`

### "Module not found: flask"
- Make sure you ran `pip install flask flask-cors`
- Check you're in the right Python environment

## Stop the Server
Press `Ctrl + C` in the terminal where it's running

## Quick Command Summary
```bash
# Navigate to folder
cd SpenZ/ml_backend

# Install (first time only)
pip install flask flask-cors

# Run server
python ml_server.py
```

That's it! 🎉

