distance = require 'euclidean-distance'
chroma   = require 'chroma-js'
colors   = require './colornamer-colors'

module.exports = (color) ->
  color = chroma(color)
  results = colors.map((name) ->
    name.distance = distance(color.lab(), chroma(name.hex).lab())
    return name
  ).sort((a, b) ->
    return a.distance - (b.distance)
  )

  return results
