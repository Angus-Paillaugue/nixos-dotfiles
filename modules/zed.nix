{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    zed.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Zed Editor";
    };
  };

  config = lib.mkIf config.zed.enable {
    home.packages = with pkgs; [
      zed-editor
    ];

    programs.zed-editor = {
      enable = true;
      defaultEditor = true;
      extensions = [
        "html"
        "toml"
        "make"
        "lua"
        "svelte"
        "nix"
        "jetbrains-new-ui-icons"
        "fish"
        "comment"
      ];
      userKeymaps = [
        {
          context = "Editor";
          bindings = {
            alt-right = [
              "editor::MoveToEndOfLine"
              {
                "stop_at_soft_wraps" = false;
              }
            ];
          };
        }
        {
          context = "Editor";
          unbind = {
            end = [
              "editor::MoveToEndOfLine"
              {
                "stop_at_soft_wraps" = true;
              }
            ];
          };
        }

        {
          context = "Editor";
          bindings = {
            alt-left = [
              "editor::MoveToBeginningOfLine"
              {
                "stop_at_soft_wraps" = false;
                "stop_at_indent" = true;
              }
            ];
          };
        }
        {
          context = "Editor";
          unbind = {
            home = [
              "editor::MoveToBeginningOfLine"
              {
                "stop_at_soft_wraps" = true;
                "stop_at_indent" = true;
              }
            ];
          };
        }
      ];
      userSettings = {
        disable_ai = false;
        show_edit_predictions = true;
        language_models = {
          ollama = {
            api_url = "https://ollama.home.paillaugue.fr";
          };
        };
        focus_follows_mouse = {
          debounce_ms = 100;
          enabled = true;
        };
        extend_comment_on_newline = false;
        ssh_connections = [
          {
            host = "debian";
            args = [ ];
            projects = [
              {
                paths = [
                  "/mnt"
                ];
              }
            ];
          }
        ];
        inlay_hints = {
          show_background = false;
          show_parameter_hints = true;
          show_other_hints = true;
          show_type_hints = false;
          show_value_hints = true;
          enabled = false;
        };
        diagnostics = {
          inline = {
            enabled = true;
          };
        };
        colorize_brackets = true;
        icon_theme = "JetBrains New UI Icons (Dark)";
        cli_default_open_behavior = "new_window";
        proxy = "";
        edit_predictions = {
          mode = "eager";
          copilot = {
            enable_next_edit_suggestions = false;
          };
          disabled_globs = [
            "**/node_modules/**"
            "**/dist/**"
            "**/build/**"
            "**/.git/**"
            "**/.env"
          ];
          provider = "copilot";
          ollama = {
            model = "qwen2.5-coder:1.5b";
            api_url = "https://ollama.home.paillaugue.fr";
          };
        };
        prettier = {
          allowed = false;
        };
        outline_panel = {
          dock = "left";
        };
        collaboration_panel = {
          dock = "left";
        };
        agent = {
          default_profile = "ask";
          sidebar_side = "right";
          dock = "right";
          model_parameters = [ ];
        };
        git_panel = {
          dock = "left";
        };
        agent_servers = {
          github-copilot-cli = {
            type = "registry";
          };
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        session = {
          trust_all_worktrees = true;
        };
        terminal = {
          shell = {
            program = "fish";
          };
          dock = "right";
          font_size = 16.0;
          font_family = "JetBrainsMono Nerd Font";
          cursor_shape = "bar";
          max_scroll_history_lines = 10000;
        };
        project_panel = {
          dock = "left";
          auto_fold_dirs = false;
        };
        git = {
          inline_blame = {
            enabled = false;
          };
        };
        base_keymap = "VSCode";
        sticky_scroll = {
          enabled = true;
        };
        mouse_wheel_zoom = false;
        minimap = {
          max_width_columns = 1;
        };
        cursor_blink = true;
        autosave = {
          after_delay = {
            milliseconds = 1000;
          };
        };
        buffer_font_family = "JetBrainsMono Nerd Font";
        auto_indent_on_paste = true;
        ensure_final_newline_on_save = true;
        indent_guides = {
          enabled = true;
        };
        soft_wrap = "editor_width";
        tab_size = 2;
        ui_font_size = 16;
        buffer_font_size = 16.0;
        theme = {
          mode = "dark";
          light = "Noctalia Light";
          dark = "Noctalia Dark";
        };
        toolbar = {
          breadcrumbs = false;
          quick_actions = false;
        };
        lsp = {
          vtsls = {
            settings = {
              typescript = {
                updateImportsOnFileMove = {
                  enabled = "always";
                };
              };
              javascript = {
                updateImportsOnFileMove = {
                  enabled = "always";
                };
              };
            };
            enable_lsp_tasks = true;
          };
          tailwindcss-language-server = {
            settings = {
              includeLanguages = {
                svelte = "html";
              };
              experimental = {
                classRegex = [
                  "class=\"([^\"]*)\""
                  "class='([^']*)'"
                  "class:\\s*([^\\s{]+)"
                  "\\{\\s*class:\\s*\"([^\"]*)\""
                  "\\{\\s*class:\\s*'([^']*)'"
                  "\\.className\\s*[+]?=\\s*['\"]([^'\"]*)['\"]"
                  "\\.setAttributeNS\\(.*,\\s*['\"]class['\"],\\s*['\"]([^'\"]*)['\"]"
                  "\\.setAttribute\\(['\"]class['\"],\\s*['\"]([^'\"]*)['\"]"
                  "\\.classList\\.add\\(['\"]([^'\"]*)['\"]"
                  "\\.classList\\.remove\\(['\"]([^'\"]*)['\"]"
                  "\\.classList\\.toggle\\(['\"]([^'\"]*)['\"]"
                  "\\.classList\\.contains\\(['\"]([^'\"]*)['\"]"
                  "\\.classList\\.replace\\(\\s*['\"]([^'\"]*)['\"]"
                  "\\.classList\\.replace\\([^,)]+,\\s*['\"]([^'\"]*)['\"]"
                  "\\.className\\s*[+]?=\\s*['\"]([^'\"]*)['\"]"
                ];
              };
            };
          };
        };
      };
    };
  };
}
