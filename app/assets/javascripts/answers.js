$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('.answer-vote').on('ajax:success', function(e, xhr) {
    e.preventDefault();
    var score = xhr['score'];
    var answerId = $(this).parent().data('aid');
    $('.answer_' + answerId).find('.score').text(score);
  });
});
