module.exports = {
  cache: true,
  watch: true,
  entry: {
    main: './app/Main.elm'
  },
  output: {
      filename: 'elm.js',
      libraryTarget: 'var',
      library: 'Elm'
  },
  module: {
    loaders: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      loader: 'elm-webpack'
    }]
  }
};