'use strict'

###*
 # @ngdoc directive
 # @name bbsApp.directive:carousel
 # @description
 # # carousel
###
angular.module('bbsApp')
  .directive 'carousel', (AnimFrame)->
    restrict: 'EA'
    replace: true
    template: """
      <div class="carousel">
        <ul class="list">
          <li class="item" ng-repeat="item in slides"><img ng-src="{{item}}"></li>
        </ul>
        <div class="process"></div>
      </div>
    """
    scope:{
      slides: '='
      option: '='
    }
    link: (scope, element, attrs)->
      option = scope.option or {}
      # el: 轮播元素  pEl: 进度元素
      el = angular.element element[0].querySelector('.list')
      pEl = angular.element element[0].querySelector('.process')
      isMoving = false
      moveTimeout = option.moveTimeout || 100
      moveDuration = option.moveDuration || 640
      moveRate = option.moveRate || 1.3
      itemWidth = option.itemWidth || 640
      index = 0
      itemLength = scope.slides.length
      totalWidth = itemWidth * itemLength
      el.css {width: totalWidth + 'px'}
      orientation = true
      lastMove = 0
      autoTimer = 0

      enablePrecess = option.enablePrecess
      enableAutorun = option.enableAutorun
      enableDrag = option.enableDrag

      onMove = option.onMove || angular.noop
      onFirst = option.onFirst || angular.noop
      onLast = option.onLast || angular.noop
      onTouchstart = option.onTouchstart || angular.noop
      onTouchend = option.onTouchend || angular.noop
      onTouchmove = option.onTouchmove || angular.noop

      bezier = 'cubic-bezier(0.075, 0.82, 0.165, 1)'

      drag = {
        moved: false,
        timer: 0,
        dirX: 0,
        distX: 0,
        dirY: 0,
        distY: 0,
        moveDistX: 0,
        maxMove: itemWidth/2,
        startTime: 0,
        endTime: 0,
        resetMaxMove: ()->
          drag.maxMove = itemWidth/2
          return
        reset: ()->
          drag.moved = false
          drag.isSwipe = false
          drag.dirX = 0
          drag.distX = 0
          drag.dirY = 0
          drag.distY = 0
          drag.timer = 0
          drag.timer and AnimFrame.cancel(drag.timer)
          return  
        move: ->
          return if not drag.moved
          mX = -index*itemWidth
          dx = Math.round(Math.abs(drag.distX)/moveRate)
          drag.moveDistX = dx

          if dx>itemWidth*9/10
            drag.endDrag()
            return
          else if drag.distX>0
            mX += dx
          else
            mX -= dx
          el.css {'-webkit-transform':'translate3d('+mX+'px,0,0)','-webkit-transition': '-webkit-transform 0ms '+bezier}
          lastMove = -mX
          return
        endDrag: ->
          drag.moved = false
          mX = -index*itemWidth
          dx = drag.moveDistX
          if drag.isSwipe
            if drag.distX>0 then pre() else next()
          else
            if drag.distX>0
              mX += dx
            else
              mX -= dx
            if mX >= 0 || mX <= -(totalWidth-itemWidth) || dx<drag.maxMove
              move()
            else
              if drag.distX > 0 then pre() else next()

          drag.reset()
          startAutoRun()
          return
      }

      touchStart = (e)->
        return if itemLength < 2 or isMoving
        drag.startTime = new Date().getTime()
        onTouchstart()
        autoTimer && clearInterval(autoTimer)
        drag.resetMaxMove()
        touch = e.touches[0]
        drag.moved = true
        drag.dirX = touch.pageX
        drag.distX = 0
        drag.dirY = touch.pageY
        drag.distY = 0
        animloop = ->
          if !drag.moved
            drag.reset()
            return
          
          drag.move()
          drag.timer = requestAnimationFrame(animloop)
        
        animloop()
        return
      touchMove = (e)->
        e.preventDefault()
        touch = e.touches[0]
        drag.distX = touch.pageX - drag.dirX
        drag.distY = touch.pageY - drag.dirY
        onTouchmove(Math.abs(drag.distX),Math.abs(drag.distY))
        return
      touchEnd = (e)->
        drag.endTime = new Date().getTime()
        if drag.moved
          drag.isSwipe = drag.endTime-drag.startTime<=200 && Math.abs(drag.distX)>30
          drag.endDrag()
        
        onTouchend(Math.abs(drag.distX),Math.abs(drag.distY))
        return

      if enableDrag
        el.touchstart = el.touchstart || touchStart
        el.touchmove = el.touchmove || touchMove
        el.touchend = el.touchend || touchEnd
        el.off('touchstart',el.touchstart)
        el.off('touchmove',el.touchmove)
        el.off('touchend',el.touchend)
        el.on('touchstart',el.touchstart)
        el.on('touchmove',el.touchmove)
        el.on('touchend',el.touchend)

      move = ->
        return if isMoving
        isMoving = true
        setTimeout ->
          isMoving = false
        , moveTimeout
        if index>itemLength-1
          index = itemLength-1
          onLast(index)
        else if index<0
          index = 0
          onFirst(index)
        _m = index*itemWidth
        _absm = Math.abs(lastMove-_m)
        _t = (moveDuration/itemWidth)*_absm
        animate = 'ease'

        if drag.isSwipe
          velocity = drag.moveDistX*moveRate/(drag.endTime-drag.startTime)
          _t = velocity*_absm
          animate = bezier

        lastMove = _m
        #修正android差1px的问题
        #_m = (_m>0&&$.os.android)?(_m+1):_m
        el.css({'-webkit-transform':'translate3d(-'+_m+'px,0,0)','-webkit-transition': '-webkit-transform '+_t+'ms '+animate});
        runProcess()
        onMove(index)

      next = ->
        return if isMoving
        index++
        move()
        return
      pre = ->
        return if isMoving
        index--
        move()

      reset = ->
        index = 0
        orientation = true
        stopAutoRun()
        el.css({'-webkit-transform':'translate3d(0,0,0)'})
        lastMove = 0
        drag.reset()
        pEl[0].style.display = 'none'
        renderProcess()
        startAutoRun()
      stopAutoRun = ->
        autoTimer && clearInterval(autoTimer)
        return
      moveOrientation = ->
        if index == itemLength-1
          orientation = false
        else if index == 0
          orientation = true
        
        if !orientation
          pre()
        else
          next()
        return
      
      startAutoRun = ->
        if enableAutorun && itemLength>1
          autoTimer = setInterval ->
            return if drag.moved #如果拖动就停止
            moveOrientation()
          ,3000

      renderProcess = ->
        if enablePrecess && itemLength>1
          tmp = []
          for num in [0...itemLength]
            tmp.push('<div></div>')
          pEl.html(tmp.join(''))
          pEl[0].style.display = 'block'
          runProcess()
          return
      runProcess = ->
        return if not enablePrecess
        processChild = pEl.find('div')
        processChild.removeClass('on')
        angular.element(processChild[index]).addClass('on')

      reset()


      return
