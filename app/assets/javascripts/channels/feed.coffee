App.feed = App.cable.subscriptions.create "FeedChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#microposts').prepend '<li id="micropost-' + data.id + '">' + '<a href="/users/' + data.userid +          '">' + '<img alt="' + data.name + '" class="gravatar" src="https://secure.gravatar.com/avatar/'        + data.emaildigest + '?s=50">' + '</a>' +
          '<span class="user">' + '<a href="/users/' + data.userid + '">' + data.name + '</a>' + '</span>' + 
          '<span class="content">' + data.content + '</span>' + 
          '<span class="timestamp">' + 
            'Posted ' + jQuery.timeago(data.time) + ' ' +
            '<a class="delete" data-confirm="For real?" rel="nofollow" data-method="delete" href="/microposts/' + data.id + '">' + 'delete' + '</a>' +
          '</span>' + 
        '</li>'