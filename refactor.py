import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    
    # Replace .asSliverWithPadding(horizontal: X.w) -> .horizontal(X)
    # The regex looks for \.asSliverWithPadding\(\s*horizontal\s*:\s*([0-9\.]+)(?:\.w)?\s*\)
    content = re.sub(
        r'\.asSliverWithPadding\(\s*horizontal\s*:\s*([0-9\.]+)(?:\.w)?\s*\)',
        r'.horizontal(\1)',
        content
    )

    # Replace .asSliverWithPadding(padding: EdgeInsets...) -> wait, is that used? Let's assume mostly horizontal is used.
    # What if there are other usages? Let's do a broad replacement.
    
    # Replace .asSliver -> remove it entirely (replace with empty string)
    content = re.sub(r'\.asSliver\b', '', content)

    # Replace .asPaddedSliver(...) similarly, though the user said to remove it and use .horizontal, 
    # but I already checked and asPaddedSliver was only defined, not used (except maybe somewhere else?).
    # Let's replace asPaddedSliver(horizontal: X.w) -> .horizontal(X)
    content = re.sub(
        r'\.asPaddedSliver\(\s*horizontal\s*:\s*([0-9\.]+)(?:\.w)?\s*\)',
        r'.horizontal(\1)',
        content
    )

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")

def main():
    directory = '/Users/tanvirhridoy/Desktop/cheering/cheering/lib'
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                process_file(filepath)

if __name__ == '__main__':
    main()
