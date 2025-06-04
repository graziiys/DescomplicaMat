// Variáveis globais
let currentTab = 'login';

// Função para alternar entre abas
function switchTab(tab) {
    const loginTab = document.getElementById('loginTab');
    const registerTab = document.getElementById('registerTab');
    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');

    // Remover classes ativas
    loginTab.classList.remove('bg-white', 'text-blue-600', 'shadow-sm');
    loginTab.classList.add('text-gray-600', 'hover:text-gray-800');
    
    registerTab.classList.remove('bg-white', 'text-blue-600', 'shadow-sm');
    registerTab.classList.add('text-gray-600', 'hover:text-gray-800');

    // Esconder todos os formulários
    loginForm.classList.add('hidden');
    registerForm.classList.add('hidden');

    if (tab === 'login') {
        loginTab.classList.add('bg-white', 'text-blue-600', 'shadow-sm');
        loginTab.classList.remove('text-gray-600', 'hover:text-gray-800');
        loginForm.classList.remove('hidden');
        currentTab = 'login';
    } else {
        registerTab.classList.add('bg-white', 'text-blue-600', 'shadow-sm');
        registerTab.classList.remove('text-gray-600', 'hover:text-gray-800');
        registerForm.classList.remove('hidden');
        currentTab = 'register';
    }
}

// Função para alternar visibilidade da senha
function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    const icon = field.nextElementSibling.querySelector('i');
    
    if (field.type === 'password') {
        field.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        field.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}

// Função para mostrar toast
function showToast(message, type = 'success') {
    const container = document.getElementById('toastContainer');
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.textContent = message;
    
    container.appendChild(toast);
    
    // Remover toast após 3 segundos
    setTimeout(() => {
        toast.remove();
    }, 3000);
}

// Função para simular loading
function simulateLoading(button, originalText, loadingText, callback) {
    button.disabled = true;
    button.textContent = loadingText;
    
    setTimeout(() => {
        button.disabled = false;
        button.textContent = originalText;
        callback();
    }, 1000);
}

// Handler para login
function handleLogin(event) {
    event.preventDefault();
    
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    const button = event.target.querySelector('button[type="submit"]');
    
    simulateLoading(button, 'Entrar', 'Entrando...', () => {
        showToast(`Login realizado com sucesso! Bem-vindo de volta, ${email}`, 'success');
        
        // Limpar formulário
        document.getElementById('loginEmail').value = '';
        document.getElementById('loginPassword').value = '';
    });
}

// Handler para cadastro
function handleRegister(event) {
    event.preventDefault();
    
    const name = document.getElementById('registerName').value;
    const email = document.getElementById('registerEmail').value;
    const password = document.getElementById('registerPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const button = event.target.querySelector('button[type="submit"]');
    
    // Validar se as senhas coincidem
    if (password !== confirmPassword) {
        showToast('As senhas não coincidem', 'error');
        return;
    }
    
    simulateLoading(button, 'Criar conta', 'Criando conta...', () => {
        showToast(`Cadastro realizado com sucesso! Bem-vindo, ${name}!`, 'success');
        
        // Limpar formulário
        document.getElementById('registerName').value = '';
        document.getElementById('registerEmail').value = '';
        document.getElementById('registerPassword').value = '';
        document.getElementById('confirmPassword').value = '';
        document.getElementById('terms').checked = false;
    });
}

// Inicialização
document.addEventListener('DOMContentLoaded', function() {
    // Garantir que a aba de login esteja ativa por padrão
    switchTab('login');
});
