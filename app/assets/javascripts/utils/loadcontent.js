var ChangedMe = function() {
  $('#reminder_template_id').on('change', function(event) {
      var Valore = $('#reminder_template_id').val();
      var Name = $("#reminder_name").val();
      $.get('../templates/' + Valore,function(content) {
      var content = $(content).find('div#ContentArea').html();
      var content_merged = content.split("#{name}").join(Name);
      $("#reminder_message").val(content_merged);
    });
  });
};
