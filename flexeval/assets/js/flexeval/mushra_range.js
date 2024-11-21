$(document).ready(function(){

    $("input[type=range]").map(function() {
      // Get output element with for pointing to this input
      var output_element = $("output[for='"+$(this).attr("id")+"']");

      // Read value on change
      $(this).on("mouseleave change click",function(){
        $(this).popover('dispose');
        mushra_score = $(this).val()
        if(mushra_score > 80)
        {
          label = "Excellent"
        }else if(mushra_score > 60)
        {
          label = "Good"
        }
        else if(mushra_score > 40)
        {
          label = "Fair"
        }
        else if(mushra_score > 20)
        {
          label = "Poor"
        }
        else {
          label = "Bad"
        }
        output_element.val(label+" ("+mushra_score+")");
        $(this).attr("data-content",label+" ("+mushra_score+")");
        $(this).popover('update');
        $(this).popover('toggle');
      });

      }).get()
    .join();

});