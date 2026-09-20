const { app, BrowserWindow, ipcMain} = require("electron")
const path = require("path")
const { spawn } = require("child_process")
const http = require("http")

console.log("pizaoui laoui electron")
let luauProcess;

function startLuauBackend() {
    luauProcess = spawn("lute", ["run", "src/backend/main.luau"], {
        stdio: ["pipe", "pipe", "pipe"]
    });

    luauProcess.stdout.on("data", (data) => {
        console.log("Luau stdout:", data.toString());
    });

    luauProcess.stderr.on("data", (data) => {
        console.error("Luau stderr:", data.toString());
    });

    luauProcess.on("close", (code) => {
        console.log("Luau process exited with code:", code);
    });
}
let win;
const createWindow = () => {
    win = new BrowserWindow({
        width: 600,
        length: 600,
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            preload: path.join(__dirname, 'preload.js')
        },
    })

    win.loadFile("src/frontend/index.html")
    win.maximize()
}

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit(); luauProcess.kill()
})
app.whenReady().then(() => {
    startLuauBackend();
    createWindow();
        
    ipcMain.addListener('changeFile', (event, args) => {
        console.log("what");
        console.log(args);
        win.loadFile(args)
    })
    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow()
        }
    })
})