const fs = require('fs').promises;
const path = require('path');
const yaml = require('js-yaml'); // Remember to install: npm install js-yaml

// Main function to recursively process all markdown files
async function processMarkdownFiles(directoryPath) {
    try {
        // Get all files in the directory
        const files = await fs.readdir(directoryPath, { withFileTypes: true });

        for (const file of files) {
            const filePath = path.join(directoryPath, file.name);

            if (file.isDirectory()) {
                // Process subdirectories recursively
                await processMarkdownFiles(filePath);
            } else if (file.name.endsWith('.md')) {
                // Process markdown files
                await processMarkdownFile(filePath);
            }
        }
    } catch (error) {
        console.error(`Error processing directory ${directoryPath}:`, error);
    }
}

// Function to process individual markdown files
async function processMarkdownFile(filePath) {
    try {
        // Read file content
        const content = await fs.readFile(filePath, 'utf8');

        // Get filename without extension to use as title
        const fileName = path.basename(filePath, '.md');

        // Check if the file has frontmatter
        const frontmatterRegex = /^---\r?\n([\s\S]*?)\r?\n---(\r?\n|$)/;
        const frontmatterMatch = content.match(frontmatterRegex);

        let newContent;

        if (frontmatterMatch) {
            // File has frontmatter
            const frontmatterContent = frontmatterMatch[1];
            let frontmatter;

            try {
                frontmatter = yaml.load(frontmatterContent) || {};
            } catch (error) {
                console.error(`Error parsing frontmatter in ${filePath}:`, error);
                frontmatter = {};
            }

            // Check if title exists
            if (!frontmatter.title) {
                // Create new ordered object with title first
                const orderedFrontmatter = { title: fileName };

                // Add all other properties from original frontmatter
                for (const key in frontmatter) {
                    if (Object.prototype.hasOwnProperty.call(frontmatter, key)) {
                        orderedFrontmatter[key] = frontmatter[key];
                    }
                }

                // Create new content with updated frontmatter
                const newFrontmatterString = yaml.dump(orderedFrontmatter).trim();
                const lineEndingAfterFrontmatter = frontmatterMatch[2] || '\n';

                newContent = content.replace(
                    frontmatterMatch[0],
                    `---\n${newFrontmatterString}\n---${lineEndingAfterFrontmatter}`
                );

                // Write updated content
                await fs.writeFile(filePath, newContent, 'utf8');
                console.log(`Updated: Added title to existing frontmatter in ${filePath}`);
            } else {
                console.log(`Skipped: ${filePath} already has a title in frontmatter`);
            }
        } else {
            // No frontmatter, add new one with title
            const newFrontmatter = yaml.dump({ title: fileName }).trim();
            newContent = `---\n${newFrontmatter}\n---\n\n${content}`;

            // Write updated content
            await fs.writeFile(filePath, newContent, 'utf8');
            console.log(`Updated: Added new frontmatter with title to ${filePath}`);
        }
    } catch (error) {
        console.error(`Error processing file ${filePath}:`, error);
    }
}

// Directory to process - uses current directory if none specified
const targetDirectory = process.argv[2] || '.';

// Start processing
console.log(`Processing markdown files in ${targetDirectory}...`);
processMarkdownFiles(targetDirectory)
    .then(() => console.log('Processing complete!'))
    .catch(error => console.error('Error:', error));

