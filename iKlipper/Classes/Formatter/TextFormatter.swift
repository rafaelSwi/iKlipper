import Foundation

final class TextFormat {
    
    enum ParenthesesContentMethod {
        case removeParenthesesContent
        case extractParenthesesContent
        case none
    }
    
    static func parenthesesContent(_ input: String, _ method: ParenthesesContentMethod) -> String {
        
        let regex = try! NSRegularExpression(pattern: "\\(([^()]+)\\)")
        
        switch method {
        case .removeParenthesesContent:
            var output = regex.stringByReplacingMatches(
                in: input,
                options: [],
                range: NSRange(location: 0, length: input.utf16.count),
                withTemplate: ""
            )
            output = output.trimmingCharacters(in: .whitespaces)
            return output
        case .extractParenthesesContent:
            let matches = regex.matches(
                in: input,
                options: [],
                range: NSRange(location: 0, length: input.utf16.count)
            )
            
            let extractedContent = matches.map { match in
                let range = match.range(at: 1)
                return (input as NSString).substring(with: range)
            }
            
            return extractedContent.joined(separator: "")
        case .none:
            return input
        }
    }
    
    static func beauty (_ string: String, _ method: TextFormat.ParenthesesContentMethod) -> String {
        var str = string
        let prefixes = ["USB/", "SX1", "SX2"]
        for prefix in prefixes {
            if str.uppercased().hasPrefix(prefix) {
                for _ in 0...prefix.count {
                    str.removeFirst()
                }
            }
        }
        let components = str.components(separatedBy: ".")
        if components.count > 1 {
            str = components.dropLast().joined(separator: ".")
        }
        switch method {
        case .removeParenthesesContent:
            let result = parenthesesContent(str, .removeParenthesesContent)
            return result.capitalized
        case .extractParenthesesContent:
            let result = parenthesesContent(str, .extractParenthesesContent)
            return result.capitalized
        case .none:
            return str.capitalized
        }
    }
    
    static func doesHasPrefix (_ filepath: String, _ prfx: String) -> Bool {
        let fp: String = filepath.uppercased()
        return fp.hasPrefix(prfx) || fp.hasPrefix("USB/\(prfx)")
    }
    
}
