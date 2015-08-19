'use strict'

###*
 # @ngdoc service
 # @name bbsApp.bullshits
 # @description
 # # bullshits
 # 吐槽区 
###
angular.module('bbsApp')
  .service 'BullshitsService', ($q, utils)->
    this.getList = ()->
      defer = $q.defer()
      list = [
        {
          id: 1
          username: '用户名'
          avatar: 'http://imgm.ph.126.net/upqEcR9XingwjtjcCVnciw==/1598214917863119520.jpg'
          time: '2014-12-14 21:33:09.0'
          title: '标题，你这是在装逼 你这是在装逼 你这是在装逼 你这是在装逼 你这是在装逼 '
          body: '正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文'
          reply: 123
          top: 1
          help: 1
        }
        {
          id: 2
          username: '用户名'
          avatar: 'http://imgm.ph.126.net/upqEcR9XingwjtjcCVnciw==/1598214917863119520.jpg'
          time: '2014-12-14 21:33:09.0'
          title: '标题，你这是在装逼 '
          body: '正文正文正文'
          reply: 123
          top: 1
          help: 1
        }
      ]
      list.forEach (item)->
        item.time = utils.getIntervalTime(item.time)

      defer.resolve(list)

      return defer.promise

    return
