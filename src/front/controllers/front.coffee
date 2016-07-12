class FrontController
  @$inject = ['$scope', '$state']

  constructor: (@scope, @state) ->
    @scope.page = @state.current.name
    # @scope.isOnPage = @isOnPage
    @scope.showMenu = false

    @scope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) =>
      @scope.showMenu = false
      @scope.page = @state.current.name

module.exports = FrontController
