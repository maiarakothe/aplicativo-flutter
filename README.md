# 📱 **Aplicativo Flutter de Registro de Produtos**

Este é um **aplicativo Flutter** que permite aos usuários registrar produtos, visualizá-los em uma lista, gerenciar seu perfil e fazer login/registro.

## 🚀 Funcionalidades

- **Login**: Permite que usuários existentes façam login com e-mail e senha.
- **Registro**: Permite que novos usuários criem uma conta com nome, e-mail e senha.
- **Registro de Produtos**: Usuários registrados podem adicionar novos produtos com nome, preço e URL da imagem.
- **Listagem de Produtos**: Exibe uma lista de produtos registrados, permitindo edição e exclusão.
- **Perfil**: Exibe informações do usuário e permite logout.
- **Splash Screen**: Tela inicial que verifica o estado de login e navega para a página apropriada.
- **Internacionalização**: Suporte para múltiplos idiomas (inglês e português).
- **Temas**: Suporte para alternância entre temas claro e escuro.

## 🗂️ Estrutura do Projeto

### **lib/**
- `main.dart`: Ponto de entrada do aplicativo, onde o tema e a internacionalização são configurados.
- `configs.dart`: Configurações gerais do aplicativo.
- `routes.dart`: Define as rotas de navegação do aplicativo.
- `theme_toggle_button.dart`: Widget para alternar entre os temas claro e escuro.

#### **core/**
- `colors.dart`: Define as cores utilizadas em todo o aplicativo.
- `themes.dart`: Define o gerenciamento de temas para o aplicativo (claro e escuro).

#### **pages/**
- `login.dart`: Página de login.
- `product_list.dart`: Página de listagem de produtos registrados.
- `product_registration.dart`: Página de registro de novos produtos.
- `profile_page.dart`: Página de perfil do usuário.
- `register.dart`: Página de registro de novos usuários.
- `splash_screen.dart`: Tela de splash que define o estado de login e navega conforme necessário.

### **services/**
- `auth_service.dart`: Lógica de autenticação (login, registro, logout).

### **utils/**
- `validators.dart`: Contém as funções de validação para os formulários.

### **l10n/**
- `app_en.arb`: Arquivo com as strings em inglês.
- `app_pt.arb`: Arquivo com as strings em português.
- `l10n.dart`: Configuração de internacionalização do app.

### **assets/**
- Contém imagens e outros recursos estáticos.

## 📦 Dependências

- `flutter_localizations`: Suporte para internacionalização.
- `provider`: Para gerenciamento de estado.
- `shared_preferences`: Para persistência de dados.
- `awidgets`: Pacote de widgets customizados.
- `mask_text_input_formatter`: Para formatação de entrada de texto.

## 🏃‍♂️ Como Executar

1. Clone o repositório.
2. Certifique-se de ter o **Flutter** instalado.
3. Execute `flutter pub get` para instalar as dependências.
4. Execute `flutter run` para iniciar o aplicativo.
