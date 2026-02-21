#include <adwaita.h>
#include <vte/vte.h>

static void
activate (GtkApplication *app, gpointer user_data)
{
    GtkWidget *window = adw_application_window_new (app);
    gtk_window_set_title (GTK_WINDOW (window), "Terminal");
    gtk_window_set_default_size (GTK_WINDOW (window), 800, 600);

    VteTerminal *terminal = VTE_TERMINAL (vte_terminal_new ());

    char *shell = vte_get_user_shell ();
    if (!shell) shell = "/bin/bash";
    gchar *argv[] = { shell, NULL };

    GError *error = NULL;
    pid_t pid;
    gboolean success = vte_terminal_spawn_sync (terminal,
                                               VTE_PTY_DEFAULT,
                                               NULL,
                                               argv,
                                               NULL,
                                               G_SPAWN_SEARCH_PATH,
                                               NULL, NULL,
                                               &pid,
                                               NULL,
                                               &error);

    if (!success) {
        g_critical ("Can't launch shell: %s", error->message);
        g_error_free (error);
    }

    vte_terminal_set_mouse_autohide (terminal, TRUE);
    vte_terminal_set_scrollback_lines (terminal, -1);

    adw_application_window_set_content (ADW_APPLICATION_WINDOW (window), GTK_WIDGET (terminal));

    gtk_window_present (GTK_WINDOW (window));
}

int
main (int argc, char **argv)
{
    AdwApplication *app = adw_application_new ("org.example.Terminal", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
    int status = g_application_run (G_APPLICATION (app), argc, argv);
    g_object_unref (app);
    return status;
}