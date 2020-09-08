import { upload_with_progress, addErrorMessagesFrom, makeRequest } from "./shared.js"

function issueFormData() {
  var formData = new FormData()
  formData.append("issue[name]", document.querySelector("input[name='issue[name]']").value)
  formData.append("issue[note]", document.querySelector("textarea[name='issue[note]']").value)
  formData.append("issue[priority]", document.querySelector("select[name='issue[priority]']").value)
  formData.append("issue[issue_id]", document.querySelector("input[name='issue[issue_id]']").value)
  // formData.append("issue[project_id]", document.querySelector("input[name='issue[project_id]']").value)
  return formData
}

var newIssuePage = document.getElementById("new-issue-page")
var editIssuePage = document.getElementById("edit-issue-page")

//form
if (newIssuePage || editIssuePage) {
  let issue_id = document.querySelector("input[name='issue[issue_id]']").value

  document.forms.issue.file.onchange = function () {
    var files = this.files
    if (files.length > 10) {
      alert("Only 10 files accepted.");
      // e.preventDefault();
      return false;
    }
    upload_with_progress(files, issue_id, "Issue")
  }

  document.forms.issue.onsubmit = function (e) {
    makeRequest("PATCH", "/issues/" + issue_id, issueFormData())
      .then((response) => {
        var parsedResponse = JSON.parse(response)

        if (parsedResponse.status == "success") {
          window.location.href = "/issues/" + issue_id
        } else if (parsedResponse.status == "error") {
          addErrorMessagesFrom(parsedResponse)
        }
      })
    return false;
  }
}
