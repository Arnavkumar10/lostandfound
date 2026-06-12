/**
 * College Lost & Found Portal — Main JavaScript
 * Handles: navbar scroll effects, image previews, file drag-drop,
 *          flash message auto-dismiss, form validation, search debounce.
 */

/* ── Navbar Scroll Effect ─────────────────────────────────────── */
(function () {
    const navbar = document.querySelector('.navbar-custom');
    if (navbar) {
        window.addEventListener('scroll', () => {
            navbar.classList.toggle('scrolled', window.scrollY > 20);
        }, { passive: true });
    }
})();

/* ── Flash Message Auto-Dismiss ───────────────────────────────── */
(function () {
    document.querySelectorAll('.alert-dismissible').forEach(el => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(el);
            if (bsAlert) bsAlert.close();
        }, 5000);
    });
})();

/* ── Image Upload Preview ─────────────────────────────────────── */
function initImagePreview(inputId, previewId, placeholderId) {
    const input       = document.getElementById(inputId);
    const preview     = document.getElementById(previewId);
    const placeholder = document.getElementById(placeholderId);
    const uploadArea  = document.querySelector('.file-upload-area');

    if (!input || !preview) return;

    // Click anywhere in upload area triggers file picker
    if (uploadArea) {
        uploadArea.addEventListener('click', () => input.click());
        uploadArea.addEventListener('dragover', e => {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });
        uploadArea.addEventListener('dragleave', () => {
            uploadArea.classList.remove('dragover');
        });
        uploadArea.addEventListener('drop', e => {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
            if (e.dataTransfer.files.length) {
                input.files = e.dataTransfer.files;
                input.dispatchEvent(new Event('change'));
            }
        });
    }

    input.addEventListener('change', () => {
        const file = input.files[0];
        if (!file) return;

        // Validate type
        if (!file.type.startsWith('image/')) {
            showToast('Please select an image file.', 'error');
            input.value = '';
            return;
        }
        // Validate size (5MB)
        if (file.size > 5 * 1024 * 1024) {
            showToast('Image size must be under 5MB.', 'error');
            input.value = '';
            return;
        }

        const reader = new FileReader();
        reader.onload = e => {
            preview.src = e.target.result;
            preview.style.display = 'block';
            if (placeholder) placeholder.style.display = 'none';
        };
        reader.readAsDataURL(file);
    });
}

/* ── Toast Notifications ──────────────────────────────────────── */
function showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer') || createToastContainer();
    const toast = document.createElement('div');
    toast.className = `toast align-items-center border-0 show mb-2`;
    toast.style.cssText = `
        background: ${type === 'error' ? 'rgba(239,68,68,0.15)' : 'rgba(99,102,241,0.15)'};
        border-left: 4px solid ${type === 'error' ? '#ef4444' : '#6366f1'} !important;
        color: #f1f5f9;
        backdrop-filter: blur(10px);
        border-radius: 12px;
    `;
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body fw-500">${message}</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>`;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 4000);
}

function createToastContainer() {
    const c = document.createElement('div');
    c.id = 'toastContainer';
    c.style.cssText = 'position:fixed;top:80px;right:20px;z-index:9999;min-width:280px;';
    document.body.appendChild(c);
    return c;
}

/* ── Search Debounce ──────────────────────────────────────────── */
function debounce(fn, delay) {
    let t;
    return (...args) => {
        clearTimeout(t);
        t = setTimeout(() => fn(...args), delay);
    };
}

function initLiveSearch(formId) {
    const form = document.getElementById(formId);
    if (!form) return;
    const keywordInput = form.querySelector('input[name="keyword"]');
    if (keywordInput) {
        keywordInput.addEventListener('input', debounce(() => form.submit(), 600));
    }
}

/* ── Category Filter Auto-Submit ──────────────────────────────── */
function initCategoryFilter(selectId, formId) {
    const sel  = document.getElementById(selectId);
    const form = document.getElementById(formId);
    if (sel && form) sel.addEventListener('change', () => form.submit());
}

/* ── Confirm Delete Modals ────────────────────────────────────── */
function confirmAction(message, formId) {
    if (window.confirm(message)) {
        document.getElementById(formId).submit();
    }
}

/* ── Fade-in Animations on Scroll ─────────────────────────────── */
(function () {
    const observer = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity  = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.item-card, .stat-card, .glass-card').forEach(el => {
        el.style.opacity   = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
        observer.observe(el);
    });
})();

/* ── Character Counter for Textareas ──────────────────────────── */
function initCharCounter(textareaId, counterId, max) {
    const ta      = document.getElementById(textareaId);
    const counter = document.getElementById(counterId);
    if (!ta || !counter) return;
    const update = () => {
        const len = ta.value.length;
        counter.textContent = `${len}/${max}`;
        counter.style.color = len > max * 0.9 ? '#f59e0b' : '#64748b';
    };
    ta.addEventListener('input', update);
    update();
}

/* ── On DOM Ready ─────────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', () => {
    initImagePreview('itemImage', 'imagePreview', 'imagePlaceholder');
    initLiveSearch('searchForm');
    initCategoryFilter('categoryFilter', 'searchForm');
    initCharCounter('description', 'descCounter', 500);
    initCharCounter('proofDescription', 'proofCounter', 1000);

    // Bootstrap tooltips
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
            .forEach(el => new bootstrap.Tooltip(el));

    // Highlight active nav link
    const path = window.location.pathname;
    document.querySelectorAll('.nav-link-custom').forEach(link => {
        if (link.getAttribute('href') && path.includes(link.getAttribute('href').split('?')[0])) {
            link.classList.add('active-nav');
        }
    });
});
