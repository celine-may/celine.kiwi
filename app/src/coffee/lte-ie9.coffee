body = document.body
while body.firstChild
  body.removeChild body.firstChild

main = document.createElement "div"
main.setAttribute "class", "main"

content = document.createElement "div"
content.setAttribute "class", "content"

logo = document.createElement "img"
logo.setAttribute "height", "195"
logo.setAttribute "width", "195"
logo.setAttribute "alt", "Logo"
logo.setAttribute "class", "logo"
logo.setAttribute "src", "assets/images/logo.png"

title = document.createElement "h1"
title.setAttribute "class", "title"
titleContent = document.createTextNode "Celine Rufener"
title.appendChild titleContent

lead = document.createElement "h2"
lead.setAttribute "class", "lead"
leadContent = document.createTextNode "Digital Alchemist & Front End Developer"
lead.appendChild leadContent

copy = document.createElement "p"
copy.setAttribute "class", "copy"
copyContent = document.createTextNode "You're using an outdated browser. To view this website with the best experience, please use the latest version of Google Chrome, Safari or Firefox."
copy.appendChild copyContent

btn = document.createElement "a"
btn.setAttribute "class", "btn"
btn.setAttribute "href", "mailto:hello@celine.kiwi"
btnContent = document.createTextNode "Get in touch"
btn.appendChild btnContent

document.body.appendChild main
main.appendChild content
content.appendChild logo
content.appendChild title
content.appendChild lead
content.appendChild copy
content.appendChild btn
