return {
  name = 'voronianski/ludash',
  version = '1.0.1',
  description = 'lλdash - Luvit.io functional programming helper library',
  repository = {
    url = 'http://github.com/luvitrocks/ludash.git',
  },
  tags = {'luvit', 'lodash', 'ludash', 'functional', 'fp', 'utility', 'map', 'reduce', 'each', 'functions', 'underscore'},
  author = {
    name = 'Dmitri Voronianski',
    email = 'dmitri.voronianski@gmail.com'
  },
  homepage = 'https://github.com/luvitrocks/utopia',
  licenses = {'MIT'},
  dependencies = {
    'filwisher/lua-tape'
  },
  files = {
    '**.lua',
    '!test*',
    '!example*'
  }
}
