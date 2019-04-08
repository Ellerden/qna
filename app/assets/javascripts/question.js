$(document).on('turbolinks:load', function(){
  $('.question').on('ajax:success', function(e, xhr) {
    var score = xhr['score'];
    e.preventDefault();
    $('.question-vote').find('.score').text(score);
  });
});
