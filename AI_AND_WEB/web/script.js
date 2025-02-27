let model = null; 
function updatePrediction(result) {
    const resultElement = document.getElementById('result');
    resultElement.textContent = `Prediction: ${result}`;

    if (result === "Ready for Harvesting") {
        resultElement.classList.remove('not-ready');
        resultElement.classList.add('ready');
    } else {
        resultElement.classList.remove('ready');
        resultElement.classList.add('not-ready');
    }
}

document.getElementById('load-model').addEventListener('click', async () => {
    try {
        model = await tf.loadLayersModel('http://localhost:8080/model.json'); 
        alert('Model loaded successfully!');
    } catch (error) {
        console.error('Error loading the model:', error);
        alert('Failed to load the model. Check the server and path.');
    }
});

document.getElementById('predict').addEventListener('click', async () => {
    if (!model) {
        alert('Model not loaded. Please load the model first.');
        return;
    }

    const fileInput = document.getElementById('upload-image');
    if (fileInput.files.length === 0) {
        alert("Please choose an image");
        return;
    }

    const file = fileInput.files[0];
    const reader = new FileReader();
    reader.onload = async function () {
        const img = new Image();
        img.src = reader.result;
        img.onload = async function () {
            const canvas = document.getElementById('uploaded-image');
            const ctx = canvas.getContext('2d');
            canvas.width = 150;
            canvas.height = 150;
            ctx.clearRect(0, 0, canvas.width, canvas.height); 
            ctx.drawImage(img, 0, 0, 150, 150);

            try {

                let tensor = tf.browser.fromPixels(canvas)
                    .toFloat()
                    .div(tf.scalar(255.0))
                    .expandDims();
                const prediction = model.predict(tensor);
                const predictionArray = await prediction.array();

                const rawPrediction = predictionArray[0][0];
                const binaryResult = rawPrediction > 0.5 ? 1 : 0;
                const result = binaryResult === 1 ? "Ready for Harvesting" : "Not Ready for Harvesting";
                updatePrediction(result);
                document.getElementById('binary-result').innerText = `Binary Result: ${binaryResult}`;
                document.getElementById('raw-prediction').innerText = `Raw Prediction: ${rawPrediction.toFixed(4)}`;
                const formData = new FormData();
                formData.append('prediction', binaryResult);

                fetch('/SmartHarvest/AI_AND_WEB/web/save_prediction.php', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    console.log(data);
                    alert(data.message);
                })
                .catch(error => {
                    console.error('Error storing prediction:', error);
                    alert('Failed to store the prediction.');
                });

                tensor.dispose();
                prediction.dispose();
            } catch (err) {
                console.error('Error during prediction:', err);
                alert('Failed to make a prediction.');
            }
        };
    };
    reader.readAsDataURL(file);
});