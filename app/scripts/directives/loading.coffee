'use strict'

###*
 # @ngdoc directive
 # @name bbsApp.directive:loading
 # @description
 # # loading
###
angular.module('bbsApp')
  .directive('loading', ($rootScope)->
    template: """
    <div class="m-loading">
      <div class="box-mask"></div>
      <div class="loading">
        <div class="box-bd">
          <div class="m-loading-spinner">
            <span class="loading-top"></span> <span class="loading-right"></span> <span class="loading-bottom"></span> <span class="loading-left"></span>
          </div>
          <div class="msg">正在加载</div>
        </div>
      </div>
    </div>
    """
    replace: true
    restrict: 'EA'
    link: (scope, element, attrs) ->
      $rootScope.$on 'Netease_loading_start', ->
        element.addClass('show')
      $rootScope.$on 'Netease_loading_end', ->
        element.removeClass('show')
  )
