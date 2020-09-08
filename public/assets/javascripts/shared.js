export function makeRequest(method, url, formData) {
  return new Promise(function (resolve, reject) {
    var xhr = new XMLHttpRequest();
    xhr.open(method, url, true);
    
    xhr.onload = function () {
      if (this.status >= 200 && this.status < 300) {
        resolve(xhr.response);
      } else {
        reject({
          status: this.status,
          statusText: xhr.statusText
        });
      }
    };
    xhr.onerror = function () {
      reject({
        status: this.status,
        statusText: xhr.statusText
      });
    };
    xhr.send(formData);
  });
}


export function addErrorMessagesFrom(response) {
  console.log(response)
  // var alertMessage = "There're some errors preventing this project from being created: " + "<br>"
  var errors = response.errors
  Object.keys(errors).forEach(key => {
    var field = key + "-field"
    var feedback = key + "-field-feedback"

    document.getElementById(feedback).innerText = errors[key].join(", ")
    document.getElementById(field).classList.add("is-invalid")
    document.getElementById(field).addEventListener("focus", ((e) => {
      e.target.classList.remove("is-invalid")
    }), false)
  })
}


export function upload_with_progress(files, uploadable_id, uploadable_type) {
  let uploadsContainer = document.querySelector(".uploads")
  var counter = 1
  Array.from(files).forEach(function (file) {

    uploadsContainer.insertAdjacentHTML('beforeend', `
    <div class="upload mb-3" id="upload_${counter}">\
      <a class="delete-uploaded-link" href="" data-confirm="Are you sure?" data-method="delete">
        <i class="far fa-trash-alt" style="color: #e11d1d;" aria-hidden="true"></i>
      </a>\
      <span>\
        <a class="uploaded-link" href="">${file.name}<a>\
      </span>\
      <br>\
      <div class="progress">\
        <div class="progress-bar progress-bar-striped progress-bar-animated" id="upload_${counter}" role="progressbar" style="width: 0%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">0%</div>\
      </div>
    </div>`)

    upload(file, counter, uploadable_id, uploadable_type)
    counter += 1
  })
}

// upload a file 
export function upload(file, counter, uploadable_id, uploadable_type) {
  console.log(uploadable_type)

  var xhr = new XMLHttpRequest()
 
  var selector = "#upload_" + counter + " .progress-bar"

  // обработчик для отправки

  xhr.upload.onprogress = function (event) {
    let percent = ((event.loaded / event.total) * 100)

    document.querySelector(selector).innerText = parseInt(percent) + "%"
    document.querySelector(selector).style.width = percent + "%"
  }

  // обработчики успеха и ошибки
  // если status == 200, то это успех, иначе ошибка
  xhr.onload = xhr.onerror = function () {
    if (this.status == 200) {
      file = JSON.parse(this.response)
      // console.log("success")
      // console.log("#upload_" + counter + " .uploaded-link")
      document.querySelector("#upload_" + counter + " .uploaded-link").href = `${window.location.protocol}//${window.location.hostname}:${window.location.port}${file.path}`
      document.querySelector("#upload_" + counter + " .delete-uploaded-link").href = `${window.location.protocol}//${window.location.hostname}:${window.location.port}/uploads/${file.upload.id}`
      
      
    } else {
      console.log("error " + this.status)
    }"#upload_" + counter 
  };


  xhr.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      console.log("counter", counter)
      // console.log("counter", files_count)
      // console.log(uploadable_type)
      // if (counter == files_count) {
        // if (uploadable_type == "Project") {

        
        // var s = String(uploadable_type).toLowerCase()
        // window.location.href = "/" + s + "s" + "/" + uploadable_id
        // } else if (uploadable_type == "Issue") { 
        //   window.location.href = "/issues/" + uploadable_id
        // }


      // }
    }
  }


  console.log(file)
  xhr.open("POST", "/uploads", true);
  var fd = new FormData();
  fd.append("uploadable_id", uploadable_id)
  fd.append("uploadable_type", uploadable_type)
  // fd.append("uploadable_type", uploadable_type)
  fd.append("file", file)
  xhr.send(fd)
}    


