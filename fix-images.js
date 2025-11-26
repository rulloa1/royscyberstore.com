// Image Fix Script for RoysCompany
// This script fixes broken image references by replacing them with available images

document.addEventListener('DOMContentLoaded', function() {
    // Available product images (first 24 actual files)
    const availableImages = [
        '1728423795.jpg', '1728424060.jpg', '1728424116.jpg', '1728424279.jpg',
        '1728424332.jpg', '1728424448.jpg', '1728425216.jpg', '1728425280.jpg',
        '1728425393.jpg', '1728425479.jpg', '1728425547.jpg', '1728425613.jpg',
        '1728425703.jpg', '1728425769.jpg', '1728425887.jpg', '1728425936.jpg',
        '1728425981.jpg', '1728426026.jpg', '1728426079.jpg', '1728426251.jpg',
        '1728426299.jpg', '1728464327.jpg', '1728464430.jpg', '1728464484.jpg'
    ];
    
    // Fix broken product images
    const productImages = document.querySelectorAll('img[src*="/product/"]');
    let imageIndex = 0;
    
    productImages.forEach(function(img) {
        const currentSrc = img.src;
        
        // Create a test image to check if current source loads
        const testImg = new Image();
        testImg.onerror = function() {
            // If image fails to load, replace with available image
            const newImageName = availableImages[imageIndex % availableImages.length];
            
            // Get the correct path depth
            const pathParts = currentSrc.split('/product/');
            if (pathParts.length > 1) {
                const basePath = pathParts[0] + '/product/';
                img.src = basePath + newImageName;
            }
            
            imageIndex++;
        };
        
        testImg.src = currentSrc;
    });
    
    // Fix logo image if it fails to load
    const logoImage = document.querySelector('img[src*="originals/2f/bf/ba/2fbfbacef953f5ff48b0c3fdb7ba5fe9"]');
    if (logoImage) {
        const testLogo = new Image();
        testLogo.onerror = function() {
            // Create a simple text-based logo as fallback
            const logoContainer = logoImage.parentElement;
            logoImage.style.display = 'none';
            
            if (!logoContainer.querySelector('.text-logo')) {
                const textLogo = document.createElement('div');
                textLogo.className = 'text-logo w-8 h-8 rounded bg-red-600 flex items-center justify-center text-white font-bold text-xs';
                textLogo.textContent = 'RC';
                textLogo.title = 'RoysCompany';
                logoContainer.insertBefore(textLogo, logoImage);
            }
        };
        testLogo.src = logoImage.src;
    }
});

// CSS for text logo fallback
const style = document.createElement('style');
style.textContent = `
    .text-logo {
        min-width: 32px;
        min-height: 32px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #DC2625 0%, #EF4444 100%);
        color: white;
        font-weight: bold;
        font-size: 12px;
        border-radius: 4px;
        cursor: pointer;
    }
`;
document.head.appendChild(style);