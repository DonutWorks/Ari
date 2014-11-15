$(document).on('ready page:load', function()
{
  for(var i=1; i<$('#survey_count').val()+1; i++) {
    $("#pie-" + i).sparkline([$("#pie-" + i).data("yes"),$("#pie-" + i).data("maybe"),$("#pie-" + i).data("no"),$("#pie-" + i).data("empty")], {
      type: 'pie',
      width: '50px ',
      height: '50px',
      sliceColors: ['#738DE8', '#E8C073','#FFFFFF', '#D0D0D0']
    });
  }
});