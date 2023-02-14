//
//  TempRecepieSaver.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-31.
//

import Foundation

//
//let flygandeJacob = Recepie(
//name: "Flygande Jacob",
//portions: 4,
//ingredients: ["4 kycklingfiléer (á ca 150g)",
//              "1 tsk olja", "1/2 tsk salt",
//              "1 krm peppar", "140 g tärnat bacon",
//              "1 banan", "2 1/2dl matlagningsgrädde",
//              "1 dl chilisås", "4 port ris",
//              "1 dl saltade jordnötter"],
//allergenics: ["kyckling",
//              "bacon" ,
//              "fläsk" ,
//              "gris" ,
//              "fågel",
//              "banan",
//              "grädde",
//              "laktos",
//              "jordnötter",
//              "nötter"],
//instructions: [
//"Sätt ugnen på 225°C",
//"Skär kycklingen i strimlor och bryn den i oljan i en stekpanna i omgångar, krydda med salt och peppar. Lägg i en ugnssäker form. Stek baconet och lägg på kycklingen.",
//"Skala och skiva bananen och lägg dem på kycklingen.",
//"Rör ihop grädde och chilisås, smaka av med salt och peppar. Häll det över kycklingen.",
//"Tillaga mitt i ugnen ca 20 minuter"
//],
//cookingtimeMinutes: 45
//)
//
//

//let laxfileIUgn = Recepie(
//name: "Laxfilé i ugn med citron",
//portions: 8,
//ingredients: ["1.25 kg färsk laxfilé utan skinn", "2 msk olja", "1 1/2 tsk salt", "1 tsk svartpeppar", "1 msk rivet citronskal"],
//allergenics: ["fisk", "lax", "citron"],
//instructions: ["Sätt ugnen på 175°C", "Lägg laxen i en smord ugnsform. Ringla över olja och strö över resten av ingredienserna", "Ställ in i ugnen i ca 25 minuter eller tills laxen har en innertemperatur på 56°C"],
//cookingtimeMinutes: 30
//)
//
//
//
//let nyttRecept = Recepie(
//name: "Ugnsomelett med svampstuvning",
//portions: 4,
//ingredients: ["1 1/2 msk vetemjöl", "5 dl mjölk", "4 ägg", "2 krm salt", "2 krm vitpeppar", "1 L kantareller", "1-1 1/2 krm peppar", "3 dl vispgrädde", "smör för tillagning", "majsstärkelse" ],
//allergenics: ["mjöl", "gluten", "ägg", "laktos", "mjölk", "grädde", "svamp", "vetemjöl", "mjöl"],
//
//instructions: ["Sätt ugnen på 200°C",
//               "Vispa mjölet med lite av mjölken till en slät redning. Blanda med resten av mjölken och koka upp under omrörning. Låt svalna.",
//               "Vispa äggen släta och tillsätt sedan den avsvalnade mjölken, salt och vitpeppar. Häll smeten i en smord ugnssäker form. Grädda mitt i ugnen i ca 25 minuter.",
//              "Stuvning: Ansa svampen och skär den ev i mindre bitar. Smörstek svampen tills den är genomstekt. Salta och svartpeppra.",
//               "Späd med grädde och red med maizena till önskad konsistens.",
//              "Fördela stuvningen över omeletten. Garnera med persilja eller annat grönt."],
//cookingtimeMinutes: 40,
//isAdded: false,
//imageUrl: ""
//)
//
//
//


