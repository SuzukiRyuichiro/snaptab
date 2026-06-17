import { Controller } from "@hotwired/stimulus";
import { Chart, Colors, ArcElement, PieController, Legend } from "chart.js";

// Connects to data-controller="breakdown-pie-chart"
export default class extends Controller {
  static values = {
    breakdown: Object,
  };

  connect() {
    Chart.register(Colors, PieController, ArcElement, Legend);

    const data = Object.values(this.breakdownValue).map(Number.parseFloat);
    const labels = Object.keys(this.breakdownValue);

    new Chart(this.element, {
      type: "pie",
      data: {
        datasets: [
          {
            data,
            hoverOffset: 4,
          },
        ],
        labels,
      },
    });
  }
}
