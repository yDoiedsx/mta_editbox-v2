# editbox made for the MTA

Este script implementa um sistema de inputs interativos altamente configurável para o MTA:SA (Multi Theft Auto: San Andreas). Ele permite criar campos de texto dinâmicos e personalizados, com suporte a diversas funcionalidades, incluindo mascaramento, navegação pelo texto, atalhos de teclado e suporte a eventos como clique, colagem e entrada de caracteres.

# Recursos principais

# Criação de inputs personalizados:
Propriedades configuráveis como posição (x, y), tamanho (width, height), fonte (font) e texto inicial (text).

# Máscara de texto:
Suporte para campos de senha onde o texto digitado pode ser mascarado com caracteres como *.

# Eventos de teclado e clique:
Suporte a teclas de navegação (arrow_l, arrow_r), backspace, delete, enter e combinações com Ctrl para copiar, colar e selecionar texto.

# Controle de foco:
Determina se o input está ativo e permite alternar entre estados de foco.

# Renderização flexível:
Textos são renderizados na tela com suporte a quebra de linha (wordbreak) e alinhamento. Além disso, o cursor é animado para uma melhor experiência visual.

# Limitações configuráveis:
Definição do comprimento máximo de texto (length) e restrição a números (number).

# Funções

1. Inputs.new(properties)
Cria um novo campo de input com as propriedades definidas na tabela properties.

# Propriedades padrão:

x, y, width, height: Controle de posicionamento e tamanho.
font, text: Aparência e conteúdo inicial do input.
number, mask: Restrições de texto e mascaramento.

2. Inputs:render(...)
Renderiza o campo de texto na tela com suporte a cores, posicionamento e animações.

3. Inputs:destroy()
Remove os manipuladores de eventos e limpa os recursos alocados para o input.

4. Inputs:setFocus(state)
Ativa ou desativa o foco no input programaticamente.

# Uso

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
        false, -- pós-processamento
        true   -- quebra de linha
    )
end

addEventHandler("onClientRender", root, render)

# Personalização

O sistema foi projetado para ser extensível e modular, permitindo fácil adaptação para diversas necessidades de interfaces gráficas no MTA:SA.
