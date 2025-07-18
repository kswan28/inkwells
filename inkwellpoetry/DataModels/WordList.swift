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
    
    static let swiftynouns = [
        "lavender", "incense", "rosé", "maroon", "ruby", "wine", "legacy", "hero", "rose", "starlight",
        "moonstone", "karma", "vigilante", "champagne", "poets", "muse", "aurora", "Windermere", "Wicklow", "neon",
        "streetlight", "sapphire", "cat", "cheeks", "skies", "whisper", "storyline", "pen", "signature", "mirror", "soul",
        "memories", "bloodstain", "collarbone", "cruelty", "ghost", "crown", "machine", "lightning", "trophies", "fireside",
        "eyelids", "graveyard", "secrets", "predictions", "islands", "fables", "stardust", "promises", "headlines", "storyline",
        "afternoon", "phantom", "currents", "spotlight", "cheerleaders", "fireworks", "daisies", "champion", "battle", "mistake",
        "dreams", "storyline", "vows", "stars", "ashes", "petals", "stones", "tattoo", "windows", "thunder", "symphony", "wilderness",
        "footprints", "rooftops", "shadow", "snowstorm"
      ]
    
    static let spookynouns = [
        "ghost", "pumpkin", "witch", "bat", "skeleton", "zombie", "vampire", "werewolf",
        "monster", "goblin", "spider", "web", "cat", "owl", "moon", "star", "night",
        "shadow", "costume", "mask", "candy", "treat", "trick", "cauldron", "broom",
        "wand", "potion", "spell", "curse", "mummy", "tomb", "grave", "cemetery",
        "castle", "dungeon", "tower", "fog", "mist", "cloud", "wind", "thunder",
        "lightning", "rain", "storm", "leaf", "branch", "tree", "forest", "jack-o-lantern",
        "candle", "lantern", "flashlight", "darkness", "attic", "basement", "closet",
        "mirror", "reflection", "shadow", "silhouette", "footstep", "whisper", "howl",
        "screech", "hoot", "creak", "rattle", "clank", "thud", "boo", "cobweb",
        "dust", "bone", "skull", "eye", "fang", "claw"
      ]
    
    static let merrynouns = [
        "snow", "ice", "snowflake", "blizzard", "frost", "icicle", "winter", "snowman",
        "sled", "skates", "skis", "mittens", "gloves", "scarf", "hat", "earmuffs",
        "boots", "coat", "sweater", "blanket", "fireplace", "cocoa", "marshmallow",
        "cookie", "gingerbread", "candy", "chocolate", "present", "gift", "ribbon",
        "bow", "wrapping", "paper", "card", "letter", "stamp", "envelope", "address",
        "party", "celebration", "feast", "dinner", "family", "friend", "guest",
        "host", "home", "house", "cabin", "chimney", "roof", "window", "door",
        "wreath", "holly", "ivy", "mistletoe", "pine", "spruce", "fir", "branch",
        "needle", "cone", "tree", "ornament", "star", "angel", "bell", "candle",
        "light", "lamp", "lantern", "tinsel", "garland", "decoration", "stocking",
        "candy cane", "reindeer", "sleigh", "Santa", "elf", "workshop", "North Pole",
        "menorah", "dreidel", "gelt", "latke", "sufganiyot", "oil", "temple",
        "miracle", "shamash", "wax", "flame", "blessing", "prayer", "song", "game",
        "gift", "night", "story", "tradition", "village", "town", "city", "square",
        "shop", "store", "market", "mall", "money", "coin", "dollar", "sale",
        "shopping", "list", "carol", "music", "song", "singer", "choir", "bell",
        "chime", "ring", "sound", "echo", "voice", "laugh", "smile", "joy",
        "peace", "hope", "wish", "dream", "wonder", "magic", "sparkle", "shine",
        "glow", "twinkle", "flicker", "flash", "ray", "beam", "sun", "moon",
        "sky", "cloud", "storm", "wind", "breeze", "chill", "frost", "crystal",
        "pearl", "silver", "gold", "metal", "glass", "wood", "cloth", "fabric",
        "silk", "wool", "cotton", "fleece", "velvet", "ribbon", "lace", "pattern",
        "design", "shape", "swirl", "spiral", "circle", "square", "heart"
      ]
    
    static let naturenouns = [
        "acorn", "air", "alligator", "ant", "antelope", "apple", "autumn", "avalanche",
            "bamboo", "bark", "beach", "bear", "beaver", "bee", "beetle", "berry",
            "bird", "blossom", "breeze", "brook", "bud", "buffalo", "butterfly", "cactus",
            "canyon", "cardinal", "caterpillar", "cave", "cheetah", "chipmunk", "cliff",
            "cloud", "coast", "cocoon", "coconut", "coral", "crab", "creek", "cricket",
            "crocodile", "crow", "crystal", "daisy", "dandelion", "dawn", "deer",
            "desert", "dew", "dirt", "dolphin", "dove", "dragonfly", "dusk", "eagle",
            "earth", "earthquake", "egg", "elephant", "elk", "elm", "feather", "fern",
            "field", "firefly", "fish", "flamingo", "flood", "flower", "fog", "forest",
            "fox", "frog", "frost", "garden", "geyser", "giraffe", "glacier", "gorilla",
            "grass", "grasshopper", "grove", "ground", "groundhog", "grove", "habitat",
            "hail", "harbor", "hawk", "hedgehog", "hill", "hippopotamus", "hive",
            "horizon", "hornet", "horse", "hummingbird", "hurricane", "hyena", "ice",
            "iguana", "insect", "island", "ivy", "jackal", "jaguar", "jellyfish",
            "jungle", "kangaroo", "kingfisher", "koala", "lake", "lamb", "landscape",
            "leaf", "leopard", "lichen", "lightning", "lily", "lion", "lizard", "llama",
            "lotus", "manatee", "maple", "meadow", "mist", "monkey", "moose", "moss",
            "mountain", "mouse", "mushroom", "nest", "newt", "night", "oak", "ocean",
            "octopus", "opossum", "orangutan", "orchid", "ostrich", "otter", "owl",
            "oxygen", "oyster", "palm", "panda", "panther", "parrot", "peacock",
            "pebble", "pelican", "penguin", "petal", "pigeon", "pine", "planet",
            "plant", "platypus", "pond", "porcupine", "prairie", "rabbit", "raccoon",
            "rain", "rainbow", "rainforest", "rapids", "ravine", "reef", "rhinoceros",
            "river", "robin", "rock", "rose", "salamander", "salmon", "sand", "sapling",
            "sea", "seagull", "seal", "season", "shark", "shell", "shore", "shrew",
            "shrub", "skunk", "sky", "sleet", "sloth", "slug", "snail", "snake",
            "snow", "soil", "sparrow", "spider", "spring", "squirrel", "star", "starfish",
            "stick", "stone", "storm", "stream", "summer", "sun", "sunflower", "sunrise",
            "sunset", "swan", "swamp", "tadpole", "thistle", "thunder", "tiger", "toad",
            "tornado", "tortoise", "tree", "tundra", "turkey", "turtle", "twilight",
            "typhoon", "valley", "vine", "violet", "volcano", "vulture", "walrus",
            "wasp", "water", "waterfall", "wave", "weed", "whale", "wildflower", "willow",
            "wind", "winter", "wolf", "woodpecker", "worm", "yak", "zebra", "zebu",
            "zinnia", "zoo"
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
    
    static let swiftyverbs = [
        "whisper", "haunt", "paint", "ignite", "carve", "bleed", "linger", "glow", "vibe", "sparkle",
        "echo", "grin", "crash", "bend", "roar", "drown", "shatter", "chase", "pierce", "shine",
        "embrace", "crumble", "scream", "vanish", "explode", "collapse", "pulse", "collapse", "freeze", "collide",
        "caress", "drift", "hiss", "gather", "tear", "curse", "sway", "howl", "sigh", "murmur",
        "weave", "fall", "blaze", "weave", "rush", "etch", "glimmer", "swoon", "erupt", "ripple",
        "reverberate", "swirl", "echo", "sink", "sweep", "twist", "devour", "tangle", "glow", "rush",
        "burn", "whirl", "weep", "tremble", "flicker", "shimmer", "trace", "burst", "sprint", "crawl",
        "fade", "slam", "soar", "roam", "scatter", "collapse", "wade", "breathe"
      ]
    
    static let spookyverbs = [
        "haunt", "scare", "frighten", "spook", "creep", "lurk", "hide", "sneak",
        "pounce", "howl", "growl", "hiss", "screech", "whisper", "moan", "groan",
        "rattle", "shake", "shiver", "tremble", "quake", "float", "hover", "glide",
        "swoop", "flap", "crawl", "slither", "slink", "scurry", "dash", "vanish",
        "appear", "transform", "morph", "change", "disguise", "mask", "conceal",
        "reveal", "uncover", "discover", "enchant", "bewitch", "cast", "conjure",
        "summon", "banish", "exorcise", "hunt", "chase", "pursue", "escape", "flee",
        "run", "hurry", "rush", "tiptoe", "creep", "sneak", "skulk", "prowl",
        "stalk", "loom", "tower", "shadow", "darken", "dim", "glow", "shine",
        "flicker", "flash", "blink", "wink", "stare", "glare", "leer"
      ]
    
    static let merryverbs = [
        "snow", "freeze", "frost", "chill", "shiver", "bundle", "wrap", "cover",
        "protect", "warm", "heat", "toast", "bake", "cook", "simmer", "boil",
        "prepare", "mix", "stir", "blend", "sprinkle", "dust", "sparkle", "shine",
        "glow", "twinkle", "flicker", "flash", "beam", "radiate", "illuminate",
        "light", "brighten", "decorate", "trim", "adorn", "embellish", "garnish",
        "arrange", "display", "show", "present", "give", "receive", "exchange",
        "share", "spread", "distribute", "deliver", "send", "mail", "post",
        "address", "write", "sign", "seal", "stamp", "pack", "wrap", "tie",
        "secure", "tape", "glue", "stick", "attach", "connect", "join", "link",
        "bind", "fasten", "clip", "pin", "hang", "mount", "place", "position",
        "set", "adjust", "align", "center", "balance", "steady", "stabilize",
        "protect", "guard", "watch", "observe", "see", "look", "view", "witness",
        "celebrate", "party", "feast", "dine", "eat", "drink", "toast", "cheer",
        "laugh", "smile", "sing", "carol", "chant", "hum", "whistle", "play",
        "dance", "skip", "jump", "hop", "slide", "glide", "skate", "ski",
        "sled", "ride", "travel", "journey", "venture", "explore", "discover",
        "find", "seek", "search", "hunt", "gather", "collect", "accumulate",
        "store", "save", "keep", "preserve", "maintain", "hold", "carry", "lift",
        "raise", "elevate", "climb", "ascend", "rise", "soar", "float", "drift",
        "fall", "descend", "drop", "settle", "land", "rest", "pause", "stop",
        "wait", "anticipate", "expect", "hope", "wish", "dream", "imagine",
        "envision", "create", "make", "build", "construct", "craft", "shape",
        "form", "mold", "design", "plan", "organize", "arrange", "sort", "stack",
        "pile", "group", "gather", "assemble", "combine", "merge", "blend", "mix"
      ]
    
    static let natureverbs = [
        "absorb", "adapt", "age", "bask", "bend", "bite", "bloom", "blossom", "blow",
            "branch", "break", "breathe", "breed", "bristle", "budge", "build", "burrow",
            "buzz", "caw", "change", "chirp", "climb", "cloud", "crawl", "creep", "croak",
            "crunch", "decay", "decompose", "develop", "dewlap", "dig", "dive", "drip",
            "drop", "dwell", "emerge", "erode", "evolve", "expand", "fade", "fall",
            "feed", "fertilize", "filter", "float", "flood", "flow", "flower", "flutter",
            "fly", "forage", "freeze", "gallop", "germinate", "glide", "gnaw", "graze",
            "grow", "growl", "hatch", "hibernate", "hide", "hop", "hover", "howl",
            "hunt", "husk", "infest", "inhabit", "jump", "land", "lay", "leap", "live",
            "mate", "meander", "migrate", "molt", "moo", "moult", "move", "multiply",
            "nest", "nibble", "nourish", "nurture", "paddle", "perch", "photosynthesis",
            "plant", "plow", "plunge", "pollinate", "pounce", "pour", "prance", "prey",
            "propagate", "prowl", "pull", "push", "rain", "reach", "regenerate", "rest",
            "rise", "roam", "roar", "root", "rot", "run", "rustle", "scatter", "scavenge",
            "screech", "seed", "sense", "shed", "shine", "shiver", "shoot", "shrink",
            "sing", "sink", "slither", "slow", "soar", "spawn", "splash", "spread",
            "spring", "sprout", "squawk", "swim", "swoop", "take", "thrive", "thunder",
            "track", "transform", "travel", "trek", "trickle", "trumpet", "tunnel",
            "wade", "walk", "warm", "warp", "wash", "water", "wave", "weather", "weave",
            "web", "weed", "wiggle", "wilt", "wind", "wither", "wobble", "yawn", "yield",
            "bloom", "blossom", "branch", "breeze", "burrow", "buzz", "call", "canter",
            "chase", "chew", "chill", "chirp", "circle", "claw", "clear", "clutch",
            "coil", "cool", "court", "cover", "cuddle", "curl", "dance", "dart", "dash",
            "dive", "drag", "drift", "drip", "drum", "duck", "dwell", "eat", "echo",
            "edge", "emerge", "erupt", "escape", "evolve", "expand", "explore", "fade",
            "fall", "feed", "fight", "filter", "find", "fish", "flap", "flash", "flee",
            "float", "flood", "flow", "fly", "follow", "forage", "form", "freeze",
            "frolic", "gallop", "gather", "glow", "gnaw", "graze", "grow", "guard",
            "guide", "gulp", "hang", "harvest", "hatch", "heal", "hear", "hide", "hiss",
            "hit", "hoot", "hop", "hover", "howl", "huddle", "hunt", "hurry", "incubate",
            "jump", "land", "lap", "lay", "leap", "lick", "lift", "light", "live",
            "lodge", "loom", "lope", "lurk", "march", "mark", "mate", "melt", "migrate",
            "mingle", "molt", "move", "munch", "nest", "nip", "nuzzle", "open", "pace",
            "paddle", "pass", "pause", "peck", "perch", "play", "plow", "pluck", "poke",
            "pollinate", "pounce", "pour", "prance", "prowl", "prune", "pull", "punch",
            "push", "quack", "race", "rain", "raise", "rest", "return", "rise", "roam",
            "roar", "roll", "root", "roost", "rub", "run", "rush", "scatter", "scent",
            "scratch", "scurry", "seek", "shake", "shed", "shine", "shiver", "shoot",
            "shrink", "shuffle", "sing", "sink", "sit", "sleep", "slide", "slip",
            "slither", "snap", "sniff", "soar", "splash", "spray", "spread", "spring",
            "sprout", "squawk", "squeak", "squirm", "stalk", "stamp", "stand", "stay",
            "stretch", "strike", "swim", "swing", "swoop", "take", "thrive", "throw",
            "thrust", "thunder", "toss", "track", "trail", "trap", "travel", "tread",
            "tremble", "trot", "tumble", "turn", "twine", "twist", "wade", "walk",
            "wander", "warm", "wash", "watch", "water", "wave", "weave", "whistle",
            "wiggle", "wind", "wipe", "work", "wrap", "wrinkle", "yawn", "yield"
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
    
    static let swiftyadjectives = [
        "lavender", "maroon", "scarlet", "golden", "crimson", "shattered", "faded", "vivid", "hazy", "burning",
        "frantic", "twisted", "scarred", "shattered", "bruised", "timeless", "mystical", "boundless", "radiant", "frozen",
        "electric", "sacred", "reckless", "fleeting", "invisible", "untamed", "sultry", "haunting", "wild", "mysterious",
        "silent", "eternal", "fierce", "tangled", "flawless", "glistening", "blinding", "broken", "soaring", "weightless",
        "ephemeral", "brave", "tragic", "sweeping", "restless", "silken", "glowing", "bitter", "unforgiven", "fleeting",
        "velvet", "hopeless", "reckless", "battered", "thunderous", "delicate", "ashen", "twinkling", "cold", "enchanted",
        "breathless", "untouched", "silent", "vibrant", "distant", "graceful", "shadowed", "infinite", "exhausting", "faded",
        "battered", "invisible", "intangible", "noble", "poetic"
      ]
    
    static let spookyadjectives = [
        "spooky", "scary", "creepy", "eerie", "ghostly", "haunted", "mysterious", "shadowy",
        "dark", "gloomy", "misty", "foggy", "murky", "dim", "moonlit", "starry",
        "nocturnal", "supernatural", "magical", "enchanted", "cursed", "hexed", "bewitched",
        "ancient", "old", "crumbling", "dusty", "cobwebbed", "rusty", "creaky",
        "squeaky", "rattling", "clanking", "howling", "growling", "hissing", "whispering",
        "silent", "quiet", "loud", "startling", "surprising", "sudden", "swift",
        "slow", "lumbering", "sneaky", "sly", "tricky", "clever", "mischievous",
        "playful", "silly", "funny", "weird", "strange", "odd", "peculiar", "bizarre",
        "extraordinary", "unnatural", "otherworldly", "unearthly", "skeletal", "bony",
        "fanged", "clawed", "furry", "scaly", "slimy", "sticky", "gooey", "oozy",
        "smoky", "wispy", "flickering", "glowing", "shimmering"
      ]
    
    static let merryadjectives = [
        "snowy", "icy", "frosty", "frozen", "cold", "chilly", "crisp", "cool",
        "wintry", "seasonal", "festive", "merry", "jolly", "cheerful", "happy",
        "joyful", "peaceful", "quiet", "silent", "still", "calm", "serene",
        "tranquil", "gentle", "soft", "light", "fluffy", "powdery", "crystalline",
        "sparkly", "shiny", "glowing", "bright", "brilliant", "radiant", "luminous",
        "twinkling", "flickering", "flashing", "dazzling", "gleaming", "glistening",
        "shimmering", "glittering", "sparkling", "decorative", "ornamental", "fancy",
        "elaborate", "detailed", "intricate", "delicate", "fine", "precious",
        "valuable", "special", "unique", "rare", "wonderful", "magical", "enchanted",
        "mystical", "mysterious", "miraculous", "amazing", "incredible", "fantastic",
        "marvelous", "spectacular", "stunning", "beautiful", "pretty", "lovely",
        "charming", "delightful", "pleasant", "nice", "sweet", "warm", "cozy",
        "comfortable", "snug", "toasty", "heated", "blessed", "sacred", "holy",
        "spiritual", "religious", "traditional", "cultural", "familiar", "nostalgic",
        "memorable", "unforgettable", "remarkable", "notable", "significant",
        "important", "meaningful", "thoughtful", "considerate", "kind", "generous",
        "giving", "sharing", "caring", "loving", "friendly", "welcoming", "hospitable",
        "gracious", "thankful", "grateful", "appreciative", "blessed", "fortunate",
        "lucky", "hopeful", "optimistic", "positive", "upbeat", "enthusiastic",
        "excited", "eager", "ready", "prepared", "organized", "neat", "tidy",
        "clean", "fresh", "new", "novel", "modern", "current", "timely", "seasonal",
        "annual", "yearly", "regular", "consistent", "reliable", "steady", "stable",
        "secure", "safe", "protected", "sheltered", "covered", "wrapped", "bundled",
        "layered", "thick", "heavy", "substantial", "solid", "firm", "strong",
        "sturdy", "durable", "lasting", "enduring", "permanent", "eternal", "endless",
        "infinite", "boundless", "limitless", "vast", "expansive", "wide", "broad"
      ]
    
    static let natureadjectives = [
        "abundant", "active", "adaptable", "aerial", "aged", "alpine", "aquatic",
         "arid", "autumnal", "barren", "beautiful", "blooming", "bold", "botanical",
         "brackish", "bright", "briny", "bristly", "bushy", "calm", "coastal",
         "coarse", "cold", "colorful", "cool", "cosmic", "crisp", "crystalline",
         "curved", "damp", "dark", "deep", "dense", "dewy", "distant", "dry",
         "dusty", "earthy", "eastern", "ecological", "elevated", "endangered",
         "enormous", "environmental", "exotic", "expansive", "extinct", "fast",
         "fertile", "fierce", "filthy", "fine", "firm", "flowing", "fluffy",
         "flying", "foggy", "fresh", "frigid", "frosty", "frozen", "gentle",
         "geographical", "geological", "giant", "glacial", "global", "golden",
         "grassy", "green", "growing", "grown", "healthy", "heavy", "high",
         "hollow", "hot", "humid", "icy", "immense", "indigenous", "inland",
         "instinctive", "intense", "internal", "jagged", "jungle", "jurassic",
         "keen", "large", "lasting", "leafy", "light", "living", "local", "lofty",
         "long", "loud", "low", "lush", "mammoth", "marine", "marshy", "massive",
         "mighty", "mild", "moist", "molten", "mossy", "mountain", "muddy",
         "natural", "native", "nearby", "nested", "new", "nocturnal", "northern",
         "numerous", "nutrient", "old", "open", "organic", "oriental", "outdoor",
         "oval", "pacific", "parched", "passive", "pastoral", "patient", "peaceful",
         "perennial", "physical", "planetary", "planted", "plump", "polar", "powerful",
         "precious", "predatory", "preserved", "prickly", "prime", "pristine",
         "protective", "pure", "quick", "quiet", "racing", "rainy", "rapid",
         "rare", "raw", "red", "refreshing", "remote", "restless", "rich", "ripe",
         "rising", "robust", "rocky", "rolling", "rough", "round", "rural", "rustic",
         "salty", "sandy", "savage", "scaly", "scattered", "scented", "seasonal",
         "shallow", "sharp", "sheltered", "shifting", "shiny", "short", "shrubby",
         "silent", "silky", "silver", "simple", "slender", "slimy", "slippery",
         "slow", "small", "smooth", "snowy", "soft", "solar", "solid", "solitary",
         "southern", "spacious", "sparse", "spatial", "speedy", "spicy", "spiky",
         "spinning", "spotted", "spring", "sprouting", "stalking", "steady",
         "steep", "still", "stormy", "straight", "strange", "streaming", "strong",
         "stunted", "summer", "sunny", "swift", "tall", "tangled", "terrestrial",
         "thick", "thin", "thorny", "thrifty", "thundering", "tidal", "timeless",
         "tiny", "torpid", "towering", "toxic", "tranquil", "transparent",
         "tropical", "turbulent", "twilight", "twisting", "underground", "untamed",
         "vast", "verdant", "vernal", "vertical", "warm", "watery", "weak",
         "western", "wet", "wide", "wild", "windy", "winged", "wintry", "woody",
         "young", "zesty"
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
    
    static let swiftyadverbs = [
        "brightly", "softly", "endlessly", "silently", "wildly", "recklessly", "bravely", "gently", "swiftly", "urgently",
        "silently", "boldly", "tragically", "timelessly", "fiercely", "tenderly", "quietly", "endlessly", "constantly", "frantically",
        "desperately", "hopelessly", "recklessly", "shamelessly", "boldly", "dangerously", "bravely", "fearlessly", "quickly", "barely",
        "secretly", "eternally", "softly", "mysteriously", "silently", "vividly", "tenderly", "delicately", "coldly", "wildly",
        "rapidly", "fearlessly", "boldly", "constantly", "frantically", "desperately", "endlessly", "bravely", "urgently", "quietly",
        "patiently", "restlessly", "shamelessly", "softly", "quickly", "quietly", "softly", "tragically", "silently", "fiercely",
        "bravely", "endlessly", "softly", "rapidly", "coldly", "vividly", "secretly", "timelessly", "tragically", "desperately",
        "hopelessly", "wildly", "boldly", "fiercely"
      ]
    
    static let spookyadverbs =  [
        "spookily", "scarily", "creepily", "eerily", "mysteriously", "hauntingly", "ghostly",
        "darkly", "gloomily", "mistily", "murkily", "dimly", "shadowy", "nocturnally",
        "supernaturally", "magically", "enchantingly", "cursedly", "anciently", "dustily",
        "creakily", "squeakily", "rattlingly", "clankingly", "howlingly", "growlingly",
        "hissingly", "whisperingly", "silently", "quietly", "loudly", "startlingly",
        "surprisingly", "suddenly", "swiftly", "slowly", "lumberingly", "sneakily",
        "slyly", "trickily", "cleverly", "mischievously", "playfully", "sillily",
        "funnily", "weirdly", "strangely", "oddly", "peculiarly", "bizarrely",
        "extraordinarily", "unnaturally", "otherworldly", "unearthly", "skeletally",
        "fanged", "furry", "scaly", "slimily", "stickily", "gooily", "oozily",
        "smokily", "wispily", "flickeringly", "glowingly", "shimmeringly", "carefully",
        "cautiously", "bravely", "fearfully", "nervously", "anxiously", "excitedly",
        "thrillingly"
      ]
    
    static let merryadverbs = [
        "snowily", "icily", "frostily", "coldly", "chilly", "crisply", "coolly",
        "winterly", "seasonally", "festively", "merrily", "jollily", "cheerfully",
        "happily", "joyfully", "peacefully", "quietly", "silently", "calmly",
        "serenely", "tranquilly", "gently", "softly", "lightly", "fluffily",
        "sparklingly", "shinily", "glowingly", "brightly", "brilliantly", "radiantly",
        "luminously", "twinklingly", "flickeringly", "flashingly", "dazzlingly",
        "gleamingly", "glisteringly", "shimmeringly", "glitteringly", "decoratively",
        "ornamentally", "fancily", "elaborately", "delicately", "finely", "preciously",
        "specially", "uniquely", "rarely", "wonderfully", "magically", "enchantingly",
        "mystically", "mysteriously", "miraculously", "amazingly", "incredibly",
        "fantastically", "marvelously", "spectacularly", "stunningly", "beautifully",
        "prettily", "lovelily", "charmingly", "delightfully", "pleasantly", "nicely",
        "sweetly", "warmly", "cozily", "comfortably", "snugly", "blessedly", "sacredly",
        "holily", "spiritually", "religiously", "traditionally", "culturally",
        "familiarly", "nostalgically", "memorably", "remarkably", "notably",
        "significantly", "importantly", "meaningfully", "thoughtfully", "considerately",
        "kindly", "generously", "givingly", "caringly", "lovingly", "friendly",
        "welcomingly", "hospitably", "graciously", "thankfully", "gratefully",
        "appreciatively", "fortunately", "luckily", "hopefully", "optimistically",
        "positively", "enthusiastically", "excitedly", "eagerly", "readily",
        "preparedly", "organizedly", "neatly", "tidily", "cleanly", "freshly",
        "newly", "currently", "timely", "seasonally", "annually", "yearly",
        "regularly", "consistently", "reliably", "steadily", "stably", "securely",
        "safely", "protectively", "shelteringly", "coveredly", "wrappedly",
        "bundledly", "layeredly", "thickly", "heavily", "substantially", "solidly",
        "firmly", "strongly", "sturdily", "durably", "lastingly", "enduringly",
        "permanently", "eternally", "endlessly", "infinitely", "boundlessly",
        "limitlessly", "vastly", "expansively", "widely", "broadly", "completely",
        "fully", "totally", "entirely", "absolutely", "perfectly", "precisely"
      ]
    
    static let natureadverbs = [
        "abundantly", "actively", "adaptably", "aerially", "agedly", "alpinely",
         "aquatically", "aridly", "autumnally", "barrenly", "beautifully", "bloomingly",
         "boldly", "botanically", "brackishly", "brightly", "brinily", "bristly",
         "bushily", "calmly", "coastally", "coarsely", "coldly", "colorfully",
         "coolly", "cosmically", "crisply", "crystallinely", "curvedly", "damply",
         "darkly", "deeply", "densely", "dewily", "distantly", "dryly", "dustily",
         "earthily", "easterly", "ecologically", "elevatedly", "enormously",
         "environmentally", "exotically", "expansively", "extensively", "fastly",
         "fertilely", "fiercely", "filthily", "finely", "firmly", "flowingly",
         "fluffily", "flyingly", "foggily", "freshly", "frigidly", "frostily",
         "frozenly", "gently", "geographically", "geologically", "glacially",
         "globally", "goldenly", "grassily", "greenly", "growingly", "healthily",
         "heavily", "highly", "hollowly", "hotly", "humidly", "icily", "immensely",
         "indigenously", "inlandly", "instinctively", "intensely", "internally",
         "jaggedly", "keenly", "largely", "lastingly", "leafily", "lightly",
         "livingly"
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
