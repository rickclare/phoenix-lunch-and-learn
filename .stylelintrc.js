/* global module */

module.exports = {
  plugins: ["stylelint-prettier"],
  extends: ["stylelint-config-standard"],
  rules: {
    "prettier/prettier": true,
    // NOTE: disabling `at-rule-no-deprecated`, as is failing against the TailwindCSS @apply directive
    "at-rule-no-deprecated": null,
    "at-rule-no-unknown": [
      true,
      {
        ignoreAtRules: [
          "apply",
          "config",
          "custom-variant",
          "layer",
          "plugin",
          "screen",
          "source",
          "tailwind",
          "theme",
          "utility",
          "variant",
        ],
      },
    ],
    "import-notation": "string",
    // See https://eslint.org/docs/latest/rules/no-warning-comments
    "comment-word-disallowed-list": [
      "BROKEN",
      "BUG",
      "ERROR",
      "FIXME",
      "HACK",
      "OPTIMIZE",
      "OPTIMISE",
      "REVIEW",
      "WTF",
      "XXX",
    ],
  },
}
