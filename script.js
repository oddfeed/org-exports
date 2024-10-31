// Placeholder file list for testing
const files = [
    { name: 'example.md', path: 'tech/example.md', lastModified: '2023-10-25' },
    { name: 'tutorial.html', path: 'docs/tutorial.html', lastModified: '2023-10-24' },
    { name: 'intro.org', path: 'guides/intro.org', lastModified: '2023-10-23' },
];

document.addEventListener("DOMContentLoaded", () => {
    renderFileList(files);
    populateFolderFilter(files);
});

function renderFileList(fileArray) {
    const fileList = document.getElementById('fileList');
    fileList.innerHTML = '';

    fileArray.sort((a, b) => new Date(b.lastModified) - new Date(a.lastModified))
             .forEach(file => {
        const li = document.createElement('li');
        li.className = 'fileItem';

        const fileName = document.createElement('span');
        fileName.textContent = file.name;

        const fileTag = document.createElement('span');
        fileTag.className = 'tag';
        fileTag.textContent = file.path.split('/')[0];

        li.appendChild(fileName);
        li.appendChild(fileTag);
        fileList.appendChild(li);
    });
}

function populateFolderFilter(fileArray) {
    const folderFilter = document.getElementById('folderFilter');
    const folders = [...new Set(fileArray.map(file => file.path.split('/')[0]))];

    folders.forEach(folder => {
        const option = document.createElement('option');
        option.value = folder;
        option.textContent = folder;
        folderFilter.appendChild(option);
    });

    folderFilter.addEventListener('change', () => {
        filterAndSearchFiles();
    });
}

document.getElementById('searchBar').addEventListener('input', filterAndSearchFiles);

function filterAndSearchFiles() {
    const searchQuery = document.getElementById('searchBar').value.toLowerCase();
    const selectedFolder = document.getElementById('folderFilter').value;

    const filteredFiles = files.filter(file => {
        const matchesSearch = file.name.toLowerCase().includes(searchQuery);
        const matchesFolder = selectedFolder ? file.path.startsWith(selectedFolder) : true;
        return matchesSearch && matchesFolder;
    });

    renderFileList(filteredFiles);
}
