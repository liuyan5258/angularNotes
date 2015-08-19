angular
  .module('newsappBridge', [])

  .service('device',function(){
    var ua = navigator.userAgent;
    this.isNewsApp = (/NewsApp/ig).test(navigator.userAgent);
    this.isWeiXin = (/MicroMessenger/ig).test(navigator.userAgent);
    this.isAndroid = navigator.userAgent.match(/android/ig);
    this.isIos = navigator.userAgent.match(/iphone|ipod|ipad/ig);
    this.isLatest = false; // 是否是4.1.0版本及以上

    try{
      var version = ua.match(/newsapp\/(.*)/i)[1];
      var versionNum = version.split('.');
      if(+versionNum[0] >= 4 && +versionNum[1] >= 1){
        this.isLatest = true;
      }
    }catch (e){
    }
  })

  .factory('userInfo',['$q','$window',function($q,$window){
    var userInfo = null;
    return {
      get : function(){
        var deferred = $q.defer();
        if(!!userInfo){
          deferred.resolve(userInfo);
        } else{
          $window.__newsapp_login_done = function(r){
            deferred.resolve(r);
          };
          window.__newsapp_login_canceled = function(r){
            deferred.resolve(false);
          };
          $window.__newsapp_userinfo_done = function(r){
            if(!!r){
              deferred.resolve(r);
            }
          };
          $window.location.href = 'userinfo://';
        }
        $window.location.href = 'login://';
        return deferred.promise;
      }
    }
  }])

  .factory('weixinJsBrige',['$window',function($window){
    var content = {
      newsappSharewxthumburl : '',
      newsappSharewxurl : '',
      newsappSharewxtext : '',
      appid : ''
    };
    var callback = function(){};
    function shareFriend() {
      $window.WeixinJSBridge.invoke('sendAppMessage',{
        "appid": content.appid,
        "img_url": content.newsappSharewxthumburl,
        "img_width": "200",
        "img_height": "200",
        "link": content.newsappSharewxurl,
        "desc": content.newsappSharewxtext,
        "title": content.newsappSharewxtext
      }, function(res) {
        callback();
      })
    }
    function shareTimeline() {
      $window.WeixinJSBridge.invoke('shareTimeline',{
        "img_url": content.newsappSharewxthumburl,
        "img_width": "200",
        "img_height": "200",
        "link": content.newsappSharewxurl,
        "desc": content.newsappSharewxtext,
        "title": content.newsappSharewxtext
      }, function(res) {
        callback();
      });
    }
    function shareWeibo() {
      $window.WeixinJSBridge.invoke('shareWeibo',{
        "content": content.newsappSharewxtext,
        "url": content.newsappSharewxurl
      }, function(res) {
        callback();
      });
    }
    return {
      init : function(){
        document.addEventListener('WeixinJSBridgeReady', function() {
          $window.WeixinJSBridge.on('menu:share:appmessage', function(argv){
            shareFriend();
          });
          $window.WeixinJSBridge.on('menu:share:timeline', function(argv){
            shareTimeline();
          });
          $window.WeixinJSBridge.on('menu:share:weibo', function(argv){
            shareWeibo();
          });
        }, false);
      },
      share : function(data,cb){
        !!cb && (callback = cb);
        angular.extend(content,data);
      }
    }
  }])

  .directive('share',['$compile',function($compile){
    var tpl = [];
    tpl.push('<div style="display:none" id="__newsapp_sharetext">{{text}}</div>');
    tpl.push('<div style="display:none" id="__newsapp_sharephotourl">{{photo}}</div>');
    tpl.push('<div style="display:none" id="__newsapp_sharewxtext">{{wxtext}}</div>');
    tpl.push('<div style="display:none" id="__newsapp_sharewxtitle">{{wxtitle}}</div>');
    tpl.push('<div style="display:none" id="__newsapp_sharewxurl">{{wxurl}}</div>');
    tpl.push('<div style="display:none" id="__newsapp_sharewxthumburl">{{wxthumb}}</div>');
    return {
      restrict: 'EA',
      scope: {
          text : '@',
          photo : '@',
          wxtext : '@',
          wxtitle : '@',
          wxurl : '@',
          wxthumb : '@',
          before : '&',
          after : '&',
          action : '@'
      },
      controller : ['$rootScope','$scope','$element','$attrs','$window',function($rootScope,$scope,$element,$attrs,$window){
        function share(){
          if(typeof $scope.before == 'function'){
            var before = $scope.before();
            if(!!before && typeof before.then == 'function'){
              before.then(function(){
                $window.location.href = 'share://';
              });
            }else {
              $window.location.href = 'share://';
            }
          }
          else{
            $window.location.href = 'share://';
          }
        }
        $window.__newsapp_share_done = function(r){
          if(typeof $scope.after == 'function'){
            $scope.after(r);
          }
          // $rootScope.$emit('NETEASE_shareEnd',r);
        };
        // $rootScope.$on('NETEASE_share',function(e,o){
        //   angular.extend($scope,o);
        //   share();
        // });
        $scope.$watch('action',function(n){
          if(n && typeof n == 'boolean'){
            share();
            $scope.action = false;
          }
        });

        $element.on('click',function(){
          share();
        });
      }],
      compile : function(){
        return {
          pre : function(scope,element,attrs){
            var el = angular.element(tpl.join(''));
            element.append(el);
            $compile(el)(scope);
          },
          post : function(){}
        }
      }
    }
  }])

  .directive('uploadPhoto',['$compile',function($compile){
    var iosTpl = '<iframe id="ifrfour" name="iosupload" style="display:none;"></iframe>'+
        '<form id="iosupload" action="{{returnurl}}" target="iosupload" enctype="multipart/form-data" method="POST" style="display:none;">'+
        '<input type="file" accept="image/*" name="abc" id="inputFile">'+
        '</form>';
    return {
      restrict: 'EA',
      scope: {
        width: "@?",
        height: "@?",
        after: "&",
        returnurl: "@"
      },
      controller: ['$scope','$rootScope','$window','device','$element',function($scope,$rootScope,$window,device,$element){
        $window.__newsapp_upload_image_done = function(r){
          if(typeof $scope.after == 'function'){
            $scope.after(r);
          }
          // $rootScope.$emit('NETEASE_photoEnd',r);
        };
        $window.iosReturn = $window.__newsapp_upload_image_done;
        // $rootScope.$on('NETEASE_camera',function(){
        //   upload('camera');
        // });
        // $rootScope.$on('NETEASE_album',function(){
        //   upload('album');
        // });
        function upload(type){
          if(device.isAndroid) {
            if(!!$scope.width && !!$scope.height){
              $window.location.href = 'uploadImage://' + type + '/' + $scope.width + '_' + $scope.height;
            } else{
              $window.location.href = 'uploadImage://' + type;
            }
          } else{
            var inputFile = document.querySelector('#inputFile'),
                iosupload = document.querySelector('#iosupload');
            inputFile.onchange=function(){
              var file=this.files[0];
              if (file && /image\/\w+/.test(file.type) ) {
                iosupload.submit();
              }
            };
            inputFile.click();
          }
        }
        this.upload = upload;
      }],
      compile : function(){
        return {
          pre : function(scope,element,attrs,ctrl){
            var el = angular.element(iosTpl);
            element.append(el);
            $compile(el)(scope);
          },
          post : function(){}
        }
      }
    }
  }])
  .directive('camera',[function(){
    return {
      restrict: 'EA',
      require: '^uploadPhoto',
      link: function(scope,element,attrs,ctrl){
        element.on('click',function(){
          ctrl.upload('camera');
        });
      }
    }
  }])
  .directive('album',[function(){
    return {
      restrict: 'EA',
      require: '^uploadPhoto',
      link: function(scope,element,attrs,ctrl){
        element.on('click',function(){
          ctrl.upload('album');
        });
      }
    }
  }])

  .directive('location',[function(){
    return {
      restrict: 'EA',
      scope: {
        after: "&"
      },
      controller: ['$window','$scope','$rootScope',function($window,$scope,$rootScope){
        $window.__newsapp_location_done = function(r){
          if(typeof $scope.after == 'function'){
            $scope.after(r);
          }
          // $rootScope.$emit('NETEASE_locationEnd',r);
        };
        // $rootScope.$on('NETEASE_current',function(){
        //   action('current');
        // });
        // $rootScope.$on('NETEASE_switch',function(){
        //   action('switch');
        // });
        function action(type){
          $window.location.href = "location://"+type;
        }
        this.action = action;
      }]
    }
  }])
  .directive('current',[function(){
    return {
      restrict: 'EA',
      require: '^location',
      link: function(scope,element,attrs,ctrl){
        element.on('click',function(){
          ctrl.action('current');
        });
      }
    }
  }])
  .directive('switch',[function(){
    return {
      restrict: 'EA',
      require: '^location',
      link: function(scope,element,attrs,ctrl){
        element.on('click',function(){
          ctrl.action('switch');
        });
      }
    }
  }]);

