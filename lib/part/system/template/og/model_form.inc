
<Script>
  $(".calendar").calendar();    
</Script>

#{form_errors}

<form method="POST">
  #{attribute_controls @obj}
  
  <br /><br />
  #{submit_button "Create"}
</form>
