# Sistema de Input Interativo para MTA:SA

Este script oferece um sistema avançado e configurável de campos de texto interativos para o MTA:SA (Multi Theft Auto: San Andreas). Ele permite criar inputs personalizados, altamente dinâmicos, e oferece suporte a uma ampla gama de funcionalidades como mascaramento de texto, navegação via teclado e interação por eventos como cliques e colagem.

---

## ✨ **Recursos principais**

### **1. Criação de inputs personalizados**
- Posicionamento configurável: `x`, `y`, `width`, `height`.
- Aparência ajustável: Fonte (`font`) e texto inicial (`text`).

### **2. Máscara de texto**
- Ideal para campos de senha, com suporte para mascarar o texto com caracteres específicos como `*`.

### **3. Controle por teclado e mouse**
- Navegação pelo texto usando setas (`arrow_l`, `arrow_r`), backspace, delete e enter.
- Suporte a atalhos como Ctrl+C (copiar), Ctrl+V (colar) e Ctrl+A (selecionar tudo).

### **4. Controle de foco**
- Determina se o campo está ativo, com alternância fácil entre estados de foco.

### **5. Renderização flexível**
- Suporte para:
  - Animações no cursor.
  - Textos com quebra de linha e alinhamento.
  - Definição de cores diferenciadas para o texto principal e placeholder.

### **6. Restrições configuráveis**
- Limite máximo de caracteres (`length`).
- Restrição para aceitar apenas números (`number`).

---

## 🔧 **Funções principais**

### **1. `Inputs.new(properties)`**
Cria um novo campo de input com as propriedades especificadas.

#### **Propriedades padrão:**
- `x`, `y`, `width`, `height`: Controle de posicionamento e tamanho.
- `font`, `text`: Aparência e texto inicial.
- `mask`: Habilita ou desabilita o mascaramento do texto.
- `number`: Restringe a entrada para números.

---

### **2. `Inputs:render(...)`**
Renderiza o campo de input na tela. Oferece suporte a:
- Textos com cores distintas (texto e placeholder).
- Opção de quebra de linha.

---

### **3. `Inputs:destroy()`**
Remove todos os manipuladores de eventos e libera os recursos alocados pelo campo de input.

---

### **4. `Inputs:setFocus(state)`**
Ativa ou desativa o foco no campo de input programaticamente.

---

## 🖥️ **Exemplo de uso**

```lua
local myInput = Inputs.new({
    x = 100,
    y = 100,
    width = 200,
    height = 30,
    text = "Digite aqui...",
    font = "default",
    mask = false,
    number = false
})

function render()
    myInput:render(
        "Digite seu texto aqui...",
        myInput.x,
        myInput.y,
        myInput.width,
        myInput.height,
        { text = tocolor(255, 255, 255), place = tocolor(150, 150, 150) },
        false, -- postgui
        true   -- wordbreak
    )
end

addEventHandler("onClientRender", root, render)
```

---

## 🎨 **Personalização**

Este sistema foi projetado para ser **modular e extensível**, permitindo fácil adaptação para diversas interfaces gráficas no MTA:SA. Seja para inputs simples ou campos mais complexos, você pode ajustar as propriedades e o comportamento de acordo com suas necessidades.

➡️ **Ideal para criar UIs responsivas e modernas no MTA:SA!**
