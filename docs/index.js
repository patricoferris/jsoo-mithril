let nav = document.getElementsByClassName("nav")[0];

let toggle = document.createElement('div');
toggle.className = 'menu-toggle';
toggle.innerText = 'menu';
toggle.onclick = () => nav.classList.toggle("nav-out");
document.body.appendChild(toggle);