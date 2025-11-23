{ profiles, ... }:

{
  # add settings to every profile
  programs.vscode.profiles = builtins.listToAttrs (
    map (profile: {
      name = profile;
      value = {
        userSettings = {
          "explorer.confirmDelete" = false;
          "editor.formatOnSave" = true;
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;
          "nix.serverPath" = "nil";
          "nix.enableLanguageServer" = true;
          "nix.serverSettings" = {
            "nil" = {
              formatting.command = [ "nixfmt" ];
            };
          };
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
          "editor.fontFamily" = "JetbrainsMono Nerd Font";
          "terminal.integrated.fontFamily" = "JetbrainsMono Nerd Font";
          "editor.fontLigatures" = true;
          "explorer.confirmDragAndDrop" = false;

          "[css]" = {
            "editor.defaultFormatter" = "vscode.css-language-features";
          };
          "[java]" = {
            "editor.defaultFormatter" = "redhat.java";
          };
          "[markdown]" = {
            "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
          };
          "[python]" = {
            "editor.formatOnType" = true;
            "editor.defaultFormatter" = "ms-python.black-formatter";
            "editor.formatOnSave" = true;
            "editor.codeActionsOnSave" = {
              "source.organizeImports.ruff" = "explicit";
            };
          };
          "[scss]" = {
            "editor.defaultFormatter" = "sibiraj-s.vscode-scss-formatter";
          };
          "[svelte]" = {
            "editor.defaultFormatter" = "svelte.svelte-vscode";
          };
          "chat.editor.fontFamily" = "JetBrainsMono Nerd Font";
          "console-ninja.featureSet" = "Community";
          "cSpell.language" = "en;fr;en-GB;en-US;fr-FR";
          "cSpell.userWords" = [
            "dayjs"
          ];
          "css.lint.unknownAtRules" = "ignore";
          "debug.console.fontFamily" = "JetBrainsMono Nerd Font";
          "editor.accessibilitySupport" = "off";
          "editor.codeActionsOnSave" = { };
          "editor.codeLensFontFamily" = "JetBrainsMono Nerd Font";
          "editor.cursorBlinking" = "smooth";
          "editor.cursorSmoothCaretAnimation" = "on";
          "editor.cursorWidth" = 2;
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.fontWeight" = "400";
          "editor.formatOnPaste" = true;
          "editor.formatOnSaveMode" = "modifications";
          "editor.glyphMargin" = false;
          "editor.guides.bracketPairs" = "active";
          "editor.guides.indentation" = true;
          "editor.inlayHints.fontFamily" = "JetBrainsMono Nerd Font";
          "editor.minimap.enabled" = false;
          "editor.minimap.maxColumn" = 1;
          "editor.minimap.renderCharacters" = false;
          "editor.mouseWheelZoom" = false;
          "editor.occurrencesHighlight" = "off";
          "editor.smoothScrolling" = true;
          "editor.stickyScroll.enabled" = true;
          "editor.tabSize" = 2;
          "editor.wordWrap" = "on";
          "errorLens.enabledDiagnosticLevels" = [
            "error"
            "warning"
          ];
          "errorLens.fontFamily" = "JetBrainsMono Nerd Font";
          "explorer.compactFolders" = false;
          "explorer.confirmPasteNative" = false;
          "files.insertFinalNewline" = true;
          "files.trimFinalNewlines" = true;
          "files.trimTrailingWhitespace" = true;
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;
          "git.ignoreRebaseWarning" = true;
          "git.mergeEditor" = true;
          "gitlens.ai.experimental.openai.model" = "gpt-4-turbo-preview";
          "gitlens.ai.experimental.provider" = "openai";
          "gitlens.graph.layout" = "editor";
          "hediet.vscode-drawio.resizeImages" = null;
          "highlight-matching-tag.styles" = {
            "closing" = {
              "name" = {
                "highlight" = "#45858864";
              };
            };
            "opening" = {
              "name" = {
                "highlight" = "#45858864";
              };
            };
          };
          "i18n-ally.displayLanguage" = "en";
          "i18n-ally.enabledFrameworks" = [
            "svelte"
          ];
          "javascript.format.insertSpaceAfterConstructor" = true;
          "javascript.updateImportsOnFileMove.enabled" = "always";
          "liveServer.settings.donotShowInfoMsg" = true;
          "liveServer.settings.donotVerifyTags" = true;
          "markdown-preview-enhanced.codeBlockTheme" = "github.css";
          "markdown.extension.print.theme" = "dark";
          "markdown.extension.toc.orderedList" = true;
          "markdown.validate.enabled" = true;
          "material-icon-theme.folders.color" = "#ff3c00";
          "material-icon-theme.languages.associations" = { };
          "notebook.cellToolbarLocation" = {
            "default" = "right";
            "jupyter-notebook" = "left";
          };
          "notebook.compactView" = false;
          "notebook.formatOnSave.enabled" = true;
          "notebook.output.fontFamily" = "JetBrainsMono Nerd Font";
          "prettier.requireConfig" = true;
          "prettier.singleQuote" = true;
          "prisma.showPrismaDataPlatformNotification" = false;
          "redhat.telemetry.enabled" = false;
          "scm.inputFontFamily" = "JetBrainsMono Nerd Font";
          "security.workspace.trust.untrustedFiles" = "open";
          "svelte.enable-ts-plugin" = true;
          "svelte.plugin.svelte.format.config.singleQuote" = true;
          "svg.preview.mode" = "svg";
          "template-string-converter.validLanguages" = [
            "svelte"
            "typescript"
            "javascript"
            "typescriptreact"
            "javascriptreact"
            "html"
            "handlebars"
          ];
          "terminal.integrated.cursorStyle" = "line";
          "terminal.integrated.cursorWidth" = 2;
          "terminal.integrated.defaultProfile.linux" = "fish";
          "terminal.integrated.env.linux" = {
            "GTK_PATH" = null;
            "GIO_MODULE_DIR" = null;
          };
          "terminal.integrated.env.windows" = { };
          "terminal.integrated.fontSize" = 16;
          "terminal.integrated.ignoreBracketedPasteMode" = true;
          "terminal.integrated.profiles.linux" = {
            "bash" = {
              "icon" = "terminal-bash";
              "path" = "bash";
            };
            "fish" = {
              "path" = "fish";
            };
          };
          "terminal.integrated.scrollback" = 10000;
          "terminal.integrated.smoothScrolling" = true;
          "terminal.integrated.windowsEnableConpty" = false;
          "typescript.format.insertSpaceAfterConstructor" = true;
          "update.mode" = "manual";
          "window.customMenuBarAltFocus" = false;
          "window.enableMenuBarMnemonics" = false;
          "window.restoreWindows" = "preserve";
          "workbench.activityBar.location" = "top";
          "workbench.colorCustomizations" = {
            "[Atom One Dark]" = {
              "activityBarBadge.background" = "#ff3c00";
              "badge.background" = "#ff3c00b9";
              "button.background" = "#ff3c00b9";
              "button.hoverBackground" = "#ff3c00";
              "dropdown.border" = "#ff3c00";
              "editor.selectionBackground" = "#4d4d4d";
              "editorCursor.foreground" = "#ff3c00b9";
              "extensionButton.background" = "#ff3c00";
              "extensionButton.hoverBackground" = "#ff3c00b9";
              "focusBorder" = "#ff3c00b9";
              "progressBar.background" = "#ff3c00";
              "statusBarItem.remoteBackground" = "#ff3c00b9";
              "statusBarItem.remoteHoverBackground" = "#ff3c00";
            };
            "[Nord Aurora Darker]" = {
              "activityBarBadge.background" = "#88C0D0";
              "badge.background" = "#88C0D0b9";
              "button.background" = "#88C0D0b9";
              "button.hoverBackground" = "#88C0D0";
              "dropdown.border" = "#88C0D0";
              "editorBracketHighlight.foreground1" = "#5E81AC";
              "editorBracketHighlight.foreground2" = "#EBCB8B";
              "editorBracketHighlight.foreground3" = "#D08770";
              "editorBracketHighlight.foreground4" = "#B48EAD";
              "editorBracketHighlight.foreground5" = "#A3BE8C";
              "editorBracketHighlight.foreground6" = "#BF616A";
              "editorBracketPairGuide.activeBackground1" = "#5E81AC9E";
              "editorBracketPairGuide.activeBackground2" = "#EBCB8B64";
              "editorBracketPairGuide.activeBackground3" = "#D0877064";
              "editorBracketPairGuide.activeBackground4" = "#B48EAD64";
              "editorBracketPairGuide.activeBackground5" = "#A3BE8C64";
              "editorBracketPairGuide.activeBackground6" = "#BF616A64";
              "editorCursor.foreground" = "#88C0D0b9";
              "extensionButton.background" = "#88C0D0";
              "extensionButton.hoverBackground" = "#88C0D0b9";
              "focusBorder" = "#88C0D0b9";
              "progressBar.background" = "#88C0D0";
              "statusBarItem.remoteBackground" = "#88C0D0b9";
              "statusBarItem.remoteHoverBackground" = "#88C0D0";
              "terminal.ansiBlack" = "#3B4252";
              "terminal.ansiBlue" = "#81A1C1";
              "terminal.ansiBrightBlack" = "#4C566A";
              "terminal.ansiBrightBlue" = "#81A1C1";
              "terminal.ansiBrightCyan" = "#8FBCBB";
              "terminal.ansiBrightGreen" = "#A3BE8C";
              "terminal.ansiBrightMagenta" = "#B48EAD";
              "terminal.ansiBrightRed" = "#BF616A";
              "terminal.ansiBrightWhite" = "#ECEFF4";
              "terminal.ansiBrightYellow" = "#EBCB8B";
              "terminal.ansiCyan" = "#88C0D0";
              "terminal.ansiGreen" = "#A3BE8C";
              "terminal.ansiMagenta" = "#B48EAD";
              "terminal.ansiRed" = "#BF616A";
              "terminal.ansiWhite" = "#E5E9F0";
              "terminal.ansiYellow" = "#EBCB8B";
              "terminal.background" = "#2E3440";
              "terminal.foreground" = "#D8DEE9";
              "tree.indentGuidesStroke" = "#4C566A";
            };
            "[Gruvbox Minor Dark Medium]" = {
              "editorBracketHighlight.foreground1" = "#fb4934";
              "editorBracketHighlight.foreground2" = "#b8bb26";
              "editorBracketHighlight.foreground3" = "#fabd2f";
              "editorBracketHighlight.foreground4" = "#83a598";
              "editorBracketHighlight.foreground5" = "#d3869b";
              "editorBracketHighlight.foreground6" = "#8ec07c";
              "editorBracketPairGuide.activeBackground1" = "#fb493464";
              "editorBracketPairGuide.activeBackground2" = "#b8bb2664";
              "editorBracketPairGuide.activeBackground3" = "#fabd2f64";
              "editorBracketPairGuide.activeBackground4" = "#83a59864";
              "editorBracketPairGuide.activeBackground5" = "#d3869b64";
              "editorBracketPairGuide.activeBackground6" = "#8ec07c64";
              "tree.indentGuidesStroke" = "#665c54";
            };
          };
          "workbench.editor.closeEmptyGroups" = false;
          "workbench.editor.labelFormat" = "short";
          "workbench.editor.untitled.labelFormat" = "name";
          "workbench.editor.wrapTabs" = true;
          "workbench.list.smoothScrolling" = true;
          "workbench.panel.defaultLocation" = "right";
          "workbench.startupEditor" = "none";
          "workbench.tree.enableStickyScroll" = true;
          "workbench.tree.indent" = 12;
          "workbench.tree.renderIndentGuides" = "always";
          "i18n-ally.ignoredLocales" = [ ];
          "html.hover.references" = false;
          "css.hover.references" = false;
          "[svg]" = {
            "editor.defaultFormatter" = "jock.svg";
          };
          "gitlens.currentLine.enabled" = false;
          "continue.showInlineTip" = false;
          "[json]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };
          "terminal.integrated.enableMultiLinePasteWarning" = "never";
          "workbench.externalBrowser" = "/usr/bin/flatpak run app.zen_browser.zen";
          "[xml]" = {
            "editor.defaultFormatter" = "redhat.vscode-xml";
          };
          "playwright.reuseBrowser" = false;
          "playwright.showTrace" = false;
          "xml.server.vmargs" = "-Xmx128M";
          "sherlock.userId" = "5a57ae87-af19-4a54-894f-795eb336ea14";
          "sherlock.previewLanguageTag" = "en";
          "git.openRepositoryInParentFolders" = "never";
          "maven.executable.path" = "/opt/apache-maven-3.9.9/bin/mvn";
          "gitlens.ai.experimental.model" = "vscode";
          "gitlens.ai.experimental.vscode.model" = "copilot =o1";
          "dbcode.history.enabled" = true;
          "dbcode.ai.modelId" = "gpt-3.5-turbo";
          "typescript.updateImportsOnFileMove.enabled" = "never";
          "cmake.showOptionsMovedNotification" = false;
          "files.exclude" = {
            "**/.DS_Store" = false;
          };
          "makefile.configureOnOpen" = true;
          "terminal.integrated.gpuAcceleration" = "off";
          "database-client.autoSync" = true;
          "[sql]" = {
            "editor.defaultFormatter" = "cweijan.vscode-mysql-client2";
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
          };
          "mdb.confirmRunAll" = false;
          "mdb.confirmRunCopilotCode" = false;
          "markdown.extension.tableFormatter.normalizeIndentation" = true;
          "terminal.integrated.stickyScroll.enabled" = false;
          "editor.fontSize" = 16;
          "terminal.integrated.sendKeybindingsToShell" = true;
          "github.copilot.nextEditSuggestions.enabled" = false;
          "[shellscript]" = {
            "editor.defaultFormatter" = "mads-hartmann.bash-ide-vscode";
          };
          "chat.instructionsFilesLocations" = {
            ".github/instructions" = true;
            "/tmp/postman-http-request-post-response.instructions.md" = true;
            "/tmp/postman-http-request-pre-request.instructions.md" = true;
            "/tmp/postman-collections-post-response.instructions.md" = true;
            "/tmp/postman-collections-pre-request.instructions.md" = true;
            "/tmp/postman-folder-post-response.instructions.md" = true;
            "/tmp/postman-folder-pre-request.instructions.md" = true;
          };
          "docker.extension.enableComposeLanguageServer" = false;
          "[yaml]" = {
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "[dockercompose]" = {
            "editor.insertSpaces" = true;
            "editor.tabSize" = 2;
            "editor.autoIndent" = "advanced";
            "editor.quickSuggestions" = {
              "other" = true;
              "comments" = false;
              "strings" = true;
            };
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "[github-actions-workflow]" = {
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "workbench.iconTheme" = "vscode-jetbrains-icon-theme-2023-auto";
          "gitlens.ai.model" = "vscode";
          "gitlens.ai.vscode.model" = "copilot =gpt-4.1";
          "dart.flutterHotReloadOnSave" = "all";
          "postman.mcp.notifications.postmanMCP" = false;
          "python.analysis.typeCheckingMode" = "standard";
          "java.configuration.runtimes" = [ ];
          "githubLocalActions.actCommand" = "gh act";
          "material-code.primaryColor" = "#4C3D50";
          "window.newWindowProfile" = "Default";
          "workbench.colorTheme" = "Material Code";
          "window.dialogStyle" = "custom";
          "window.menuBarVisibility" = "visible";
          "material-code.syntaxTheme" = "GitHub Dark";
        };
      };
    }) profiles
  );
}
