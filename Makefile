PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
DATADIR = $(PREFIX)/share
APPDIR = $(DATADIR)/applications
ICONDIR = $(DATADIR)/icons/hicolor/128x128/apps

CC = gcc
CFLAGS = `pkg-config --cflags gtk4 libadwaita-1 vte-2.91-gtk4` -Wno-deprecated-declarations
LIBS = `pkg-config --libs gtk4 libadwaita-1 vte-2.91-gtk4`
TARGET = holy.sh
SRC = src/main.c

DESKTOP_FILE = app/holy.sh.desktop
ICON_FILE = app/icons/hicolor/128x128/apps/holy.sh.png

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(SRC) -o $(TARGET) $(CFLAGS) $(LIBS)
	chmod +x $(TARGET)

install: all
	install -D -m 755 $(TARGET) $(DESTDIR)$(BINDIR)/$(TARGET)
	install -D -m 644 $(DESKTOP_FILE) $(DESTDIR)$(APPDIR)/holy.sh.desktop
	install -D -m 644 $(ICON_FILE) $(DESTDIR)$(ICONDIR)/holy.sh.png
	-gtk-update-icon-cache -f -t $(DATADIR)/icons/hicolor
	-update-desktop-database $(APPDIR)

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(TARGET)
	rm -f $(DESTDIR)$(APPDIR)/holy.sh.desktop
	rm -f $(DESTDIR)$(ICONDIR)/holy.sh.png

clean:
	rm -f $(TARGET)

.PHONY: all install uninstall clean