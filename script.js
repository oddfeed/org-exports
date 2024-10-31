const username = 'oddfeed';
const repoName = 'org-exports';
const branch = 'main';

async function fetchFiles() {
    const apiUrl = `https://api.github.com/repos/${username}/${repoName}/git/trees/${branch}?recursive=1`;

    try {
        const response = await fetch(apiUrl);
        const data = await response.json();
        const files = data.tree
            .filter(item => item.type === 'blob' && /\.(org|md|html)$/i.test(item.path))
            .map(file => ({
                name: file.path.split('/').pop(),
                path: file.path,
                folder: file.path.split('/')[0],
                url: `https://github.com/${username}/${repoName}/blob/${branch}/${file.path}`
            }));

        renderFileList(files);
        populateFolderFilter(files);
    } catch (error) {
        console.error('Error fetching files:', error);
    }
}

// Render file list in HTML
function renderFileList(fileArray) {
    const fileList = document.getElementById('fileList');
    fileList.innerHTML = '';

    // Sort by last updated (if available)
    fileArray.forEach(file => {
        const li = document.createElement('li');
        li.className = 'fileItem';

        const fileName = document.createElement('a');
        fileName.href = file.url;
        fileName.textContent = file.name;
        fileName.target = '_blank'; // Opens file in a new tab

        const fileTag = document.createElement('span');
        fileTag.className = 'tag';
        fileTag.textContent = file.folder;

        li.appendChild(fileName);
        li.appendChild(fileTag);
        fileList.appendChild(li);
    });
}

// Populate folder filter dropdown
function populateFolderFilter(fileArray) {
    const folderFilter = document.getElementById('folderFilter');
    const folders = [...new Set(fileArray.map(file => file.folder))];

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

    fetchFiles().then(files => {
        const filteredFiles = files.filter(file => {
            const matchesSearch = file.name.toLowerCase().includes(searchQuery);
            const matchesFolder = selectedFolder ? file.folder === selectedFolder : true;
            return matchesSearch && matchesFolder;
        });

        renderFileList(filteredFiles);
    });
}

fetchFiles();
