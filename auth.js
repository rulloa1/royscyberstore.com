'use strict';

// Function to get the current user from session storage
function getCurrentUser() {
    const user = sessionStorage.getItem('royscyberstore_current_user');
    return user ? JSON.parse(user) : null;
}

// Function to update the UI based on login status
function updateAuthUI() {
    const currentUser = getCurrentUser();
    const loginButton = document.getElementById('loginButton');
    const logoutButton = document.getElementById('logoutButton');
    const registerLink = document.getElementById('registerLink');
    const userEmailDisplay = document.getElementById('userEmailDisplay');

    if (currentUser) {
        // User is logged in
        if (loginButton) loginButton.style.display = 'none';
        if (registerLink) registerLink.style.display = 'none';
        if (logoutButton) logoutButton.style.display = 'block';
        if (userEmailDisplay) userEmailDisplay.textContent = currentUser.email;
    } else {
        // User is logged out
        if (loginButton) loginButton.style.display = 'block';
        if (registerLink) registerLink.style.display = 'block';
        if (logoutButton) logoutButton.style.display = 'none';
        if (userEmailDisplay) userEmailDisplay.textContent = '';
    }
}

// Function to handle logout
function handleLogout(event) {
    event.preventDefault();
    sessionStorage.removeItem('royscyberstore_current_user');
    // Optionally, show a logout success message
    // alert('You have been logged out.');
    window.location.href = 'index.html'; // Redirect to homepage after logout
}

// Attach event listener to logout button if it exists
document.addEventListener('DOMContentLoaded', () => {
    const logoutButton = document.getElementById('logoutButton');
    if (logoutButton) {
        logoutButton.addEventListener('click', handleLogout);
    }
    updateAuthUI(); // Initial UI update on page load
});

// Expose functions globally if needed for inline HTML event handlers
window.getCurrentUser = getCurrentUser;
window.updateAuthUI = updateAuthUI;
window.handleLogout = handleLogout;

