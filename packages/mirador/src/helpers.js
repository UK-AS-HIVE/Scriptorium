Template.registerHelper('trimTitlePrefix', function(title) {
  title = title.replace(/^Beinecke MS \w+,? \[?/, '');
  title = title.replace(/\]$/, '');

  return title;
});
