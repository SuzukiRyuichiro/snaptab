import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="audio-recorder"
//
// Push-to-talk: hold the button to record, release to stop and submit. Recording
// is dropped into a hidden file input and the surrounding Turbo form is submitted,
// so Turbo handles CSRF + the redirect (no manual fetch here).
export default class extends Controller {
  static targets = ["button", "status", "input", "form"];
  static values = {
    holdLabel: String,
    recordingLabel: String,
    deniedLabel: String,
  };

  connect() {
    this.state = "idle"; // idle | acquiring | recording
    this.chunks = [];
    this.setStatus(this.holdLabelValue);
  }

  disconnect() {
    this.releaseStream();
  }

  // pointerdown
  async start(event) {
    event.preventDefault();
    if (this.state !== "idle") return;

    this.state = "acquiring";
    this.setRecordingUI(true);
    this.setStatus(this.recordingLabelValue);

    let stream;
    try {
      stream = await navigator.mediaDevices.getUserMedia({ audio: true });
    } catch (error) {
      this.reset();
      this.setStatus(this.deniedLabelValue);
      return;
    }

    // The button was released before the mic became available — discard.
    if (this.state !== "acquiring") {
      stream.getTracks().forEach((track) => track.stop());
      return;
    }

    this.stream = stream;
    this.chunks = [];
    try {
      this.recorder = new MediaRecorder(stream);
      this.recorder.addEventListener("dataavailable", (event) => {
        if (event.data.size > 0) this.chunks.push(event.data);
      });
      this.recorder.addEventListener("stop", () => this.submitRecording());
      this.recorder.start();
    } catch (error) {
      this.reset();
      this.setStatus(this.deniedLabelValue);
      return;
    }
    this.state = "recording";
  }

  // pointerup / pointerleave / pointercancel
  stop(event) {
    if (event) event.preventDefault();

    if (this.state === "acquiring") {
      // Mic not ready yet: cancel the pending start.
      this.reset();
      return;
    }
    if (this.state !== "recording") return;

    this.state = "idle";
    this.setRecordingUI(false);
    this.setStatus(this.holdLabelValue);
    this.recorder.stop(); // triggers submitRecording via the "stop" listener
    this.releaseStream();
  }

  prevent(event) {
    event.preventDefault();
  }

  submitRecording() {
    if (this.chunks.length === 0) return;

    const mimeType = this.recorder.mimeType || "audio/webm";
    const blob = new Blob(this.chunks, { type: mimeType });
    if (blob.size === 0) return;

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

  reset() {
    this.state = "idle";
    this.setRecordingUI(false);
    this.setStatus(this.holdLabelValue);
    this.releaseStream();
  }

  releaseStream() {
    this.stream?.getTracks().forEach((track) => track.stop());
    this.stream = null;
  }

  setRecordingUI(on) {
    if (!this.hasButtonTarget) return;
    this.buttonTarget.classList.toggle("btn-error", on);
    this.buttonTarget.classList.toggle("animate-pulse", on);
  }

  setStatus(message) {
    if (this.hasStatusTarget) this.statusTarget.textContent = message;
  }
}
