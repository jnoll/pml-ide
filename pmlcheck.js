
var myCodeMirror;

$(document).ready(function() { 
  myCodeMirror = CodeMirror.fromTextArea(document.getElementById('editor'),{
      lineNumbers: true
      , styleActiveLine: true
      , matchBrackets: true
      , mode: "tcl"
      , electricChars: true
      , smartIndent: true
      , matchBrackets: true
  });

  $('#edit-form').submit(function(e){ submitContents(); return e.preventDefault(); });
  $('#compile').click(function(e){ 
	  //alert("compile"); 
	  $("#edit-form").submit(); return false; 
      });
  $('#upload-form').submit(function(e){ return uploadFile(); });
}());

function uploadFile() {
	  //alert("submitFile");
	  //var data = $('#upload-form').serialize();
    var data = new FormData($("#upload-form")[0]);
    //alert("submitFile: " + data);
    
    $.ajax({
	type: "POST",
	url: "cgi-bin/pmlcheck.cgi",
	data: data,
	async: false,
	cache: false,
	contentType: false,
	processData: false,
	success: handleFileResponse,
	dataType: "json",
	})
	.fail(function(e, status, msg) { alert("pmlcheck.js:upload-form:error: " + status + " : " + msg + " : " + e); })

	$("#myModal").modal("hide");
	return false; 
}

function submitContents() {
    //alert("submitContents");
    //var data = $('#editor').serialize();
    var data = myCodeMirror.getValue();
    var encoded = encodeURIComponent(data);
    //alert("submitContents: " + encoded + ":" + encoded.length);
    $.ajax({
	type: "POST",
	url: "cgi-bin/pmlcheck.cgi",
	data: "editedText=" + encoded,
	success: handleResponse,
	dataType: "json",
	})
	.fail(function(e, status, msg) { alert("consult.js:submitConsult:error: " + status + " : " + msg + " : " + e); })

    return false; 
}

function handleFileResponse(response) {
    var pml = response.input;
    //alert("handleFileResponse: pml=" + pml);
    myCodeMirror.setValue(pml);

    return handleResponse(response);
}

function handleResponse(response) { 
    //alert("response: " + response.results);
    target = $("#results");
    replacement = '<div id="results">';
    replacement += '<pre>';
    replacement += response.results;
    replacement += '</pre>';
    replacement += '</div';
    target.replaceWith(replacement);

    return false;
}