//let nyttRecept = Recepie(
//name: "Kasslergratäng med ananas och chilisås",
//portions: 4,
//ingredients: ["4 portioner ris",
//              "1 purjolök",
//              "1 orange paprika",
//              "1 röd paprika",
//              "2 msk smör",
//              "1 förp krossade tomater med smak av färsk röd chili, ca 400 g",
//              "3 msk finhackad persilja",
//              "1 burk ananas i skivor, konserverad",
//              "500g kassler",
//              "2 dl vispgrädde",
//              "1/2 dl chilisås",
//              "2 msk sweed chili-sås",
//              "2 dl riven lagrad ost, 31%"],
//
//
//allergenics: ["gris", "fläsk", "ananas", "paprika", "purojök", "lök", "laktos", "grädde", "ost", "mjölkprotein"],
//
//instructions: ["Sätt ugnen på 225 grader. Koka riset enligt förpackningens anvisningar.",
//               "Ansa och strimla löken. Tärna paprikorna. Hetta upp smöret, fräs lök och röd paprika blankt och smidigt utan att det tar färg.",
//               "Tillsätt krossade tomater och finhackad persilja. Blanda samman riset med tomatsåsblandningen och lägg i en smord ugnsfast form.",
//              "Skiva kasslern. Varva kassler och skivad ananas ovanpå risbädden. Strö över orange paprika.",
//               "Vispa grädden lätt och blanda samman med chilisås och sweet chilisås. Bred ut såsen över kasslern och ananasen.",
//              "Strö över riven ost, gratinera mitt i ugnen ca 20 minuter."],
//cookingtimeMinutes: 35,
//isAdded: false,
//imageUrl: "https://firebasestorage.googleapis.com/v0/b/fresh-recepies.appspot.com/o/kasslergratang-med-ananas-och-chilisas_7889.avif?alt=media&token=3f5f05d1-82ab-4e06-8722-dd91699d3f11"
//)
//
//


//let nyttRecept = Recepie(
//                name: "Vegetarisk lasagne",
//                portions: 4-6,
//                ingredients: ["16 st lasagneplattor (ej färska)",
//                              "300 g Quorn färs (tinad)",
//                              "2 morötter (finrivna)",
//                              "1 röd paprika",
//                              "100 g rotselleri (finriven)",
//                              "400 g krossade tomater",
//                              "1 msk grönsaksfond",
//                              "2 msk honung",
//                              "2 msk tomatpuré",
//                              "2 st vitlöksklyftor",
//                              "2 tsk oregano",
//                              "1 1/2 tsk salt",
//                              "Béchamelsås:",
//                              "100 g smör",
//                              "1 dl vetemjöl",
//                              "2 dl matlagningsgrädde",
//                              "7 dl mjölk",
//                              "1 tsk salt",
//                              "1 krm peppar",
//                              "1 krm muskotnöt, nymalen",
//                              "6 soltorkade tomater",
//                              "250 gram mozzarella",
//                              "färsk salvia eller rosmarin",
//                              "1 dl parmesan"],
//
//
//
//                allergenics: ["gluten", "mjöl", "smör", "laktos", "mjölkprotein", "ost"],
//
//                instructions: ["1. Sätt ugnen på 190 grader.",
//                               "2. Quornfärsåsen: Skala och finhacka vitlöken. Blanda alla ingredienser till såsen i en bunke och rör om ordentligt.",
//                               "3. Béchamelsås: Smält smöret i en kastrull. Vispa ner mjölet. Späd med mjölken/grädden, lite i taget. Sjud 7–10 minuter på låg värme under omrörning och smaka av med salt och kryddor.",
//                              "4. Smörj en ugnssäker form med smör. Varva quornfärssås, béchamelsås, och lasagneplattor. Börja och avsluta med béchamelsås, toppa med mozzarella i stora bitar och soltorkade tomater.",
//                               "5. Gratinera i ugnen 40–45 minuter tills lasagnen är mjuk och har fått fin gyllenbrun färg.",
//                              "6. Servera med parmesanosten och en god sallad."],
//
//                cookingtimeMinutes: 60,
//                isAdded: false,
//                imageUrl: "https://firebasestorage.googleapis.com/v0/b/fresh-recepies.appspot.com/o/kasslergratang-med-ananas-och-chilisas_7889.avif?alt=media&token=3f5f05d1-82ab-4e06-8722-dd91699d3f11"
//                )
//
//


