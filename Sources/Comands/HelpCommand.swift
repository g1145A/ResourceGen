import Foundation

func printHelp() {
    print("""
    Usage: GenerateCommand [command]
    Generate colors and constants from a text file exported from Figma using this plugin: [Variables2CSS](https://www.figma.com/community/plugin/1261234393153346915/variables2css).
    
    Commands:
    help        Show this help message
    colors      generate colors from a text file
                colors  --path PathTo/etln-colors.txt --output PathTo/Colors
    
    constants   generate constans from a text file
                colors  --path PathTo/etln-colors.txt --output PathTo/Constants
    
    fonts       generate fonts from a text file
                fonts  --path PathTo/etln-colors.txt --output PathTo/Fonts
    """)
}
