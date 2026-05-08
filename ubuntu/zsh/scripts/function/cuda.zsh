# List available CUDA versions
function cuda_list() {
    echo "Available CUDA versions:"
    ls -d /usr/local/cuda-* 2>/dev/null | grep -oP 'cuda-\K[\d]+\.[\d]+' | sort -V
}

# zsh版本switch-cuda
function switch-cuda() {
    # 显示当前CUDA版本（完整输出，不做任何过滤）
    echo "Current CUDA version:"
    if command -v nvcc &> /dev/null; then
        nvcc -V
    else
        echo "nvcc not found in PATH. No active CUDA version."
        echo "Checking symbol link status..."
        if [ -L "/usr/local/cuda" ]; then
            echo "Current symbol link: $(readlink /usr/local/cuda)"
        else
            echo "No /usr/local/cuda symbol link exists."
        fi
    fi
    echo "----------------------------------------"

    # 列出可用的CUDA版本并存储到数组
    local cuda_versions=($(ls -d /usr/local/cuda-* 2>/dev/null | grep -oP 'cuda-\K[\d]+\.[\d]+' | sort -V))

    # 检查是否有可用版本
    if [ ${#cuda_versions[@]} -eq 0 ]; then
        echo "No CUDA versions found in /usr/local/"
        return 1
    fi

    # 显示版本列表
    echo "Available CUDA versions:"
    for i in {1..${#cuda_versions[@]}}; do
        echo "$i. ${cuda_versions[$i]}"
    done

    # 提示用户选择
    read "choice?Enter the number of the version to switch to: "

    # 验证用户输入
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#cuda_versions[@]}" ]; then
        echo "Invalid choice. Please enter a number between 1 and ${#cuda_versions[@]}"
        return 1
    fi

    # 获取选中的版本
    local selected_version="${cuda_versions[$choice]}"
    local cuda_path="/usr/local/cuda-$selected_version"

    # 验证CUDA路径存在
    if [ ! -d "$cuda_path" ]; then
        echo "Error: CUDA path $cuda_path does not exist!"
        return 1
    fi

    # 切换CUDA版本
    echo "Switching to CUDA $selected_version..."
    sudo rm -f /usr/local/cuda
    sudo ln -s "$cuda_path" /usr/local/cuda

    # 立即更新当前shell的环境变量
    export PATH="/usr/local/cuda/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
    export CUDA_HOME="/usr/local/cuda"

    # 显示切换后的版本信息（完整输出）
    echo "----------------------------------------"
    echo "Successfully switched to CUDA version:"
    if [ -x "$cuda_path/bin/nvcc" ]; then
        "$cuda_path/bin/nvcc" -V
    else
        echo "Warning: nvcc not found in $cuda_path/bin"
    fi
}
