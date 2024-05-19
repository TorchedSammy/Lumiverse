module.exports = {
  content: ["./index.html", "./src/**/*.{gleam,mjs}"],
  theme: {
    extend: {
      aspectRatio: {
        '5/7': '5 / 7'
      }
    },
  },
  plugins: [],
  darkMode: ['selector']
};
