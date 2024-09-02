//
//  WordList.swift
//  inkwell
//
//  Created by Kristen Swanson on 8/31/24.
//

import Foundation

struct WordList {
    static let suffixes = [
        "ing", "y", "es", "ies", "s", "d", "ed", "ness",
        "-like", "-shaped", "-thin", "-sweet", "half-"
    ]
    
    static let common = [
        "a", "an", "the", "there", "is", "these", "those", "are", "they", "their",
        "she", "her", "he", "his", "me", "let", "I", "for", "am", "you", "because",
        "if", "be", "to", "too", "of", "in", "have", "first", "not", "on", "as", "at",
        "but", "by", "do", "from", "or", "will", "so", "get", "give", "would", "could",
        "should", "was", "go", "might", "were", "your", "us", "we", "them", "like",
        "let's", "and", "oh", "myself", "yourself", "anything", "nothing", "everything",
        "who", "what", "when", "come", "came", "where", "why", "won't", "see", "my",
        "within", "more", "no", "want", "toward"
    ]
    
    static let nouns = [
        "tree", "leaf", "star", "rose", "thing", "mushroom", "toadstool", "willow",
        "canopy", "witch", "goddess", "mother", "stillness", "mistress", "stream",
        "meadow", "deer", "pond", "gate", "crystal", "river", "cave", "mystery",
        "cliff", "forest", "woods", "chains", "bat", "owl", "butterfly", "moth",
        "serpent", "mermaid", "frog", "toad", "creature", "wolf", "cat", "bird",
        "fog", "wing", "insect", "critter", "poison", "rainwater", "storm", "weapon",
        "hunger", "acid", "wood", "star", "passion", "moon", "garden", "vine", "iris",
        "azalea", "pine", "petal", "dawn", "vision", "sky", "throat", "cloud", "bough",
        "lilac", "silver", "cream", "strength", "desert", "light", "shadow", "dew",
        "myth", "sea-foam", "honey", "nectar", "face", "gloam", "body", "weakness",
        "pollen", "snow", "savage", "sand", "mist", "tea", "bark", "rebirth", "death",
        "eternity", "mercy", "mouth", "blood", "sword", "spirit", "burial", "destruction",
        "elixir", "teeth", "scent", "morning", "evening", "night", "tide", "seawater",
        "coffee", "neck", "glass", "pearl", "monster", "flower", "earth", "woman",
        "shield", "pattern", "hole", "dessert", "salt", "hope", "temple", "space",
        "serendipity", "bubble", "twilight", "growth", "hand", "war", "limit", "outside",
        "violence", "dawn", "sorrow", "stem", "cowardice", "sandbar", "dusk", "blood",
        "eyes", "life", "mind", "blossom", "labor", "voice", "honeydew", "unknown",
        "sunbeam", "home", "moment", "warrior", "day", "gum", "midday", "catharsis",
        "tongue", "haze", "birth", "afternoon", "pain", "wilderness", "lagoon",
        "planet", "arch"
    ]
    
    static let verbs = [
        "hang", "say", "tell", "ask", "caught", "find", "shine", "listen", "dry",
        "glitter", "nestle", "flicker", "glow", "soul", "form", "cloak", "walk",
        "fade", "sparkle", "choice", "cling", "shape", "dig", "hover", "remind",
        "pulse", "break", "crawl", "incense", "smile", "hold", "create", "drift",
        "crack", "stay", "drip", "flash", "sweep", "know", "writhe", "bloom", "brim",
        "awake", "asleep", "grow", "bask", "fold", "split", "splinter", "ignite",
        "illuminate", "intensify", "gravitate", "clutch", "cower", "lie", "swallow",
        "soar", "shrivel", "shimmer", "crunch", "float", "breathe", "weave", "make",
        "crush", "bounce", "veil", "soak", "shrink", "warp", "reflect", "reach",
        "tremble", "whisper", "haunt", "bend", "pulsate", "push", "obliterate",
        "smooth", "roam", "love", "dive", "crash", "settle", "stretch", "blink",
        "awaken", "rush", "curl", "pull", "edge", "glide", "embrace", "lurch",
        "electrify", "roar", "squeeze", "grasp", "fragment", "catapult", "surrender",
        "march", "howl", "decay", "growl", "groan", "smell", "look", "forgive",
        "scream", "lungs", "weep", "devastate", "shatter", "watch", "dance", "touch",
        "show", "believe", "tell", "ask"
    ]
    
