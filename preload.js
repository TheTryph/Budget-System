const { contextBridge, ipcRenderer} = require("electron")
console.log("preload loaded")
contextBridge.exposeInMainWorld('electronAPI', {
    changeTo : (filename) => {ipcRenderer.send('changeFile', filename)}
})
