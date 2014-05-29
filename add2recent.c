#include <gtk/gtk.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv) { 
  if (argc <= 1) {
    fprintf(stderr, "%s: usage: %s [files]\n", argv[0], argv[0]);
    return 1;
  }
  GtkRecentManager *manager;
  manager = gtk_recent_manager_get_default ();
  for (int i = 1; i < argc; ++i) {
    gboolean ret_val = gtk_recent_manager_add_item (manager, argv[i]);
    if (!ret_val) {
      fprintf(stderr, "%s: adding '%s' to the list of recent files failed\n", argv[0], argv[i]);
    } else {
      int size = 50 + sizeof(argv[i]);
      char * command = (char*)malloc(size);
      snprintf(command, size, "touch \"%s\"", argv[i]);
      system(command);
    }
  }
  return 0; 
}
