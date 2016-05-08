//refile JS library: showing the user what is going on + submit button

//on choosing file progress bar shows up and submit button gets disabled
$(document).on("upload:start", '[data-behavior="message-upload-form"]', function(e) {
	$(this).find("input[type=submit]").show();
	$(this).find("input[type=submit]").attr("disabled", true);
	$('[data-behavior="message-upload-progress"]').show();
	$('[data-behavior="message-upload-progress"]').text("Uploading...");
});

//showing progress to users
$(document).on("upload:progress", '[data-behavior="message-upload-form"]', function(e) {
    var detail;
    var percentComplete;
    var filename;
    filename = $('[data-behavior="new-message-file"]').val();
    detail = e.originalEvent.detail;
    percentComplete = Math.round(detail.progress.loaded / detail.progress.total * 100);
    $('[data-behavior="message-upload-progress"]').text(percentComplete + "% uploaded " + filename );
});

//when upload is ready user gets allowed to submit the message
$(document).on("upload:success", '[data-behavior="message-upload-form"]', function(e) {
    if (!$(this).find("input.uploading").length) {
      $(this).find("input[type=submit]").removeAttr("disabled");
    };
});

//when file upload submitted file form is set back to its default form
$(document).on('click', '[data-behavior="message-upload-submit"]', function() {
	$('[data-behavior="message-upload-form"]').find("input[type=submit]").hide();
	$('[data-behavior="new-message-file"]').val("");
	$('[data-behavior="message-upload-progress"]').hide();
});

