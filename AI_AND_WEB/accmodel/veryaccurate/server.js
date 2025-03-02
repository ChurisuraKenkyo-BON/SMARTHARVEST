const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = 8080;

app.use(cors());
app.use(express.static(path.join(__dirname)));

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
