###*
 # @ngdoc function
 # @name bbsApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the bbsApp
###
angular.module('bbsApp')
  .controller 'MainCtrl', ($scope, BullshitsService) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
    $scope.option = {
      enableDrag: true
      enablePrecess: true
      itemWidth: 600
      moveDuration: 600
      enableAutorun: true
    }
    $scope.slides = [
      'http://img4.cache.netease.com/3g/2014/12/3/2014120311571331466.jpg'
      'http://img1.126.net/channel6/640370cc.jpg'
      'http://s.cimg.163.com/i/img6.cache.netease.com/3g/2014/12/3/2014120311334433397.jpg.320x196.jpg'
    ]

    $scope.tabs = [
      {
        class: 'bullshits'
        name: '吐槽区'
        template: 'views/partials/bullshits.html'
      }
      {
        class: 'wishes'
        name: '心愿墙'
        template: 'views/partials/wishes.html'
      }
    ]
    $scope.activedTab = $scope.tabs[0]
    $scope.changeTab = (index)->
      $scope.activedTab = $scope.tabs[index]
      return

    $scope.more = ->
      $scope.list.push({
        id: 1
        username: '用户名'
        avatar: 'http://imgm.ph.126.net/upqEcR9XingwjtjcCVnciw==/1598214917863119520.jpg'
        time: '2014-12-14 21:33:09.0'
        title: '标题，你这是在装逼 你这是在装逼 你这是在装逼 你这是在装逼 你这是在装逼 '
        body: '正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文正文'
        reply: 123
        top: 1
        help: 1
      }) 

    BullshitsService.getList().then (list)->
      $scope.list = list
      return

    return

