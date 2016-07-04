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
