// This is a polyfill for FireFox and Safari
if (!WebAssembly.instantiateStreaming) {
    WebAssembly.instantiateStreaming = async (resp, importObject) => {
        const source = await (await resp).arrayBuffer()
        return await WebAssembly.instantiate(source, importObject)
    }
}

// Promise to load the wasm file
function loadWasm(path) {
    const go = new Go()

    return new Promise((resolve, reject) => {
        WebAssembly.instantiateStreaming(fetch(path), go.importObject)
            .then(result => {
                go.run(result.instance)
                resolve(result.instance)
            })
            .catch(error => {
                reject(error)
            })
    })
}

// Load the wasm file
loadWasm("/static/main.wasm").then(wasm => {}).catch(error => {
    console.log("web-assambly loading error: ", error)
})