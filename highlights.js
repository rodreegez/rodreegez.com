import highlights from './highlights.json'

const allHighlights = []

for(let highlight of highlights) {
  for(let quote of highlight.highlights) {
    allHighlights.push(quote)
  }
}

const randomHighlight = () => {
  let newHighlight = allHighlights[Math.floor(Math.random()*allHighlights.length)]
  newHighlight = newHighlight.trim()
  if(/[a-z]$/.test(newHighlight[0])) {
    newHighlight = `…${newHighlight}`
  }
  if(newHighlight[(newHighlight.length - 1)] === ',') {
    newHighlight = newHighlight.replace(/,$/,'…')
  }
  if(newHighlight[(newHighlight.length - 1)] === ';') {
    newHighlight = newHighlight.replace(/;$/,'…')
  }
  if(/[a-z]$/.test(newHighlight[(newHighlight.length - 1)])) {
    newHighlight = `${newHighlight}…`
  }
  return newHighlight
}

const refreshHighlight = () => {
  document.querySelector('#random-highlight').innerText = randomHighlight()
}

window.refreshHighlight = refreshHighlight

refreshHighlight()

