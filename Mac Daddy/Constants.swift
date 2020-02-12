//
//  Constants.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/19/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import Firebase

class Constants
{
    //Colors
    struct colors {
        static let lavender = UIColor(red: 0.72, green: 0.46, blue: 0.79, alpha: 1.00)
        static let hotPink = UIColor(red: 0.99, green: 0.24, blue: 0.56, alpha: 1.00)
        static let fadedBlue = UIColor(red: 0.54, green: 0.61, blue: 0.99, alpha: 1.00)
        static let neonCarrot = UIColor(red: 0.99, green: 0.60, blue: 0.23, alpha: 1.00)

        static let shadow = ("8A8BE6").toRGB()
        static let royal = ("4440B3").toRGB()

    }
    
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseConversations = databaseRoot.child("conversations")
        static let databaseGigs = databaseRoot.child("gigs")

    }
    
    static let fakeNames = ["Alfredo", "Chicken Tender", "Cheeseburger", "Pizza", "Chicken Salad", "Mozzarella Stick", "Omelette", "Bagel", "Bacon", "Sausage", "Meatball", "Mashed Potato", "French Fry", "String Bean", "Panini", "Potato Chip", "Pineapple", "Quinoa Bowl", "Kale Bowl", "Clam Chowder", "Piece of Steak", "Broccoli", "Blueberry Muffin", "Chocolate Cake", "Noodle Bowl", "Spaghetti", "Steak and Cheese", "Sticky Rice", "Pancake", "Waffle", "Ketchup" , "Tortellini" , "Acai Bowl" , "Salmon" , "Cod", "French Toast", "Bread", "Zucchini", "Eggplant", "Banana", "Rice", "Coconut Water", "Iced Chai Latte", "Chicken Pesto" , "Chicken Wing", "Pork Belly", "Mac and Cheese", "Powerade", "Spinach", "Ice Cream", "Baguette", "Donut", "Corn Dog", "Hot Dog", "Corn", "Beans", "Chicken Parm", "Mustard", "Pickle", "Frips", "Cheese", "Egg", "Potato", "Bread", "Sandwich", "Salad", "Tomato", "Lettuce"]
    
    static let censorEmojis = ["😱", "🤨", "😬", "🤬", "🌝", "🤭", "🙅🏻", "🤦🏻‍♀️", "🙎🏻", "🙊"]
    
    static let badWords = ["chink", "nigger", "nigga", "spic", "faggot"]
        
    static let sketchyWords = ["69", "4r5e", "5h1t", "5hit", "a55", "anal", "anus", "ar5e", "arrse", "arse", "ass", "ass-fucker", "asses", "assfucker", "assfukka", "asshole", "assholes", "asswhole", "a_s_s", "b!tch", "b00bs", "b17ch", "b1tch", "ballbag", "balls", "ballsack", "bastard", "beastial", "beastiality", "bellend", "bestial", "bestiality", "bi+ch", "biatch", "bloody", "blow job", "blowjob", "blowjobs", "boiolas", "bollock", "bollok", "boner", "boob", "boobs", "booobs", "boooobs", "booooobs", "booooooobs", "breasts", "buceta", "bugger", "bum", "bunny fucker", "butt", "butthole", "buttmuch", "buttplug", "c0ck", "c0cksucker", "carpet muncher", "cawk", "chink", "cipa", "cl1t", "clit", "clitoris", "clits", "cnut", "cock", "cock-sucker", "cockface", "cockhead", "cockmunch", "cockmuncher", "cocks", "cocksuck", "cocksucked", "cocksucker", "cocksucking", "cocksucks", "cocksuka", "cocksukka", "cok", "cokmuncher", "coksucka", "cummer", "cumming", "cums", "cumshot", "cunilingus", "cunillingus", "cunnilingus", "cunt", "cuntlick", "cuntlicker", "cuntlicking", "cunts", "cyalis", "cyberfuc", "cyberfuck", "cyberfucked", "cyberfucker", "cyberfuckers", "cyberfucking", "d1ck", "damn", "dick", "dickhead", "dildo", "dildos", "dink", "dinks", "dirsa", "dlck", "dog-fucker", "doggin", "dogging", "donkeyribber", "doosh", "duche", "dyke", "ejaculate", "ejaculated", "ejaculates", "ejaculating", "ejaculatings", "ejaculation", "ejakulate", "f u c k", "f u c k e r", "f4nny", "fag", "fagging", "faggitt", "faggot", "faggs", "fagot", "fagots", "fags", "fanny", "fannyflaps", "fannyfucker", "fanyy", "fatass", "fcuk", "fcuker", "fcuking", "feck", "fecker", "felching", "fellate", "fellatio", "fingerfuck", "fingerfucked", "fingerfucker", "fingerfuckers", "fingerfucking", "fingerfucks", "fistfuck", "fistfucked", "fistfucker", "fistfuckers", "fistfucking", "fistfuckings", "fistfucks", "flange", "fook", "fooker", "fuck", "fucka", "fucked", "fucker", "fuckers", "fuckhead", "fuckheads", "fuckin", "fucking", "fuckings", "fuckingshitmotherfucker", "fuckme", "fucks", "fuckwhit", "fuckwit", "fudge packer", "fudgepacker", "fuk", "fuker", "fukker", "fukkin", "fuks", "fukwhit", "fukwit", "fux", "fux0r", "f_u_c_k", "gangbang", "gangbanged", "gangbangs", "gaylord", "gaysex", "goatse", "God", "god-dam", "god-damned", "goddamn", "goddamned", "hardcoresex", "hell", "heshe", "hoar", "hoare", "hoer", "homo", "hore", "horniest", "horny", "hotsex", "jack-off", "jackoff", "jap", "jerk-off","kawk", "knob", "knobead", "knobed", "knobend", "knobhead", "knobjocky", "knobjokey", "kock", "kondum", "kondums", "kunilingus", "l3i+ch", "l3itch", "labia", "lust", "lusting", "m0f0", "m0fo", "m45terbate", "ma5terb8", "ma5terbate", "masochist", "master-bate", "masterb8", "masterbat*", "masterbat3", "masterbate", "masterbation", "masterbations", "masturbate", "mo-fo", "mof0", "mothafuck", "mothafucka", "mothafuckas", "mothafuckaz", "mothafucked", "mothafucker", "mothafuckers", "mothafuckin", "mothafucking", "mothafuckings", "mothafucks", "mother fucker", "motherfuck", "motherfucked", "motherfucker", "motherfuckers", "motherfuckin", "motherfucking", "motherfuckings", "motherfuckka", "motherfucks", "muff", "mutha", "muthafecker", "muthafuckker", "muther", "mutherfucker", "n1gga", "n1gger", "nazi", "nigg3r", "nigg4h", "nigga", "niggah", "niggas", "niggaz", "nigger", "niggers", "nob", "nob jokey", "nobhead", "nobjocky", "nobjokey", "numbnuts", "nutsack", "orgasim", "orgasims", "orgasm", "orgasms", "p0rn", "pawn", "pecker", "penis", "penisfucker", "phonesex", "phuck", "phuk", "phuked", "phuking", "phukked", "phukking", "phuks", "phuq", "pigfucker", "pimpis", "piss", "pissed", "pisser", "pissers", "pisses", "pissflaps", "pissin", "pissing", "pissoff", "poop", "porn", "porno", "pornography", "pornos", "prick", "pricks", "pron", "pube", "pusse", "pussi", "pussies", "pussy", "pussys", "rectum", "retard", "rimjaw", "rimming", "s hit", "s.o.b.", "sadist", "schlong", "screwing", "scroat", "scrote", "scrotum", "shemale", "smegma", "smut", "snatch", "son-of-a-bitch", "spac", "spunk", "s_h_i_t", "t1tt1e5", "t1tties", "teets", "teez", "testical", "testicle", "tit", "titfuck", "tits", "titt", "tittie5", "tittiefucker", "titties", "tittyfuck", "tittywank", "titwank", "tosser", "turd", "tw4t", "twat", "twathead", "twatty", "willies", "willy", "xrated", "xxx"]

    
}
