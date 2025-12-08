<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Importer des candidats</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: #495057;
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        .btn-retour {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.15);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
            border: 2px solid rgba(255, 255, 255, 0.2);
            font-size: 0.9em;
        }

        .btn-retour:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-50%) translateY(-2px);
        }

        h1 {
            font-size: 1.8em;
            font-weight: 600;
        }

        .form-container {
            padding: 40px;
        }

        .upload-area {
            border: 3px dashed #dee2e6;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            background: #f8f9fa;
            transition: all 0.3s ease;
            cursor: pointer;
            margin-bottom: 30px;
        }

        .upload-area:hover {
            border-color: #495057;
            background: #e9ecef;
        }

        .upload-area.dragover {
            border-color: #495057;
            background: #e9ecef;
            transform: scale(1.02);
        }

        .upload-icon {
            font-size: 3em;
            margin-bottom: 15px;
            color: #495057;
        }

        .upload-text {
            color: #495057;
            font-size: 1.1em;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .upload-hint {
            color: #6c757d;
            font-size: 0.9em;
        }

        .file-input {
            display: none;
        }

        .selected-file {
            background: #e7f3ff;
            border: 2px solid #495057;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            display: none;
            align-items: center;
            gap: 10px;
        }

        .selected-file.show {
            display: flex;
        }

        .file-icon {
            font-size: 1.5em;
        }

        .file-info {
            flex: 1;
        }

        .file-name {
            color: #495057;
            font-weight: 500;
            margin-bottom: 3px;
        }

        .file-size {
            color: #6c757d;
            font-size: 0.85em;
        }

        .remove-file {
            background: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85em;
            transition: all 0.3s ease;
        }

        .remove-file:hover {
            background: #c82333;
        }

        .btn-submit {
            background: #495057;
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            font-size: 1em;
            width: 100%;
            transition: all 0.3s ease;
        }

        .btn-submit:hover:not(:disabled) {
            background: #343a40;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(73, 80, 87, 0.3);
        }

        .btn-submit:disabled {
            background: #adb5bd;
            cursor: not-allowed;
        }

        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #495057;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .info-box h3 {
            color: #495057;
            font-size: 1em;
            margin-bottom: 8px;
        }

        .info-box ul {
            color: #6c757d;
            font-size: 0.9em;
            margin-left: 20px;
        }

        .info-box li {
            margin-bottom: 5px;
        }

        @media (max-width: 768px) {
            .btn-retour {
                position: static;
                transform: none;
                display: inline-block;
                margin-bottom: 15px;
            }

            .btn-retour:hover {
                transform: translateY(-2px);
            }

            .header {
                padding: 20px;
            }

            h1 {
                font-size: 1.4em;
            }

            .form-container {
                padding: 20px;
            }

            .upload-area {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="javascript:history.back()" class="btn-retour">← Retour</a>
            <h1>📤 Importer des candidats</h1>
        </div>

        <div class="form-container">
            <div class="info-box">
                <h3>ℹ️ Informations importantes</h3>
                <ul>
                    <li>Format accepté : fichier Excel (.xlsx)</li>
                    <li>Taille maximale : 10 MB</li>
                    <li>Assurez-vous que votre fichier contient les bonnes colonnes</li>
                </ul>
            </div>

            <form method="post" enctype="multipart/form-data" action="/candidat/import" id="importForm">
                <div class="upload-area" id="uploadArea">
                    <div class="upload-icon">📁</div>
                    <div class="upload-text">Cliquez pour sélectionner un fichier</div>
                    <div class="upload-hint">ou glissez-déposez votre fichier Excel ici</div>
                    <input type="file" name="file" accept=".xlsx" class="file-input" id="fileInput" required />
                </div>

                <div class="selected-file" id="selectedFile">
                    <span class="file-icon">📄</span>
                    <div class="file-info">
                        <div class="file-name" id="fileName"></div>
                        <div class="file-size" id="fileSize"></div>
                    </div>
                    <button type="button" class="remove-file" id="removeFile">✕ Supprimer</button>
                </div>

                <button type="submit" class="btn-submit" id="submitBtn" disabled>
                    📤 Importer le fichier
                </button>
            </form>
        </div>
    </div>

    <script>
        const uploadArea = document.getElementById('uploadArea');
        const fileInput = document.getElementById('fileInput');
        const selectedFile = document.getElementById('selectedFile');
        const fileName = document.getElementById('fileName');
        const fileSize = document.getElementById('fileSize');
        const removeFile = document.getElementById('removeFile');
        const submitBtn = document.getElementById('submitBtn');

        // Click to upload
        uploadArea.addEventListener('click', () => {
            fileInput.click();
        });

        // File selected
        fileInput.addEventListener('change', (e) => {
            handleFiles(e.target.files);
        });

        // Drag and drop
        uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', () => {
            uploadArea.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
            handleFiles(e.dataTransfer.files);
        });

        // Remove file
        removeFile.addEventListener('click', () => {
            fileInput.value = '';
            selectedFile.classList.remove('show');
            submitBtn.disabled = true;
        });

        function handleFiles(files) {
            if (files.length > 0) {
                const file = files[0];
                
                // Check file type
                if (!file.name.endsWith('.xlsx')) {
                    alert('Veuillez sélectionner un fichier Excel (.xlsx)');
                    return;
                }

                // Check file size (10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('Le fichier est trop volumineux (max 10 MB)');
                    return;
                }

                // Display file info
                fileName.textContent = file.name;
                fileSize.textContent = formatFileSize(file.size);
                selectedFile.classList.add('show');
                submitBtn.disabled = false;
            }
        }

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
        }
    </script>
</body>
</html>