/* ==========================================================================
   Haute Pâtisserie - Interactive Visual Cake Builder & Dynamic Estimator
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
    initVisualCakeStudio();
    initAlertAutoDismiss();
});

/**
 * Interactive Visual Cake Studio:
 * 1. Dynamically renders visual cake layers, frosting hues, and toppings
 * 2. Computes custom price and required 30% advance deposit in real time
 */
function initVisualCakeStudio() {
    const form = document.getElementById('customCakeForm');
    if (!form) return;

    const sizeSelect = form.querySelector('[name="size"]');
    const tiersSelect = form.querySelector('[name="tiers"]');
    const flavourSelect = form.querySelector('[name="flavour"]');
    const designSelect = form.querySelector('[name="design"]');
    const messageInput = form.querySelector('[name="customMessage"]');

    const totalDisplay = document.getElementById('estimatedPrice');
    const depositDisplay = document.getElementById('depositPrice');
    const visualCanvas = document.getElementById('cakeVisualCanvas');
    const inscriptionBadge = document.getElementById('visualInscriptionBadge');

    // Flavour color schemes
    const flavourColors = {
        'belgian truffle': { bg: '#3B2319', border: '#25150E', shadow: 'rgba(59, 35, 25, 0.4)' },
        'madagascan vanilla bean': { bg: '#FFF6E5', border: '#EBD6B5', shadow: 'rgba(235, 214, 181, 0.4)' },
        'red velvet supreme': { bg: '#8B1E28', border: '#601119', shadow: 'rgba(139, 30, 40, 0.4)' },
        'matcha pistachio cream': { bg: '#768B57', border: '#53653C', shadow: 'rgba(118, 139, 87, 0.4)' },
        'salted caramel praline': { bg: '#C98539', border: '#935919', shadow: 'rgba(201, 133, 57, 0.4)' },
        'black forest kirsch': { bg: '#4A282D', border: '#2E1519', shadow: 'rgba(74, 40, 45, 0.4)' }
    };

    function updateStudio() {
        const size = sizeSelect ? sizeSelect.value : '2kg';
        const tiers = tiersSelect ? parseInt(tiersSelect.value, 10) : 2;
        const flavour = flavourSelect ? flavourSelect.value.toLowerCase() : 'belgian truffle';
        const design = designSelect ? designSelect.value.toLowerCase() : '';
        const msg = messageInput ? messageInput.value.trim() : '';

        // 1. Price calculation mirroring CakeBooking.java calculateOrderTotal()
        let base = 35.0;
        if (size === '2kg') base += 25.0;
        else if (size === '3kg') base += 50.0;
        else if (size === '5kg') base += 95.0;

        if (tiers === 2) base += 30.0;
        else if (tiers >= 3) base += 65.0;

        if (flavour.includes('belgian') || flavour.includes('truffle') || flavour.includes('red velvet')) base += 15.0;
        else if (flavour.includes('matcha') || flavour.includes('pistachio')) base += 18.0;
        else if (flavour.includes('black forest') || flavour.includes('caramel')) base += 10.0;

        if (design.includes('fondant') || design.includes('sculpted')) base += 40.0;
        else if (design.includes('floral') || design.includes('sugar flower')) base += 30.0;
        else if (design.includes('gold leaf') || design.includes('vintage')) base += 25.0;
        else if (design.includes('drip') || design.includes('piped')) base += 15.0;

        const deposit = Math.round(base * 0.30 * 100) / 100;

        if (totalDisplay) totalDisplay.textContent = '$' + base.toFixed(2);
        if (depositDisplay) depositDisplay.textContent = '$' + deposit.toFixed(2);

        // 2. Render visual tiers in canvas
        if (visualCanvas) {
            let scheme = flavourColors[flavour] || { bg: '#EBD6B5', border: '#D0B48F', shadow: 'rgba(0,0,0,0.1)' };
            
            // Topping indicator
            let toppingIcon = '✨';
            if (design.includes('floral')) toppingIcon = '🌸 🌿 🌸';
            else if (design.includes('gold leaf')) toppingIcon = '👑 24K ✨';
            else if (design.includes('drip')) toppingIcon = '🍫 🍓 🍫';
            else if (design.includes('fondant')) toppingIcon = '🎀 🎨 🎀';

            let tiersHtml = `<div style="font-size: 1.6rem; margin-bottom: -10px; z-index: 10; animation: float-gentle 3s ease-in-out infinite;">${toppingIcon}</div>`;

            if (tiers >= 3) {
                tiersHtml += `<div class="cake-layer" style="width: 100px; height: 50px; background: ${scheme.bg}; border: 3px solid ${scheme.border}; box-shadow: 0 4px 12px ${scheme.shadow}; z-index: 3;"></div>`;
            }
            if (tiers >= 2) {
                tiersHtml += `<div class="cake-layer" style="width: 160px; height: 65px; background: ${scheme.bg}; border: 3px solid ${scheme.border}; box-shadow: 0 6px 14px ${scheme.shadow}; z-index: 2; margin-top: -6px;"></div>`;
            }
            // Base layer
            tiersHtml += `<div class="cake-layer" style="width: 220px; height: 80px; background: ${scheme.bg}; border: 3px solid ${scheme.border}; box-shadow: 0 8px 18px ${scheme.shadow}; z-index: 1; margin-top: -6px;"></div>`;
            // Stand
            tiersHtml += `<div style="width: 260px; height: 14px; background: linear-gradient(90deg, #D4AF37 0%, #F5D77F 50%, #D4AF37 100%); border-radius: 8px; margin: -2px auto 0; box-shadow: 0 6px 12px rgba(0,0,0,0.15);"></div>`;
            tiersHtml += `<div style="width: 80px; height: 18px; background: #C5A028; border-radius: 0 0 8px 8px; margin: 0 auto;"></div>`;

            visualCanvas.innerHTML = tiersHtml;
        }

        // 3. Inscription update
        if (inscriptionBadge) {
            if (msg) {
                inscriptionBadge.textContent = 'Piped Plaque: "' + msg + '"';
                inscriptionBadge.style.display = 'inline-block';
            } else {
                inscriptionBadge.style.display = 'none';
            }
        }
    }

    [sizeSelect, tiersSelect, flavourSelect, designSelect, messageInput].forEach(el => {
        if (el) {
            el.addEventListener('change', updateStudio);
            el.addEventListener('input', updateStudio);
        }
    });

    updateStudio(); // Run initially
}

function initAlertAutoDismiss() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(a => {
        setTimeout(() => {
            a.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            a.style.opacity = '0';
            a.style.transform = 'translateY(-6px)';
            setTimeout(() => a.remove(), 600);
        }, 6000);
    });
}
