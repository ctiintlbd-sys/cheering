const fs = require('fs');

fetch("https://api.figma.com/v1/files/Fc03PPDFTz7D0nrTEQj0ah", {
    headers: {
        'X-Figma-Token': 'figd_nofETWfHwObCLwsogli1FvzhpzvyZcWJJJ5pPnBt'
    },
    signal: AbortSignal.timeout(10000)
})
.then(res => res.json())
.then(data => {
    fs.writeFileSync('figma_data_full.json', JSON.stringify(data, null, 2));
    console.log("Success full file!");
})
.catch(err => console.error("Error:", err.message));
