function hide(arr) {
  Array.prototype.forEach.call(arr, function(elem) {
    elem.style.display = 'none';
  });
}

function show(arr) {
  Array.prototype.forEach.call(arr, function(elem) {
    elem.style.display = '';
  });
}

function showLanguage() {
  hide(document.querySelectorAll('[lang='+(localStorage.language == 'pl' ? 'en' : 'pl')+']'));
  show(document.querySelectorAll('[lang='+(localStorage.language == 'pl' ? 'pl' : 'en')+']'));
  var h = document.querySelectorAll('h1:not([lang='+(localStorage.language == 'pl' ? 'en' : 'pl')+'])');
  if(h.length) {
    document.title = h[0].innerText;
    for (var i = 1; i < h.length; ++i) {
      document.title = h[i].innerText + " - " + document.title;
    }
  }
}

localStorage.language = localStorage.language || navigator.language;

if (localStorage.language.startsWith('pl')) {
  localStorage.language = 'pl';
} else {
  localStorage.language = 'en';
}

showLanguage();

document.querySelector('.lang').addEventListener('click', function() {
  localStorage.language = localStorage.language == 'pl' ? 'en' : 'pl';
  showLanguage();
});
