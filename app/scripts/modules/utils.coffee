angular
  .module('utils', [])
  .service 'AnimFrame', ($window)->
    this.cancel = (->
      return $window.cancelAnimationFrame or $window.webkitCancelRequestAnimationFrame or clearTimeout
    )().bind($window)    
    this.request = (->
      return  $window.requestAnimationFrame or $window.webkitRequestAnimationFrame or (callback, element)-> 
        return $window.setTimeout(callback, 1000 / 60);
    )().bind($window)
  .service 'utils', ()->
    bLength = (str)->
      return 0 if not str
      aMatch = str.match(/[^\x00-\xff]/g)
      return str.length + (aMatch?.length or 0)

    getLength = (str)->
      max = 1000
      surl = 20
      tmp = str
      urls = str.match(/(http|https):\/\/[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\$\.\+\!\*\(\)\/\,\:;@&=\?~#%]*)*/gi) or []
      urlCount = 0
      urls.forEach (item, i)->
        count = bLength(item)
        urlCount += if count <= max then surl else count - max + surl
        tmp = tmp.replace(urls[i], "")
      return Math.ceil((urlCount + bLength(tmp)) / 2)

    this.letterCounter = (str, limit)->
      num = getLength(str)
      onum = Math.abs(limit - num)
      if num > limit or num < 1
        result = {
          letterNum: num
          vnum: onum
          overflow: true
        }
      else if num is 0
        reslut = {
          letterNum: num
          vnum: onum
          overflow: true
        }
      else
        result = {
          letterNum : num,
          vnum : onum,
          overflow : false
        }
      return result

    this.getIntervalTime = (startTime)->
      sTime = new Date(startTime.replace(/\-/g, "/"))
      eTime = new Date()
      diffTime = eTime.getTime() - sTime.getTime()
      second = 1000
      minute = 1000 * 60
      hour = 1000 * 3600
      day = 1000 * 3600 * 24

      if diffTime < second
        time = '刚刚'
      else if diffTime < minute
        time = parseInt(diffTime / parseInt(second)) + '秒前'
      else if diffTime < hour
        time = parseInt(diffTime / parseInt(minute)) + '分钟前'
      else if diffTime < day
        time = parseInt(diffTime / parseInt(hour)) + '小时前'
      else 
        time = startTime.split(' ')[0]
      return time

    return
