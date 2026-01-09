// Main JavaScript for Online Bookstore

// Get context path
const contextPath = document.querySelector('link[rel="stylesheet"]')?.href.split('/css/')[0] || '';

// Update cart badge
function updateCartBadge() {
    fetch(contextPath + '/cart?action=count')
        .then(response => response.json())
        .then(data => {
            if (data.success && data.data) {
                const badge = document.getElementById('cartBadge');
                if (badge) {
                    badge.textContent = data.data.count || 0;
                }
            }
        })
        .catch(error => console.error('Error updating cart badge:', error));
}

// Add to cart
function addToCart(bookId, quantity = 1) {
    const formData = new URLSearchParams();
    formData.append('action', 'add');
    formData.append('bookId', bookId);
    formData.append('quantity', quantity);
    
    fetch(contextPath + '/cart', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            updateCartBadge();
            showMessage('Added to cart successfully', 'success');
        } else {
            showMessage(data.message || 'Failed to add to cart', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Update cart item quantity
function updateCartQuantity(itemId, quantity) {
    const formData = new URLSearchParams();
    formData.append('action', 'update');
    formData.append('itemId', itemId);
    formData.append('quantity', quantity);
    
    fetch(contextPath + '/cart', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload();
        } else {
            showMessage(data.message || 'Failed to update quantity', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Delete cart item
function deleteCartItem(itemId) {
    if (!confirm('Remove this item from cart?')) return;
    
    const formData = new URLSearchParams();
    formData.append('action', 'delete');
    formData.append('itemId', itemId);
    
    fetch(contextPath + '/cart', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload();
        } else {
            showMessage(data.message || 'Failed to delete item', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Update cart item checked status
function updateCartChecked(itemId, checked) {
    const formData = new URLSearchParams();
    formData.append('action', 'check');
    formData.append('itemId', itemId);
    formData.append('checked', checked);
    
    fetch(contextPath + '/cart', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload();
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Check all cart items
function checkAllCart(checked) {
    const formData = new URLSearchParams();
    formData.append('action', 'checkAll');
    formData.append('checked', checked);
    
    fetch(contextPath + '/cart', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload();
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Create order
function createOrder(addressId) {
    const formData = new URLSearchParams();
    formData.append('action', 'create');
    formData.append('addressId', addressId);
    
    fetch(contextPath + '/order', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showMessage('Order created successfully!', 'success');
            setTimeout(() => {
                window.location.href = contextPath + '/order?action=list';
            }, 1000);
        } else {
            showMessage(data.message || 'Failed to create order', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Pay order
function payOrder(orderId) {
    const formData = new URLSearchParams();
    formData.append('action', 'pay');
    formData.append('orderId', orderId);
    
    fetch(contextPath + '/order', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showMessage('Payment successful!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showMessage(data.message || 'Payment failed', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Cancel order
function cancelOrder(orderId) {
    if (!confirm('Are you sure you want to cancel this order?')) return;
    
    const formData = new URLSearchParams();
    formData.append('action', 'cancel');
    formData.append('orderId', orderId);
    
    fetch(contextPath + '/order', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showMessage('Order cancelled', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showMessage(data.message || 'Failed to cancel order', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Confirm order received (alias for confirmOrder)
function confirmReceive(orderId) {
    confirmOrder(orderId);
}

// Confirm order received
function confirmOrder(orderId) {
    if (!confirm('Confirm that you have received this order?')) return;
    
    const formData = new URLSearchParams();
    formData.append('action', 'confirm');
    formData.append('orderId', orderId);
    
    fetch(contextPath + '/order', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showMessage('Order confirmed!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showMessage(data.message || 'Failed to confirm order', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Toggle favorite
function toggleFavorite(bookId) {
    const btn = document.getElementById('favoriteBtn');
    const isFavorited = btn.dataset.favorited === 'true';
    
    const formData = new URLSearchParams();
    formData.append('action', isFavorited ? 'remove' : 'add');
    formData.append('bookId', bookId);
    
    fetch(contextPath + '/favorite', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            btn.dataset.favorited = !isFavorited;
            if (isFavorited) {
                btn.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> Favorite';
                showMessage('Removed from favorites', 'success');
            } else {
                btn.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg> Favorited';
                showMessage('Added to favorites', 'success');
            }
        } else {
            showMessage(data.message || 'Operation failed', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Submit review
function submitReview(bookId, rating, content) {
    const formData = new URLSearchParams();
    formData.append('action', 'add');
    formData.append('bookId', bookId);
    formData.append('rating', rating);
    formData.append('content', content);
    
    // Get orderId from URL if available
    const urlParams = new URLSearchParams(window.location.search);
    const orderId = urlParams.get('id');
    if (orderId) {
        formData.append('orderId', orderId);
    }
    
    fetch(contextPath + '/review', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showMessage('Review submitted successfully!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showMessage(data.message || 'Failed to submit review', 'error');
        }
    })
    .catch(error => {
        showMessage('Network error, please try again', 'error');
    });
}

// Logout
function logout() {
    const formData = new URLSearchParams();
    formData.append('action', 'logout');
    
    fetch(contextPath + '/user-servlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        window.location.href = contextPath + '/index';
    })
    .catch(error => {
        window.location.href = contextPath + '/index';
    });
}

// Show message toast
function showMessage(message, type = 'success') {
    const existing = document.querySelector('.toast-message');
    if (existing) existing.remove();
    
    const toast = document.createElement('div');
    toast.className = 'toast-message';
    toast.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        padding: 12px 20px;
        border-radius: 8px;
        font-size: 14px;
        z-index: 9999;
        animation: slideIn 0.3s ease;
        ${type === 'success' ? 'background: #e8f5e9; color: #34c759;' : 'background: #ffebee; color: #ff3b30;'}
    `;
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(style);
