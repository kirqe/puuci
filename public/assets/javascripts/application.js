import './projects.js';
import './issues.js';
import marked from 'marked';

document.addEventListener("DOMContentLoaded", (event) => {
  console.log(alert)
  let alert = document.querySelector(".alert")
  if (alert) {
    setTimeout(() => alert.remove(), 3000)
  }

  // MARKDOWN PREVIEW
  // input
  let name = document.getElementById("name-field");
  let note = document.getElementById("note-field");
  // markdown preview
  let preview = document.getElementById("md-preview")
  let preview_name = document.getElementById("md-preview-name");
  let preview_note = document.getElementById("md-preview-note");

  if (name || note) {
    name.addEventListener('input', function (e) {
      preview_name.innerHTML = e.target.value
    })

    note.addEventListener('input', function (e) {
      preview_note.innerHTML = marked(e.target.value)
    })

    if (name.value.length > 0 || note.value.length > 0) {
      preview_name.innerHTML = name.value
      preview_note.innerHTML = marked(note.value)

      preview.classList.remove("d-none")
    }
  }
  
  // CHART HOMEPAGE
  var chart = document.getElementById('myChart')
  if (chart) {
    var ctx = chart.getContext('2d');
    if (ctx) {
      var dt = document.querySelector('.tiles').dataset.chart;


      var projectNames = JSON.parse(dt).map((elem) => {
        return elem[0]
      })
      var issuesCount = JSON.parse(dt).map((elem) => {
        return elem[1]
      })

      new Chart(ctx, {
        // The type of chart we want to create
        type: 'doughnut',

        // The data for our dataset
        data: {
          labels: projectNames,
          datasets: [{
            backgroundColor: '#4490e1',
            data: issuesCount
          }]
        },

        // Configuration options go here
        options: {
          legend: {
            display: false,
          },
          title: {
            display: true,
            text: '# of issues by project'
          }
        }
      });

    }
  }
});



// MOSTLY BOOSTRAP JQ
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()

  $(".toast").toast('show')
  $('.toast').on('hidden.bs.toast', function () {
    this.toast('dispose')
  })
  $(".markdown-body img, #md-preview-note img").click(function () {
    $(this).toggleClass('full')
  });

})