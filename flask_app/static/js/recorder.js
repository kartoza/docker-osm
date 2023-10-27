class Recorder {
    constructor(submitMessage, map) {
        this.mediaRecorder = null;
        this.audioChunks = [];
        this.options = { mimeType: 'audio/webm' };
        this.submitMessage = submitMessage;
        this.map = map;
        this.init();
    }

    async init() {
        try {
            const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
            if (!MediaRecorder.isTypeSupported(this.options.mimeType)) {
                console.error(`${this.options.mimeType} is not supported`);
                this.options.mimeType = ''; // Fallback to the default mimeType
            }
            this.mediaRecorder = new MediaRecorder(stream, this.options);
            this.setupEventListeners();
        } catch (err) {
            console.error("Could not get media stream:", err);
        }
    }

    setupEventListeners() {
        this.mediaRecorder.ondataavailable = event => {
            this.audioChunks.push(event.data);
        };

        this.mediaRecorder.onstop = async () => {
            try {
                const audioBlob = new Blob(this.audioChunks, { type: this.options.mimeType }); 
                const formData = new FormData();
                formData.append("audio", audioBlob);
                const response = await fetch('/audio', {
                    method: 'POST',
                    body: formData
                });
                const userMessage = await response.text();
                console.log("Audio uploaded:", userMessage);
                this.submitMessage(this.map, userMessage); 
                
            } catch (error) {
                console.error("Error uploading audio:", error);
            }
        };

        document.getElementById("startRecord").addEventListener("click", () => {
            if (this.mediaRecorder) {
                this.audioChunks = [];
                this.mediaRecorder.start();
            }
        });

        document.getElementById("stopRecord").addEventListener("click", () => {
            if (this.mediaRecorder) {
                this.mediaRecorder.stop();
            }
        });
    }
}