//name: "Soppa på gröna ärtor med baguette",
//portions: 4,
//ingredients: ["4 minibaguetter evt. glutenfria",
//              "1 bakpotatis",
//              "2 grönsaksbuljongtärningar",
//              "450 g frysna gröna ärtor",
//              "2 dl créme fraiche",
//              "1 gurka",
//              "1 förp färskost med vitlök"
//             ],
//
//
//
//allergenics: ["laktos, mjölkprotein"],
//
//instructions: ["1. Sätt på ugnen och grädda baguetterna enligt anvisningen på                     förpackningen.",
//               "2. Skala och skär potatisen i tärningar. Koka den mjuk i 7 dl vatten tillsammans med smulade buljongtärningar.",
//               "3.Tillsätt ärtor och crème fraiche och låt koka upp. Mixa soppan slät och smaka av med salt och peppar.",
//               "4. Skiva gurkan, servera soppan med baguetter, färskost och gurka",
//              ],
//
//cookingtimeMinutes: 20,
//imageUrl: "https://firebasestorage.googleapis.com/v0/b/fresh-recepies.appspot.com/o/rsz_1soppa_pa_grona_artor.jpg?alt=media&token=f3670c20-b49c-4fa1-bdfa-4f9305eb033b"
//)


//    .onAppear{
//        let nyttRecept = Recepie(
//                        name: "Tacogratäng med nachos",
//                        portions: 4,
//                        ingredients: ["4 portioner ris",
//                                      "500 g blandfärs",
//                                      "1 förp tacokrydda",
//                                      "1 burk med majs",
//                                      "3 ägg",
//                                      "1dl matlagningsgrädde",
//                                      "1 förp tacosås medium",
//                                      "12 nachochips",
//                                      "1 kruka krispsallad"
//                                     ],
//        
//        
//        
//                        allergenics: ["ägg, laktos, mjölklprotein"],
//        
//                        instructions: ["1. Sätt ugnen på 225 grader.",
//                                       "2. Koka riset enligt anvisningen på förpackningen.",
//                                       "3. Stek färsen i oljan och krydda med tacokrydda.",
//                                       "4. Blanda ner majsen med spadet i färsen.",
//                                       "5. Vispa upp äggen och blanda med grädde och tacosås. Krydda med salt och peppar.",
//                                       "6. Vänd ner färsen i äggblandnigen och häll upp i en ugnsform (ca 20 x 30 cm). Krossa chipsen och strö över. Sätt in mitt i ugnen ca 15 minuter."],
//        
//                        cookingtimeMinutes: 25,
//                        imageUrl: "https://firebasestorage.googleapis.com/v0/b/fresh-recepies.appspot.com/o/rsz_tacogratang_med_nachos.jpg?alt=media&token=a085ab1f-03b8-4e20-a275-eb8dc0c32835"
//                        )
//        
//          name: "Mac'n cheese",
//portions: 4,
//ingredients: ["7 dl makaroner, evt. glutenfria",
//              "2 förp tärnat bacon (á 140g)",
//              "4 dl ostsås, valfri smak",
//              "1 dl mjölk",
//              "1 1/2 dl riven lagrad ost"],
//
//
//
//allergenics: ["Laktos, mjölkprotein, ägg (pastan)"],
//
//instructions: ["1. Sätt ugnen på 225°C",
//               "2. Koka makaronerna enligt anvisningen på förpackningen.",
//               "3  Stek baconet i en torr stekpanna.",
//               "4. Blanda varma makaroner, ostsås, mjölk, bacon och riven ost i en ugnsform, storlek 20x30 cm (för 4 port), och sätt in högt upp ugnen ca 10 minuter.",
//               "5. Skala och riv morötterna.",
//               "6. Servera mac´n cheese med morötter. Toppa gärna med nymald svartpeppar."
//              ],
//
//cookingtimeMinutes: 35,
//imageUrl: "https://firebasestorage.googleapis.com/v0/b/fresh-recepies.appspot.com/o/rsz_1enkel_mac%C2%B4n_cheese.jpg?alt=media&token=26487f2e-b785-40e6-9ea7-b5d93695379f"
//)
//
//
//        
//        db.collection("recepies").document().setData( [
//            "name" : nyttRecept.name,
//            "portions" : nyttRecept.portions,
//            "ingredients" : nyttRecept.ingredients,
//            "allergenics" : nyttRecept.allergenics,
//            "instructions" : nyttRecept.instructions,
//            "cookingtimeMinutes" : nyttRecept.cookingtimeMinutes,
//            "imageUrl" : nyttRecept.imageUrl
//        
//        ]
//        )
//    }
