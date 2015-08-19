'use strict'

###*
 # @ngdoc service
 # @name bbsApp.values
 # @description
 # # values
 # Service in the bbsApp.
###
angular.module('bbsApp')
  .value('shareDefault',{
    wxtext : '哈哈哈哈哈',
    photo : '',
    text : "",
    wxtitle : "哈哈哈哈哈",
    wxthumb : "",
    before : angular.noop
    after : angular.noop
    action : false
  })
  .value('urls',{
    bullshits: 
      'new': ''
      'hot': ''
    wishes:
      'new': ''
      'hot': ''
  })