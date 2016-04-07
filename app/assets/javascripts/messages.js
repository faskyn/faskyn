//refile JS library: showing the user what is going on + submit button

//on choosing file progress bar shows up and submit button gets disabled
$(document).on("upload:start", ".message-refile-form", function(e) {
	$(".message-refile-form").find("input[type=submit]").show();
  	$(this).find("input[type=submit]").attr("disabled", true);
  	$("#message-progresspercent").show();
  	$("#message-progresspercent").text("Uploading...");
	});

//showing progress to users
$(document).on("upload:progress", ".message-refile-form", function(e) {
    var detail;
    var percentComplete;
    var filename;
    filename = $('.choose-message-file').val();
    detail = e.originalEvent.detail;
    percentComplete = Math.round(detail.progress.loaded / detail.progress.total * 100);
    $('#message-progresspercent').text(percentComplete + "% uploaded " + filename );
});

//when upload is ready user gets allowed to submit the message
$(document).on("upload:success", ".message-refile-form", function(e) {
    if (!$(this).find("input.uploading").length) {
      $(this).find("input[type=submit]").removeAttr("disabled");
    };
});

//when file upload submitted file form is set back to its default form
$(document).on('click', '.btn-submit-refile', function() {
	$(".message-refile-form").find("input[type=submit]").hide();
	$('.choose-message-file').val("");
	$('#message-progresspercent').hide();
});

