import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="audio-recorder"
//
// Records microphone audio with MediaRecorder, drops the recording into a hidden
// file input, and submits the surrounding Turbo form. Turbo handles CSRF + the
// redirect, so there is no manual fetch here.
export default class extends Controller {
  static targets = ["button", "status", "input", "form"];
  static values = {
    startLabel: String,
    stopLabel: String,
    recordingLabel: String,
    deniedLabel: String,
  };

  connect() {
    this.recording = false;
    this.chunks = [];
    this.setButtonLabel(this.startLabelValue);
  }

  disconnect() {
    this.releaseStream();
  }

  toggle() {
    if (this.recording) {
      this.stop();
    } else {
      this.start();
    }
  }

  async start() {
    try {
      this.stream = await navigator.mediaDevices.getUserMedia({ audio: true });
    } catch (error) {
      this.setStatus(this.deniedLabelValue);
      return;
    }

    this.chunks = [];
    this.recorder = new MediaRecorder(this.stream);
    this.recorder.addEventListener("dataavailable", (event) => {
      if (event.data.size > 0) this.chunks.push(event.data);
    });
    this.recorder.addEventListener("stop", () => this.submitRecording());
    this.recorder.start();

    this.recording = true;
    this.setButtonLabel(this.stopLabelValue);
    this.setStatus(this.recordingLabelValue);
  }

  stop() {
    if (!this.recorder) return;
    this.recording = false;
    this.recorder.stop();
    this.releaseStream();
  }

  submitRecording() {
    const mimeType = this.recorder.mimeType || "audio/webm";
    const blob = new Blob(this.chunks, { type: mimeType });
    const file = new File([blob], `recording.${this.extensionFor(mimeType)}`, {
      type: mimeType,
    });

    const transfer = new DataTransfer();
    transfer.items.add(file);
    this.inputTarget.files = transfer.files;

    this.formTarget.requestSubmit();
  }

  extensionFor(mimeType) {
    if (mimeType.includes("mp4")) return "mp4";
    if (mimeType.includes("ogg")) return "ogg";
    if (mimeType.includes("wav")) return "wav";
    return "webm";
  }

  releaseStream() {
    this.stream?.getTracks().forEach((track) => track.stop());
    this.stream = null;
  }

  setButtonLabel(label) {
    if (this.hasButtonTarget) this.buttonTarget.textContent = label;
  }

  setStatus(message) {
    if (this.hasStatusTarget) this.statusTarget.textContent = message;
  }
}
