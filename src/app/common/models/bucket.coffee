`// @ngInject`
angular.module('cobudget').factory 'BucketModel',  (ContributionModel, AuthService) ->
  class BucketModel
    constructor: (data = {}) ->
      @id = data.id
      @name = data.name
      @description = data.description
      @percentageFunded = data.percentage_funded
      @contributionTotalCents = data.contribution_total_cents
      @targetCents = data.target_cents
      @contributions = _.map data.contributions, (contribution) ->
        # attach bucket_id to contribution, as the data
        # returned from the API does not have this
        contrib = _.extend(_.clone(contribution), bucket_id: data.id)
        new ContributionModel(contrib)

    getMyContribution: (currentUserId) ->
      @myContribution = (_.find @contributions, (contribution) ->
        contribution.user.id == currentUserId
      ) or new ContributionModel({
        user_id: currentUserId
        bucket_id: @id
        amount_cents: 0
      })

    getMyContributionPercentage: () ->
      @myContributionPercentage = (@myContribution.amountCents / @targetCents) * 100

    getGroupContribution: () ->
      @groupContributionPercentage = @percentageFunded - @myContributionPercentage
      @groupContributionCents = @contributionTotalCents - @myContribution.amountCents