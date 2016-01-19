//refile JS library: showing the user what is going on + submit button

//on choosing file progress bar shows up and submit button gets disabled
$(document).on("upload:start", ".refile_form", function(e) {
	$(".refile_form").find("input[type=submit]").show();
  	$(this).find("input[type=submit]").attr("disabled", true);
  	$("#progresspercent").show();
  	$("#progresspercent").text("Uploading...");
	});

//showing progress to users
$(document).on("upload:progress", ".refile_form", function(e) {
    var detail;
    var percentComplete;
    var filename;
    filename = $('.choosefile').val();
    detail = e.originalEvent.detail;
    percentComplete = Math.round(detail.progress.loaded / detail.progress.total * 100);
    $('#progresspercent').text(percentComplete + "% uploaded " + filename );
});

//when upload is reday user gets allowed to submit the message
$(document).on("upload:success", ".refile_form", function(e) {
    if (!$(this).find("input.uploading").length) {
      $(this).find("input[type=submit]").removeAttr("disabled");
      //$(".removecheck").show();
    };
});

//when file upload submitted file form is set back to its default form
$(document).on('click', '.btn-submit-refile', function() {
	$(".refile_form").find("input[type=submit]").hide();
	$('.choosefile').val("");
	$('#progresspercent').hide();
});