    static let adjectives = [
        "cool", "pale", "sharp", "sacred", "beautiful", "dark", "infinite", "unhurried",
        "flat", "strange", "outer", "fair", "fresh", "quiet", "dear", "empty", "magical",
        "pretty", "deep", "dying", "first", "uninterrupted", "round", "crimson", "young",
        "other", "alive", "patient", "starless", "cheap", "feral", "brittle", "tight",
        "half-lit", "cascading", "full", "bright", "fringed", "forbidden", "tangled",
        "sunless", "twisted", "unsteady", "mystical", "silken", "soft", "still", "sweet",
        "warm", "short", "open", "unsettled", "sleepy", "powerful", "perfumed", "wet",
        "burnt", "long", "snowy", "thick", "stagnant", "purple", "black", "green",
        "pink", "yellow", "blue", "red", "orange", "violet", "loose", "broken", "milky",
        "unyielding", "bleak", "bewitched", "bruised", "cloudy", "cruel", "deadly",
        "dry", "electric", "fearless", "frozen", "funny", "glistening", "glossy",
        "growing", "hasty", "hollow", "hoarse", "hot", "hungry", "idle", "knowing",
        "leafy", "lost", "low", "melodic", "mild", "misty", "modest", "muddy",
        "mysterious", "necessary", "new", "normal", "obvious", "old", "open", "plump",
        "proud", "pure", "raw", "rich", "ripe", "sandy", "scarce", "shimmering",
        "slight", "small", "steel", "tender", "thorny", "tired", "twin", "useful",
        "vacant", "vivid", "warlike", "weak", "weird", "wild", "wooden"
    ]
    
    static let adverbs = [
        "warmly", "barely", "sleepily", "sadly", "slowly", "here", "there", "clumsily",
        "curiously", "wistfully", "farthest", "endlessly", "darkest", "boldly",
        "brightly", "terribly", "always", "sickly", "often", "tomorrow", "quickly",
        "safely", "quietly", "wildly", "hard", "fast", "bravely", "however",
        "nonetheless", "clearly", "easily", "fiercely", "foolishly", "heavily",
        "wisely", "wearily", "unwillingly", "ultimately", "suddenly", "shakily",
        "seemingly", "rarely", "obediently", "naturally", "increasingly",
        "noiselessly", "deafeningly", "weakly", "cruelly"
    ]
    
    static let prepositions = [
        "above", "about", "around", "between", "despite", "except", "without", "within",
        "beside", "among", "beneath", "across", "before", "behind", "below", "onto",
        "inside", "under", "up", "with", "over", "away", "along", "next", "underneath",
        "until"
    ]

    static func getRandomWords() -> [(String, String)] {
        let randomCommons = Array(common.shuffled().prefix(2)).map { ($0, "common") }
        let randomNouns = Array(nouns.shuffled().prefix(2)).map { ($0, "noun") }
        let randomVerbs = Array(verbs.shuffled().prefix(2)).map { ($0, "verb") }
        let randomAdjectives = Array(adjectives.shuffled().prefix(1)).map { ($0, "adjective") }
        let randomAdverb = (adverbs.randomElement() ?? "", "adverb")
        let randomPreposition = (prepositions.randomElement() ?? "", "preposition")

        return randomCommons + randomNouns + randomVerbs + randomAdjectives + [randomAdverb, randomPreposition]
    }

    static func getPuzzleOfTheDay() -> [(String, String)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: Date())
        
        var generator = SeededRandomNumberGenerator(seed: dateString.hash)
        let randomCommons = Array(common.shuffled(using: &generator).prefix(2)).map { ($0, "common") }
        let randomNouns = Array(nouns.shuffled(using: &generator).prefix(2)).map { ($0, "noun") }
        let randomVerbs = Array(verbs.shuffled(using: &generator).prefix(2)).map { ($0, "verb") }
        let randomAdjectives = Array(adjectives.shuffled(using: &generator).prefix(2)).map { ($0, "adjective") }
        let randomAdverb = (adverbs.shuffled(using: &generator).first ?? "", "adverb")
        let randomPreposition = (prepositions.shuffled(using: &generator).first ?? "", "preposition")
        
        return randomCommons + randomNouns + randomVerbs + randomAdjectives + [randomAdverb, randomPreposition]
    }
}

//// Add this struct for seeded random number generation
//struct SeededRandomNumberGenerator: RandomNumberGenerator {
//    let seed: Int
//    var currentValue: Int
//
//    init(seed: Int) {
//        self.seed = seed
//        self.currentValue = seed
//    }
//
//    mutating func next() -> UInt64 {
//        currentValue = (currentValue &* 1103515245 &+ 12345) & 0x7FFFFFFF
//        return UInt64(currentValue)
//    }
//}
