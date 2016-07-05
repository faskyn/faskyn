//adjust revenue and explanation text to revenue type on selecting
$(document).on('change', '[data-behavior="revenue-type-select"]', function (event) {
  if ($(this).val() === "no revenue") {
    $('[data-behavior="revenue-number-select').prop("selectedIndex", 3);
    $('[data-behavior="revenue-explanation"]').html("");
  } 
  else if ($(this).val() === "recurring revenue") {
    if ($('[data-behavior="revenue-number-select"]').val() === "$0") {
      $('[data-behavior="revenue-number-select"]').prop("selectedIndex", 0);
    };
    $('[data-behavior="revenue-explanation"]').html("ARR (annual recurring revenue)");
  }
  else if ($(this).val() === "non-recurring revenue") {
    if ($('[data-behavior="revenue-number-select"]').val() === "$0") {
      $('[data-behavior="revenue-number-select"]').prop("selectedIndex", 0);
    };
    $('[data-behavior="revenue-explanation"]').html("AR (annual revenue)");
  };
});

//adjust revenue type and explanation to revenue on selecting
$(document).on('change', '[data-behavior="revenue-number-select"]', function (event) {
  if ($(this).val() === "$0") {
    $('[data-behavior="revenue-type-select').prop("selectedIndex", 2);
    $('[data-behavior="revenue-explanation"]').html("");
  }
  else if ($(this).val() != "$0" && $('[data-behavior="revenue-type-select').val() === "no revenue") {
    $('[data-behavior="revenue-type-select').prop("selectedIndex", 0);
    $('[data-behavior="revenue-explanation"]').html("ARR (annual recurring revenue)");
  };
});

//on choosing file progress bar shows up and submit button gets disabled
$(document).on("upload:start", '[data-behavior="company-form"]', function(e) {
  //$(this).find("input[type=submit]").show();
  $(this).find('[data-behavior="company-submit-button"]').attr("disabled", true);
  $('[data-behavior="company-file-upload-progress"]').show();
  $('[data-behavior="company-file-upload-progress"]').text("Uploading...");
});

//showing progress to users
$(document).on("upload:progress", '[data-behavior="company-form"]', function(e) {
    var filename = $('[data-behavior="new-company-file"]').val();
    var detail = e.originalEvent.detail;
    var percentComplete = Math.round(detail.progress.loaded / detail.progress.total * 100);
    $('[data-behavior="company-file-upload-progress"]').text(percentComplete + "% uploaded ");
});

//when upload is ready user gets allowed to submit the message
$(document).on("upload:success", '[data-behavior="company-form"]', function(e) {
  if (!$(this).find("input.uploading").length) {
    $(this).find('[data-behavior="company-submit-button"]').attr("disabled", false);
  };
});

// //when file upload submitted file form is set back to its default form
// $(document).on('click', '[data-behavior="message-upload-submit"]', function() {
//   $('[data-behavior="message-upload-form"]').find("input[type=submit]").hide();
//   $('[data-behavior="new-message-file"]').val("");
//   $('[data-behavior="message-upload-progress"]').hide();
// });
