@MemberData = flight.component ->
  @after 'initialize', ->
    return if not gon.current_user
    channel = @attr.pusher.subscribe("private-#{gon.current_user.sn}")

    channel.bind 'account', (data) =>
      gon.accounts[data.currency] = data
      @trigger 'account::update', gon.accounts

    channel.bind 'order', (data) =>
      @trigger "order::#{data.state}", data

    channel.bind 'trade', (data) =>
      @trigger 'trade::done', data

    # Initializing at bootstrap
    @trigger 'order::wait::populate', orders: gon.orders.wait
    @trigger 'trade::done::populate', orders: gon.orders.done.reverse()
    @trigger 'account::update', gon.accounts

