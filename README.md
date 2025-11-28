English version below

Versión en español a continuación

# Tutorial de Configuração: Projeto Mouse

Este guia detalhado é o ponto de partida oficial para configurar seu ambiente de desenvolvimento para o Projeto Mouse. Ele cobre a instalação das ferramentas corretas (Godot .NET/C++), a clonagem do repositório e o padrão obrigatório para a criação de *branches* de trabalho.

---

<details>
<summary>Guia de Configuração (Português)</summary>

## 1. Pré-requisitos (Obrigatório)

Antes de começar, você **deve** ter as ferramentas corretas instaladas. O projeto utiliza C#, C++ (via GDExtension) e GDScript, exigindo uma versão específica do Godot.

### 1.1. Git
O Git é usado para controle de versão.
* **Download:** [https://git-scm.com/downloads](https://git-scm.com/downloads)

### 1.2. Godot Engine (.NET / C#)
Você **deve** baixar a versão **.NET** do Godot Engine 4.x. A versão padrão (sem .NET) não funcionará.

1.  Acesse [https://godotengine.org/download/](https://godotengine.org/download/)
2.  Encontre a seção "Godot Engine 4.x".
3.  Clique no botão **".NET"**. (Não baixe a versão "Standard").
4.  Extraia o arquivo `.zip` em um local de fácil acesso (ex: `C:\Godot\`).

### 1.3. Compilador C++ (GDExtension)
Para que o Godot carregue os módulos C++, você precisa de um compilador C++ instalado.

* **No Windows (Recomendado):** Instale o **Visual Studio Community** com a carga de trabalho (workload) **"Desenvolvimento para desktop com C++"**.
* **No Linux:** Instale o `build-essential` (GCC, G++).
* **No macOS:** Instale o `Xcode Command Line Tools`.

---

## 2. Configuração do Repositório

### 2.1. Criar a Pasta Base
Para manter a organização, crie uma pasta principal para todos os seus projetos.

```bash
# Exemplo no Windows
cd C:\
mkdir Projetos
cd Projetos
mkdir Projeto-Mouse
cd Projeto-Mouse
```
### 2.2. Clonar o Repositório
Use git clone para baixar o repositório Main para sua pasta Projeto-Mouse.

```bash
git clone [https://github.com/Projeto-Mouse/Main](https://github.com/Projeto-Mouse/Main)
```

### 2.3. Entrar na Pasta
Navegue para a pasta `Main` que foi criada:

```bash
cd Main
```

## 3. Fluxo de Trabalho (Padrão de Branch Obrigatório)
Você nunca deve trabalhar diretamente no branch main. Siga este padrão para cada task ou bug.

### 3.1. Atualizar o main
Antes de criar um novo branch, sempre puxe as últimas atualizações:

```bash
git checkout main
git pull origin main
```

## 3.2. Criar seu Branch de Trabalho
Usamos um padrão baseado no seu ticket de trabalho (Jira, Trello, etc.).

| Tipo de Trabalho | Padrão de Nomenclatura | 
|---------|-----------|
| Nova Task / Feature | `PMDT-[NumeroTicket]/descricao-curta` |
| Correção de Bug | `BRDT-[NumeroTicket]/descricao-curta` |

Exemplos de como criar o branch:
```bash
# Exemplo para uma nova Task (PMDT-123: Implementar login)
git checkout -b PMDT-123/implementar-login-google

# Exemplo para um Bug (BRDT-456: Corrigir física da câmera)
git checkout -b BRDT-456/corrigir-fisica-camera
```

Todo o seu trabalho deve ser feito dentro deste novo branch.

## 4. Abrindo o Projeto no Godot

1. Abra o executável do Godot .NET que você baixou (Passo 1.2).
2. Clique em Importar (Import).
3. Navegue até a pasta onde você clonou o projeto (ex: C:\Projetos\Projeto-Mouse\Main).
4. Selecione o arquivo project.godot e clique em Abrir.
5. O Godot irá carregar o projeto, compilar as dependências .NET (C#) e carregar os módulos C++ (GDExtension).

## 5. Salvando seu Trabalho
1. Adicione seus arquivos:
```bash
git add .
```
2. Faça o commit detalhado conforme nos nossos guias:
```bash
git commit -m "feat: Adiciona lógica inicial do login"
```
3. Envie seu branch para o GitHub:
```bash
git push origin PMDT-123/implementar-login-google
```

</details>

# Setup Tutorial: Project Mouse

This detailed guide is the official starting point for setting up your development environment for Project Mouse. It covers installing the correct tools (Godot .NET/C++), cloning the repository, and the mandatory pattern for creating working *branches*.

---

<details>
<summary>Setup Guide (English)</summary>

## 1. Prerequisites (Required)

Before you begin, you **must** have the correct tools installed. The project uses C#, C++ (via GDExtension), and GDScript, requiring a specific version of Godot.

### 1.1. Git
Git is used for version control.

* **Download:** [https://git-scm.com/downloads](https://git-scm.com/downloads)

### 1.2. Godot Engine (.NET / C#)
You **must** download the **.NET** version of Godot Engine 4.x. The standard version (without .NET) will not work.

1. Go to [https://godotengine.org/download/](https://godotengine.org/download/)
2. Find the "Godot Engine 4.x" section.
3. Click the **".NET"** button. (Do not download the "Standard" version).
4. Extract the `.zip` file to an easily accessible location (e.g., `C:\Godot\`).

### 1.3. C++ Compiler (GDExtension)
For Godot to load C++ modules, you need a C++ compiler installed.

* **On Windows (Recommended):** Install **Visual Studio Community** with the workload **"Desktop Development with C++"**.

* **On Linux:** Install `build-essential` (GCC, G++).

* **On macOS:** Install `Xcode Command Line Tools`.

---

## 2. Repository Configuration

### 2.1. Creating the Base Folder
To maintain organization, create a main folder for all your projects.

```bash
# Example on Windows
cd C:\
mkdir Projects
cd Projects
mkdir Project-Mouse
cd Project-Mouse
```

### 2.2. Cloning the Repository
Use git clone to download the Main repository to your Project-Mouse folder.

```bash
git clone [https://github.com/Project-Mouse/Main](https://github.com/Project-Mouse/Main)
```

### 2.3. Entering the Folder
Navigate to the `Main` folder that was created:

```bash
cd Main
```

## 3. Workflow (Mandatory Branch Pattern)
You should never work directly on the main branch. Follow this pattern for each task or bug.

### 3.1. Updating main
Before creating a new branch, always pull the latest updates:

```bash
git checkout main
git pull origin main
```

## 3.2. Creating your Working Branch
We use a pattern based on your work ticket (Jira, Trello, etc.).

| Work Type | Naming Pattern |
|---------|-----------|
| New Task / Feature | `PMDT-[TicketNumber]/short-description` |
| Bug Fix | `BRDT-[TicketNumber]/short-description` |

Examples of how to create a branch:
```bash
# Example for a new Task (PMDT-123: Implement login)
git checkout -b PMDT-123/implement-google-login

# Example for a Bug (BRDT-456: Fix camera physics)
git checkout -b BRDT-456/fix-camera-physics
```

All your work should be done within this new branch.

## 4. Opening the Project in Godot

1. Open the Godot .NET executable you downloaded (Step 1.2).

2. Click Import.

3. Navigate to the folder where you cloned the project (e.g., C:\Projects\Project-Mouse\Main).

4. Select the project.godot file and click Open.

5. Godot will load the project, compile the .NET (C#) dependencies, and load the C++ (GDExtension) modules.

## 5. Saving Your Work
1. Add your files:
```bash
git add .

```
2. Make a detailed commit as per our guides:
```bash
git commit -m "feat: Adds initial login logic"
```
3. Push your branch to GitHub:
```bash
git push origin PMDT-123/implementar-login-google
```
----

</details>

# Tutorial de configuración: Project Mouse

Esta guía detallada es el punto de partida oficial para configurar tu entorno de desarrollo para Project Mouse. Cubre la instalación de las herramientas necesarias (Godot .NET/C++), la clonación del repositorio y el patrón obligatorio para crear ramas de trabajo.

---

<details> 
<summary>Guía de Configuración (Español)</summary>

## 1. Requisitos previos (obligatorios)

Antes de comenzar, **debes** tener instaladas las herramientas necesarias. El proyecto utiliza C#, C++ (mediante GDExtension) y GDScript, lo que requiere una versión específica de Godot.

### 1.1. Git
Git se utiliza para el control de versiones.

* **Descarga:** [https://git-scm.com/downloads](https://git-scm.com/downloads)

### 1.2. Motor Godot (.NET / C#)
Debes descargar la versión **.NET** del Motor Godot 4.x. La versión estándar (sin .NET) no funcionará.

1. Ve a [https://godotengine.org/download/](https://godotengine.org/download/)

2. Busca la sección "Motor Godot 4.x".

3. Haz clic en el botón **".NET"**. (No descargues la versión "Estándar").

4. Extrae el archivo `.zip` a una ubicación de fácil acceso (por ejemplo, `C:\Godot\`).

### 1.3. Compilador de C++ (GDExtension)
Para que Godot cargue módulos de C++, necesitas tener instalado un compilador de C++.

* **En Windows (Recomendado):** Instala **Visual Studio Community** con la carga de trabajo **"Desarrollo de escritorio con C++"**.

* **En Linux:** Instala `build-essential` (GCC, G++).

* **En macOS:** Instala `Xcode Command Line Tools`.

---

## 2. Configuración del repositorio

### 2.1. Creación de la carpeta base
Para mantener la organización, crea una carpeta principal para todos tus proyectos.

```bash
# Ejemplo en Windows
cd C:\
mkdir Projects
cd Projects
mkdir Project-Mouse
cd Project-Mouse

```
### 2.2. Clonación del repositorio
Usa `git clone` para descargar el repositorio principal a tu carpeta Project-Mouse.

```bash
git clone [https://github.com/Project-Mouse/Main](https://github.com/Project-Mouse/Main)

```

### 2.3. Acceder a la carpeta
Navegue a la carpeta `Main` que se creó:

```bash
cd Main
```

## 3. Flujo de trabajo (Patrón de ramas obligatorio)
Nunca trabaje directamente en la rama principal. Siga este patrón para cada tarea o error.

### 3.1. Actualizar la rama principal
Antes de crear una nueva rama, siempre actualice la rama principal:

```bash
git checkout main
git pull origin main

```

## 3.2. Crear su rama de trabajo
Utilizamos un patrón basado en su ticket de trabajo (Jira, Trello, etc.).

| Tipo de trabajo | Patrón de nomenclatura |
|---------|-----------|
| Nueva tarea/funcionalidad | `PMDT-[Número de ticket]/descripción-breve` |
| Corrección de error | `BRDT-[Número de ticket]/descripción-breve` |

Ejemplos de cómo crear una rama:

```bash
# Ejemplo para una nueva tarea (PMDT-123: Implementar inicio de sesión)

git checkout -b PMDT-123/implement-google-login

# Ejemplo para un error (BRDT-456: Corregir la física de la cámara)

git checkout -b BRDT-456/fix-camera-physics

```

Todo el trabajo debe realizarse dentro de esta nueva rama.

## 4. Abrir el proyecto en Godot

1. Abre el ejecutable de Godot .NET que descargaste (Paso 1.2).

2. Haz clic en Importar.

3. Navega a la carpeta donde clonaste el proyecto (p. ej., C:\Projects\Project-Mouse\Main).

4. Selecciona el archivo project.godot y haz clic en Abrir.

5. Godot cargará el proyecto, compilará las dependencias de .NET (C#) y cargará los módulos de C++ (GDExtension).

## 5. Guardar tu trabajo
1. Agrega tus archivos:

```bash
git add .

``` 2. Crea un commit detallado siguiendo nuestras guías:

```bash
git commit -m "feat: Adds initial login logic"

``` 3. Sube tu rama a GitHub:

```bash
git push origin PMDT-123/implementar-login-google

```

</details>

<img width="3000" height="1500" alt="godot logo" src="https://github.com/user-attachments/assets/c4423c92-596c-4dd5-a041-1bf79281d4b2" />

### Aviso de Propriedade Intelectual e Licença e Apoio Financeiro
<details> <summary>Português (Brasil)</summary>

Natureza do Projeto e Direitos Reservado:

Apesar de o código-fonte deste projeto de jogo ser Source-Avaliable, o conteúdo criativo, as ideias apresentadas, o design e a propriedade intelectual subjacente não são de domínio público. Todos os direitos sobre o conteúdo criativo e intelectual estão estritamente reservados aos donos do projeto e à equipe de desenvolvimento. Não é permitido copiar as ideias, conceitos ou utilizá-los de maneira lucrativa ou comercial sem autorização expressa.
Link da licença que utilizamos (Human Readable Deed): https://creativecommons.org/licenses/by-nc-sa/4.0/deed.pt-br

Apoio e Financiamento:

O projeto tem como objetivo principal ser gratuito para a comunidade. No entanto, a organização aceita e agradece qualquer apoio financeiro para garantir a sustentabilidade e o desenvolvimento contínuo. Detalhes sobre como realizar este apoio serão disponibilizados em breve.

</details>

### Project Nature, Reserved Rights and Financial Support
<details> <summary>English (United States)</summary>

Although the source code for this game project is Source-Avaliable, the creative content, presented ideas, design, and underlying intellectual property are not in the public domain. All rights to the creative and intellectual content are strictly reserved for the project owners and the development team. It is not permitted to copy the ideas, concepts, or use them for profitable or commercial purposes without express authorization.
Link to the license we use (Human Readable Deed): https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en

Support and Funding:

The project's primary goal is to be free for the community. However, the organization accepts and appreciates any financial support to ensure sustainability and continuous development. Details on how to provide this support will be made available soon.

</details>

### Naturaleza del Proyecto, Derechos Reservados y Apoyo Financiero
<details> <summary>Español (Latinoamérica)</summary>

Aunque el código fuente de este proyecto de juego es Source-Avaliable, el contenido creativo, las ideas presentadas, el diseño y la propiedad intelectual subyacente no son de dominio público. Todos los derechos sobre el contenido creativo e intelectual están estrictamente reservados para los dueños del proyecto y el equipo de desarrollo. No está permitido copiar las ideas, conceptos o utilizarlos con fines lucrativos o comerciales sin autorización expresa.
Enlace a la licencia que utilizamos (Human Readable Deed): https://creativecommons.org/licenses/by-nc-sa/4.0/deed.es

Apoyo y Financiación:

El objetivo principal del proyecto es ser gratuito para la comunidad. No obstante, la organización acepta y agradece cualquier apoyo financiero para garantizar la sostenibilidad y el desarrollo continuo. Los detalles sobre cómo realizar esta financiación se pondrán a disposición pronto.

</details>
