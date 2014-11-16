$(document).on('ready page:load', function()
{
  for(var i=0; i<$('#survey_count').val(); i++) {
    $("#pie-" + i).sparkline([$("#pie-" + i).data("yes"),$("#pie-" + i).data("maybe"),$("#pie-" + i).data("no"),$("#pie-" + i).data("empty")], {
      type: 'pie',
      width: '50px ',
      height: '50px',
      sliceColors: ['#58ACFA', '#F5DA81','#FA5858', '#D0D0D0']
    });
  }
});