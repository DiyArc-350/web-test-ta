#!/bin/bash

# Direktori tempat file HTML akan dibuat
HTML_DIR="./html_files"

# Buat direktori jika belum ada
if [ ! -d "$HTML_DIR" ]; then
    mkdir -p "$HTML_DIR"
fi

# Array file gambar yang tersedia
IMAGES=("1.jpg" "2.jpg" "3.jpg" "4.jpg" "5.jpg" "GIF-1.gif" "GIF-2.gif" "GIF-3.gif")

# Array judul halaman yang bervariasi
TITLES=("Gallery" "Image Collection" "Photo Showcase" "Visual Display" "Picture Gallery" "Media Center" "Image Hub" "Photo Archive")

# Array warna background
BACKGROUNDS=("#f0f8ff" "#ffefd5" "#e6e6fa" "#f0fff0" "#fff8dc" "#fdf5e6" "#f5f5dc" "#fffacd")

# Array gaya CSS
CSS_STYLES=(
    "text-align: center; font-family: Arial, sans-serif;"
    "text-align: left; font-family: Georgia, serif;"
    "text-align: center; font-family: 'Courier New', monospace;"
    "text-align: justify; font-family: Verdana, sans-serif;"
)

# Fungsi untuk mendapatkan elemen acak dari array
get_random_element() {
    local arr=("$@")
    local index=$(( RANDOM % ${#arr[@]} ))
    echo "${arr[$index]}"
}

# Fungsi untuk mengacak array dan mengambil beberapa elemen
get_random_images() {
    local num_images=$(( RANDOM % 5 + 2 ))  # 2-6 gambar per halaman
    local selected_images=()
    local temp_images=("${IMAGES[@]}")
    
    for ((i=0; i<num_images && i<${#temp_images[@]}; i++)); do
        local rand_index=$(( RANDOM % ${#temp_images[@]} ))
        selected_images+=("${temp_images[$rand_index]}")
        # Hapus gambar yang sudah dipilih untuk menghindari duplikasi
        temp_images=("${temp_images[@]:0:$rand_index}" "${temp_images[@]:$((rand_index+1))}")
    done
    
    printf '%s\n' "${selected_images[@]}"
}

# Loop untuk membuat file index1.html hingga index100.html
for i in $(seq 1 100); do
    FILE_PATH="${HTML_DIR}/index${i}.html"
    
    # Pilih elemen acak
    TITLE=$(get_random_element "${TITLES[@]}")
    BACKGROUND=$(get_random_element "${BACKGROUNDS[@]}")
    STYLE=$(get_random_element "${CSS_STYLES[@]}")
    
    # Dapatkan gambar acak
    mapfile -t SELECTED_IMAGES < <(get_random_images)
    
    # Generate deskripsi acak
    DESCRIPTIONS=("Beautiful image collection" "Stunning visual gallery" "Amazing photo showcase" "Captivating imagery" "Impressive visual display")
    DESCRIPTION=$(get_random_element "${DESCRIPTIONS[@]}")
    
    # Membuat konten HTML dengan elemen yang diacak
    cat > "$FILE_PATH" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>${TITLE} ${i}</title>
    <style>
        body {
            background-color: ${BACKGROUND};
            ${STYLE}
            margin: 20px;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .image-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .image-item {
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 10px;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .image-item:hover {
            transform: scale(1.05);
        }
        .image-item img {
            width: 100%;
            height: auto;
            border-radius: 4px;
        }
        .image-caption {
            margin-top: 8px;
            font-size: 14px;
            color: #666;
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
        }
        .description {
            color: #666;
            font-style: italic;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${TITLE} ${i}</h1>
        <p class="description">${DESCRIPTION}</p>
        <div class="image-grid">
EOF

    # Tambahkan gambar yang dipilih secara acak
    for img in "${SELECTED_IMAGES[@]}"; do
        # Generate caption acak
        CAPTIONS=("Featured image" "Gallery highlight" "Visual showcase" "Photo display" "Image collection")
        CAPTION=$(get_random_element "${CAPTIONS[@]}")
        
        cat >> "$FILE_PATH" << EOF
            <div class="image-item">
                <img src="${img}" alt="${img}">
                <div class="image-caption">${CAPTION} - ${img}</div>
            </div>
EOF
    done

    # Tutup HTML
    cat >> "$FILE_PATH" << EOF
        </div>
    </div>
</body>
</html>
EOF

    echo "File $FILE_PATH dibuat dengan ${#SELECTED_IMAGES[@]} gambar."
done

echo "Semua file index1.html hingga index100.html berhasil dibuat di $HTML_DIR dengan konten yang bervariasi."