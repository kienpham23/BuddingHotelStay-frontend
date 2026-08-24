[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Find the file using wildcard to target the exact file name safely
$files = Get-ChildItem "D:\anhduan\b*.pptx"
if ($files.Count -eq 0) {
    Write-Error "No matching slide file found in D:\anhduan\"
    exit 1
}

$pptPath = $files[0].FullName
Write-Host "Opening file: $pptPath"

try {
    $ppt = New-Object -ComObject PowerPoint.Application
    # Open presentation in read-only and without window
    $pres = $ppt.Presentations.Open($pptPath, 1, 0, 0)
    
    $slideCount = $pres.Slides.Count
    Write-Host "Total slides: $slideCount"
    Write-Host "========================================"
    
    for ($i = 1; $i -le $slideCount; $i++) {
        $slide = $pres.Slides.Item($i)
        Write-Host "--- SLIDE $i ---"
        
        foreach ($shape in $slide.Shapes) {
            # Check for text frame
            if ($shape.HasTextFrame -eq -1 -and $shape.TextFrame.HasText -eq -1) {
                $text = $shape.TextFrame.TextRange.Text
                if ($text.Trim() -ne "") {
                    Write-Output $text
                }
            }
            # Check for group
            if ($shape.Type -eq 6) {
                foreach ($subShape in $shape.GroupItems) {
                    if ($subShape.HasTextFrame -eq -1 -and $subShape.TextFrame.HasText -eq -1) {
                        $text = $subShape.TextFrame.TextRange.Text
                        if ($text.Trim() -ne "") {
                            Write-Output $text
                        }
                    }
                }
            }
        }
        Write-Host "----------------------------------------"
    }
    
    $pres.Close()
    $ppt.Quit()
} catch {
    Write-Error "Error processing presentation: $_"
    if ($ppt) { $ppt.Quit() }
}
