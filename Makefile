BIN_DIR := bin
GUIDELINE_FOLDER := guidelines
SKILLS_FOLDER := skills

.PHONY: pack

## pack: create a tar.gz archive of the bin/ folder
pack:
	mkdir -p $(BIN_DIR)
	tar -czf $(BIN_DIR)/$(GUIDELINE_FOLDER).tar.gz $(GUIDELINE_FOLDER)
	tar -czf $(BIN_DIR)/$(SKILLS_FOLDER).tar.gz $(SKILLS_FOLDER)
	cd $(BIN_DIR) && sha256sum $(GUIDELINE_FOLDER).tar.gz $(SKILLS_FOLDER).tar.gz > checksums.sha256
