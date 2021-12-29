import highlights from './highlights.json'

const allHighlights = []

for(let highlight of highlights) {
  for(let quote of highlight.highlights) {
    allHighlights.push(quote)
  }
}

const randomHighlight = () => {
  return allHighlights[Math.floor(Math.random()*allHighlights.length)]
}

const refreshHighlight = () => {
  document.querySelector('#random-highlight').innerText = randomHighlight()
}

window.refreshHighlight = refreshHighlight

refreshHighlight()

