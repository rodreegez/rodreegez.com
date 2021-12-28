import highlights from './highlights.json'

let allHighlights = []

for(let highlight of highlights) {
  for(let quote of highlight.highlights) {
    allHighlights.push(quote)
  }
}

let randomHighlight = allHighlights[Math.floor(Math.random()*allHighlights.length)]

document.querySelector('#random-highlight').innerText = randomHighlight
