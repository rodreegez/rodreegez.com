async function fetchPosts() {
  const response = await fetch('https://dev.to/api/articles?username=rodreegez');
  const posts = await response.json();  
  return posts;
}

const postTemplate = (post) => `
  <li class="transition duration-100 ease-in-out hover:ring-4 hover:ring-blue-500 hover:ring-offset-4">
    <a href="${post.url}">
      <h2 class="font-semibold">${ post.title }</h2>
      <p class="text-sm text-gray-800">${ post.description }</p>
    </a>

  </li>
`
fetchPosts().then(posts => {
  for (var post of posts.slice(0,4)) {
    document.querySelector('#recent-posts').insertAdjacentHTML('beforeend', postTemplate(post));
  }
})
