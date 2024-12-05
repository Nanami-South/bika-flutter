module.exports = {
    trailingComma: "es5",
    tabWidth: 4,
    semi: true,
    singleQuote: false,
    printWidth: 120,
    endOfLine: "auto",
    overrides: [
        {
            files: "*.yml",
            options: {
                tabWidth: 2,
            },
        },
        {
            files: "*.yaml",
            options: {
                tabWidth: 2,
            },
        },
        {
            files: "*.json",
            options: {
                tabWidth: 2,
            },
        },
    ],
};
