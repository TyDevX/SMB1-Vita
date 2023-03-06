# Compiler flags
CXXFLAGS := -std=c++11 -Wno-c++11-narrowing

# Directories
SRC_DIR := source
CODEGEN_DIR := codegen

# Source files
SOURCE_FILES := \
	$(SRC_DIR)/Configuration.cpp \
	$(SRC_DIR)/Main.cpp \
	$(SRC_DIR)/Emulation/APU.cpp \
	$(SRC_DIR)/Emulation/Controller.cpp \
	$(SRC_DIR)/Emulation/MemoryAccess.cpp \
	$(SRC_DIR)/Emulation/PPU.cpp \
	$(SRC_DIR)/SMB/SMB.cpp \
	$(SRC_DIR)/SMB/SMBData.cpp \
	$(SRC_DIR)/SMB/SMBEngine.cpp \
	$(SRC_DIR)/Util/Video.cpp

# Libraries
LIBRARIES := -lSDL2

# Build targets
smbc: $(CODEGEN_DIR) $(SOURCE_FILES)
	$(CXX) $(CXXFLAGS) -o $@ $(SOURCE_FILES) $(LIBRARIES)

# Build code generation
$(CODEGEN_DIR):
	$(MAKE) -C $(CODEGEN_DIR)
	
# Clean targets
clean:
	$(RM) smbc
	$(MAKE) -C $(CODEGEN_DIR) clean
