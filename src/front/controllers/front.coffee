class FrontController
  @$inject = ['$scope', '$state']

  constructor: (@scope, @state) ->
    @scope.page = @state.current.name
    @scope.isOnPage = @isOnPage

  isOnPage: (page) =>
    page == @state.current.name

module.exports = FrontController
