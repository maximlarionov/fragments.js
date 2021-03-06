//= require utils

$ ->
  $(document).on "ajax:complete", "[data-behavior=\"fragments\"]", (e, xhr) ->
    $response = $(xhr.responseText)
    # from bottom to top: nested elements first, matched last
    $fragments = $response.findAndFilter("[data-fragment-id]")

    $fragments.each (i, element) ->
      $element = $(element)

      fragmentId = $element.attr("data-fragment-id")
      fragmentSelector = "[data-fragment-id=\"#{fragmentId}\"]"
      $fragmentContainer = $(fragmentSelector)

      $newContent = $element.contents()
      $oldContent = $fragmentContainer.contents().detach()

      $fragmentContainer
        .html($newContent)
        .trigger("fragment:update", [$newContent, $oldContent, xhr])

      # IE9 doesn't repaint necessary elements after `.html()`.
      # Repaint can be forced by accessing calculated properties, by
      # manipulating element's classes or by toggling element's visibility.

      # However, IE9 seems to be 'clever' enough, so only adding empty
      # class to `body` does the job.
      $("body")[0].className += ''
