angular.module("tde.code-editor", [])

.controller("CodeEditorCtrl", function($scope, Asset)
{
  $scope.code = ($scope.assetId in Asset.assets) ? Asset.assets[$scope.assetId] : "loading..."
  $scope.$on("assetLoaded", function(event, assetId)
  {
    $scope.code = Asset.assets[$scope.assetId]
  })
  
  $scope.error = null
  
  $scope.updateAsset = function(callback)
  {
    Asset.updateAsset($scope.assetId, $scope.code, function(err)
    {
      if (callback)
        callback(err)
    })
  }
})

.directive("tdeCodeEditor", function()
{
  return {
    restrict: "E",
    controller: "CodeEditorCtrl",
    templateUrl: "/tde/code-editor/code-editor.html",
    link: function($scope, element, attrs)
    {
      $scope.error = null
      
      var editor = CodeMirror(element.find(".codemirror-wrapper").get(0), {
        mode: attrs.language,
        matchBrackets: true,
        lineNumbers: true,
        theme: "monokai",
        value: $scope.code
      })
      
      $scope.$watch("code", function(code)
      {
        if (code != editor.getValue())
        {
          console.log("setValue!!!")
          editor.setValue(code)
        }
      })
      
      element.keypress(function(event)
      {
        if (event.ctrlKey && (event.keyCode == 13 || event.keyCode == 10))
        {
          $scope.$apply(function()
          {
            var code = editor.getValue()
            
            // ignore if not modified
            if (code == $scope.code)
              return
            
            $scope.code = code
            try
            {
              $scope.updateAsset(function(err)
              {
                if (err)
                {
                  $scope.error = err.error.message
                }
                else
                {
                  $scope.error = null
                }
              })
            }
            catch (err)
            {
              $scope.error = err.message
            }
          })
        }
      })
    }
  }
})
