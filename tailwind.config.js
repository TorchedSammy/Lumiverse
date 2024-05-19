module.exports = {
  content: ["./index.html", "./src/**/*.{gleam,mjs}"],
  theme: {
    extend: {
      aspectRatio: {
        '5/7': '5 / 7'
      },
      colors: {
        'publication-cancelled': '#f25c5c',
        'publication-completed': '#7aaaff',
        'publication-ended': '#7aaaff',
        'publication-hiatus': '#ff9c6a',
        'publication-ongoing': '#55b682'
      }
    },
  },
  plugins: [],
  darkMode: ['selector']
};
