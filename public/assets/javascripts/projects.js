import { upload_with_progress, addErrorMessagesFrom, makeRequest } from "./shared.js"

function projectFormData() {
  let formData = new FormData()
  formData.append("project[name]", document.querySelector("input[name='project[name]']").value)
  formData.append("project[note]", document.querySelector("textarea[name='project[note]']").value)
  formData.append("project[priority]", document.querySelector("select[name='project[priority]']").value)
  formData.append("project[project_id]", document.querySelector("input[name='project[project_id]']").value)
  return formData
}

var newProjectPage = document.getElementById("new-project-page")
var editProjectPage = document.getElementById("edit-project-page")

//edit project
if (newProjectPage || editProjectPage) {
  let project_id = document.querySelector("input[name='project[project_id]']").value
  
  document.forms.project.file.onchange = function () {
    var files = this.files
    if (files.length > 10) {
      alert("Only 10 files accepted.");
      // e.preventDefault();
      return false;
    }    
    upload_with_progress(files, project_id, "Project")
  }

  document.forms.project.onsubmit = function (e) {
    // e.preventDefault()
    makeRequest("PATCH", "/projects/" + project_id, projectFormData())
      .then((response) => {
        var parsedResponse = JSON.parse(response)

        if (parsedResponse.status == "success") {
          window.location.href = "/projects/" + project_id
        } else if (parsedResponse.status == "error") {
          addErrorMessagesFrom(parsedResponse)
        }
      })
    return false;
  }
}
