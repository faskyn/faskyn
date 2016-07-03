$(document).on('change', '[data-behavior="revenue-type-select"]', function (event) {
  if ($(this).val() === "no revenue") {
    $('[data-behavior="revenue-number-select"]').append(new Option("$0", "$0"));
    $('[data-behavior="revenue-number-select"] option[value="$0"]').attr("selected", "selected").change();
    $('[data-behavior="revenue-number-select"]').prop("disabled", true);
  } 
  else {
    $('[data-behavior="revenue-number-select"] option[value="$0"]').remove();
    $('[data-behavior="revenue-number-select"]' ).prop("disabled", false);
  }
});