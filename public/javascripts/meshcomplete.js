$(function() {
  $("#meshcomplete").attr("value","").attr("size", 5);
  $("#meshcomplete-box").click(function(){  
    $("#meshcomplete").focus(); 
  });
  $("#meshcomplete-box .remove").live("click", function(){  
    $(this).parent().remove();
    if ($("#meshcomplete-box .operator").length >= $("#meshcomplete-box .selected").length) {
      $("#meshcomplete-box .operator").last().remove();
    }
  });
  $("#meshcomplete-clear").live("click", function(){  
    $("#meshcomplete-box .selected").each(function(index) { $(this).remove() });
    $("#meshcomplete-box .operator").each(function(index) { $(this).remove() });
  });
  $("#meshcomplete").bind('keyup keydown blur update', function(){
    if($("#meshcomplete").attr("size") < $("#meshcomplete").val().length){
      size = $("#meshcomplete").val().length + 5;
      $("#meshcomplete").attr("size",size);
    }
  });
  $("#meshcomplete").autocomplete({
    source: "/meshcomplete",
    select: function(e, ui) {
      var selected = ui.item.value,
          span = $("<span>").addClass("selected").text(selected);
      if ($("#meshcomplete-box .selected").length > 0) {
        var operator = $("<span>").addClass("operator").attr({
            }).html("AND").toggle(
              function () {
                $(this).html("OR");
              },
              function () {
                $(this).html("NOT");
              },
              function () {
                $(this).html("AND");
              }
            );
        operator.insertBefore("#meshcomplete");
      }
      var a = $("<a>").addClass("remove").attr({
              href: "javascript: return false;",
              title: "Remove " + selected
          }).html("&times;").appendTo(span);
      span.insertBefore("#meshcomplete");
      $("#meshcomplete").attr("value","").attr("size", 5);
      return false;
    },
    focus: function() {
      return false;
    }
  })
  .data( "autocomplete" )._renderItem = function( ul, item ) {
    var re_label = new RegExp("^" + this.term, "i");
    var re_entries = new RegExp("(^|\| )" + this.term, "gi");
    var label = item.label.replace(re_label, "<span class='matched'>$&" + "</span>");
    var entries = item.entries.join(" | ").replace(re_entries, "<span class='matched'>" + "$&" + "</span>");
    return $( "<li></li>" )
  	  .data( "item.autocomplete", item )
  	  .append("<a>" + label + "<div class='entry_term'>" + entries + "</div>" + "</a>")
  		.appendTo( ul );
  };
});
