import './style.css'

async function fetchPosts() {
  const response = await fetch('https://dev.to/api/articles?username=rodreegez');
  const posts = await response.json();  
  return posts;
}

const postTemplate = (post) => `
  <li>
    <a href="${post.url}">
      <h2 class="font-semibold">${ post.title }</h2>
      <p class="text-sm text-gray-800">${ post.description }</p>
    </a>

  </li>
`

const writingContainer = document.querySelector('#recent-posts');

fetchPosts().then(posts => {
  for (var post of posts) {
    console.log(post);
    writingContainer.insertAdjacentHTML('beforeend', postTemplate(post));
  }
})
