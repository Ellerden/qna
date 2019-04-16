$(document).on('turbolinks:load', function(){
  $('.question').on('ajax:success', function(e, xhr) {
    var score = xhr['score'];
    e.preventDefault();
    $('.question-vote').find('.score').text(score);
  });

App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('Question connected');
      this.perform('follow');
    },
    received: function(data) {
      $('.questions-list').append(data);
    }
  });
});
