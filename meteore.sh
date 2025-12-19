#!/bin/bash

# --- PARAMÈTRES ET ÉTAT ---
LARG=$(tput cols); HAUT=$(tput lines)
SOL=$((HAUT - 3))
SCORE=0; VIE=3; SAISIE=""; MODE="mots"; HARDCORE=false; VITESSE=0.5
declare -A pos_x pos_y texte resultat
id_count=0

# Couleurs
R='\e[31m'; G='\e[32m'; Y='\e[33m'; B='\e[34m'; C='\e[36m'; NC='\e[0m'; BOLD='\e[1m'

# --- LOGIQUE ---
cleanup() { 
    stty echo    # <--- INDISPENSABLE POUR RETROUVER TON TERMINAL
    tput cnorm   # Remettre le curseur
    clear
    exit 
}
trap cleanup SIGINT

spawn_meteor() {
    if [ "$MODE" == "maths" ]; then
        local ops=('+' '-' '*')
        local op=${ops[$((RANDOM % 3))]}

        if [ "$op" == "*" ]; then
	        local a=$((RANDOM % 11)); local b=$((RANDOM % 11))
        else
		local a=$((RANDOM % 101)); local b=$((RANDOM % 101))
        fi
        if [ "$op" == "-" ] && [ $a -lt $b ]; then 
		local t=$a; a=$b; b=$t; 
	fi

        texte[$id_count]="$a$op$b"
        resultat[$id_count]=$((a $op b))
        else
        local mots=("bash" "script" "linux" "shell" "meteor" "root" "system" "kernel" "code" "prompt" "abandonne" "abattage" "abdiquer" "aberrant" "abondant" "abordable" "abordage" "abstrait" "abriter" "absolu" "academie" "acarien" "accaparer" "accorder" "accoster" "acoustique" "acrobatique" "actualiser" "adherant" "adorable" "adossement" "adoucir" "adresser" "adversite" "aerolithe" "affamer" "affecter" "affichera" "affirmer" "affluant" "affoler" "affranchir" "agacement" "agencer" "aggraver" "aiguiser" "aileron" "aisement" "alerteur" "alimenter" "allegorie" "allonger" "alterer" "amarrage" "ambulant" "ammoniac" "amplitude" "balancer" "balayage" "baliverne" "ballade" "balafre" "balisage" "banditisme" "banlieue" "banquette" "barbarie" "barbecue" "barillet" "baronnie" "barricade" "barycentre" "basculement" "bataillon" "batelier" "batiment" "bavardise" "beaucoup" "beffroi" "benefice" "bienfait" "biologie" "biscotte" "bistouri" "blafard" "blanchir" "blason" "blessure" "blindeur" "blondinet" "bloqueur" "blouson" "bohemien" "boite" "bombarder" "bonhomme" "bonifier" "bordelais" "bordereau" "bourdonner" "cabestan" "cabosser" "cabriole" "cachette" "cachotier" "cadrage" "cafouillage" "cajoleur" "calamite" "calcaire" "calculer" "calibrer" "calomnie" "calotte" "calquage" "cambrioler" "campagne" "camphre" "canicule" "canneberge" "cannibale" "cannisse" "capacite" "capteur" "carapace" "caravane" "cardinal" "caricature" "carnivore" "carotide" "carreleur" "cartouche" "castagner" "catapulte" "cucurbitacee" "chafouin" "daigner" "damoiseau" "damnation" "dansant" "danseur" "datation" "debander" "debarquer" "debattre" "deblayer" "debrailler" "decamper" "decennie" "dechiffrer" "dechirer" "declencher" "deconnecter" "decoratif" "decrypter" "dedicacer" "defaillance" "defensif" "definir" "deformant" "degivrage" "degraisser" "deguster" "dehancher" "delecter" "deliberer" "demander" "eblouir" "ebranler" "ecaille" "ecarlate" "ecartelement" "echafaud" "echange" "echarpe" "echeance" "eclaire" "eclatant" "eclipser" "ecologique" "economie" "ecorcheur" "ecossais" "ecouler" "ecouteur" "ecrasant" "ecrivain" "ecrouler" "ectoplasme" "educatif" "effacable" "effectif" "effleurer" "effondrer" "egaliseur" "egalement" "egoiste" "egoutture" "elaborer" "elastique" "electron" "elegant" "elevateur" "elimination" "fabricant" "fabriquer" "fabuliste" "facette" "faction" "factice" "faiblard" "faillite" "faiseur" "faineant" "faisceau" "falaise" "fanfaron" "fantasme" "fantome" "farfadet" "fasciner" "fastidieux" "fatiguant" "faubourg" "faussaire" "favorable" "feignant" "felicite" "feminin" "fermente" "ferraille" "festoyer" "fiction" "figurant" "filament" "filetage" "filigrane" "finaliser" "financer" "firmware" "flagrant" "gachette" "gaiement" "gaillard" "galaxie" "galerie" "galipette" "galocher" "galopade" "galvaniser" "gambader" "gamelle" "gangster" "garagiste" "garderie" "gardien" "garnison" "garrigue" "gaspillage" "geignard" "gelatine" "gendarme" "genocide" "gerbille" "germaine" "giratoire" "gisement" "glaciere" "glandeur" "habilete" "habillage" "habitant" "habituer" "hachure" "haletant" "hallucinogene" "hamburger" "handball" "handicap" "hantise" "harasser" "hardiesse" "harmonie" "harpon" "hasardeux" "hautement" "hebdomadaire" "hebergement" "hectare" "hedoniste" "heliporteur" "hemistiche" "herbivore" "heredite" "hermine" "herpes" "hesitant" "heurtoir" "hibernation" "hibiscus" "hilarant" "hippique" "hirondelle" "idealiser" "identite" "ideogramme" "idolatre" "ignorant" "iguane" "illustrer" "imaginer" "imbriquer" "imitateur" "imitation" "immersion" "immobile" "immortel" "immuniser" "impacter" "impudent" "imperial" "impliquer" "importer" "imposer" "imprudent" "imputable" "incendie" "inception" "inclusif" "incognito" "incolore" "incommode" "incredule" "incursion" "indecent" "indicateur" "indigent" "indigner" "indirect" "indocile" "inegalite" "inertie" "inestimable" "inexact" "infamie" "infanter" "infernal" "infirmier" "jadeite" "jaillir" "jalonner" "jambeaux" "jamboree" "japonais" "jarretiere" "jaugeage" "jaunisse" "jeter" "jeudi" "jeunesse" "joggeur" "jointure" "joliment" "jonchage" "jonchere" "jonction" "jouable" "joueur" "journalier" "journee" "jubilation" "judicieux" "jugement" "junior" "jurassique" "juridique" "justesse" "justifie" "jutelage" "juxtaposition" "jetable" "karateka" "ketchup" "kilometre" "kiosque" "klaxonner" "kleptomane" "kubiste" "kumquat" "kurgane" "kurdesque" "kamikaze" "kilowatt" "kiosque" "kitchenette" "koala" "kobold" "krypton" "labelliser" "laborantin" "labourage" "lacerant" "laconique" "lactation" "lacustre" "laitiere" "lamenter" "luminaire" "lamperie" "lanterne" "lapidaire" "laponie" "larcinant" "largesse" "larmoyant" "larynx" "lasagnes" "lascif" "latent" "lateral" "laureat" "lavabo" "lavement" "lavande" "laxisme" "lecher" "lecteur" "lecture" "legataire" "legende" "legitime" "legumineuse" "lemurien" "lendemain" "lentille" "lepidoptere" "machine" "magazine" "magnetoscope" "maison" "maintien" "majorite" "maladie" "malaxage" "malfacon" "malheureuse" "mallette" "manager" "mandater" "mannequin" "manipuler" "manoeuvre" "manquant" "manteaux" "manucure" "manuelle" "marathon" "marcheur" "marginal" "marinade" "maritime" "marmotte" "marteler" "mascaron" "masculin" "massage" "matelas" "materiel" "matinee" "matraque" "maximum" "mecontent" "medaille" "medecine" "mediter" "mefiance" "megapole" "melanger" "melodie" "membrane" "mensonge" "nacelle" "nageoire" "narratif" "nationale" "naturellement" "navette" "nectar" "negligent" "neigeux" "nerveux" "nettoyer" "neurone" "niveau" "noblesse" "nocturne" "nombreux" "notable" "notifier" "nouvelle" "novateur" "novembre" "nuisible" "numerique" "nutritive" "naviguer" "necessaire" "negocier" "neutral" "nourrisson" "notation" "nourrir" "nuisance" "numeriser" "neanmoins" "nominatif" "notifier" "nourrissant" "necessiter" "navigant" "negociant" "nuancer" "obstacle" "obtenir" "occasion" "occuper" "octobre" "officier" "offrir" "olympique" "ombrelle" "ombrager" "ondoyant" "opiniatre" "opportun" "opprimer" "opticien" "optionnel" "ordonner" "organiser" "original" "oser" "oublier" "ouragan" "ouvrable" "ouvrir" "ouvrage" "oxygene" "officiel" "odorant" "observer" "obseque" "obtention" "obliger" "offensant" "omnivore" "ontologie" "orateur" "ordinaire" "ordonner" "oreiller" "organique" "orgueil" "oriental" "osmose" "ostensif" "outillage" "pactiser" "paddocks" "paginant" "palefrenier" "palissade" "palmier" "pantalon" "papier" "paradoxe" "paraitre" "parcelle" "parcourir" "pardonne" "parental" "parfumer" "parier" "parlance" "parmi" "parole" "partager" "particule" "partir" "partisan" "partout" "parvenir" "passable" "passager" "passion" "patauger" "patience" "patinage" "patronne" "paupiere" "pavillon" "payement" "peignoir" "pelagique" "penalite" "pendant" "penetrer" "pensee" "perdurer" "perforer" "periode" "permanent" "permission" "personne" "persuader" "pertinent" "quadrant" "quadriller" "quadrupede" "qualite" "quantite" "quarantaine" "quartier" "quatrain" "quincaillerie" "quintette" "quintuple" "quintessence" "quiproquo" "quotient" "quadrages" "quadrige" "quartz" "quebecois" "question" "queue" "quietude" "quinze" "quantum" "quatorze" "quartier" "radiance" "radical" "raffiner" "ragotage" "rajeunir" "reamenager" "ramette" "randonnee" "rangement" "rapporter" "rapide" "rasoir" "rassurer" "rattacher" "ravissant" "reaction" "realiste" "rebutant" "recapituler" "rechange" "recherche" "reclus" "recolte" "recouvrer" "recueil" "reculer" "redefinir" "redresser" "referend" "refugier" "regarder" "regiment" "reglementation" "regulier" "rehabiter" "rembourser" "rejouant" "relation" "relatif" "relecture" "remarque" "remedier" "remettre" "remorque" "renaitre" "sacerdoce" "sodomie" "sablier" "sableur" "sachant" "sacrament" "safran" "saladier" "salaires" "salubrite" "sanctuaire" "sanglante" "sanitaire" "santon" "saphir" "sarbacane" "sarcelle" "sardine" "sauvage" "sauvetage" "saxophone" "scaphandre" "scandale" "scarabee" "scenario" "scolaire" "scorpion" "scrutin" "securiser" "sedentaire" "segmentation" "seigneur" "selon" "seminaire" "sensibiliser" "separatiste" "septembre" "septuor" "serpent" "service" "seuil" "severite" "sexualite" "shampoing" "signalement" "tableau" "tabouret" "tactique" "talentueux" "tambours" "tangente" "tapisser" "tartine" "tatouage" "taulard" "telephone" "temerite" "temperer" "templier" "tenancier" "tendance" "tendresse" "teneur" "tennisman" "tentacule" "tergiverser" "terminer" "terrain" "territoire" "terrible" "testament" "textile" "theatre" "theorie" "thermique" "thrombose" "tisserand" "titanium" "toilettes" "tonalite" "tonifier" "topologie" "torpille" "tortue" "touriste" "urbanisme" "urgence" "uniforme" "uniquement" "unionisme" "universel" "universite" "unitaire" "universel" "utiliseres" "utilement" "utopiques" "usager" "usuellement" "usurpant" "usurper" "utilement" "utopies" "ultimatum" "ultraviolet" "uniforme" "usuellement" "urbaniser" "urinoir" "uretre" "urluberlu" "univers" "utilitaire" "vagabond" "vainqueur" "valise" "valoir" "valeureux" "vantard" "vaseline" "vegetal" "volant" "xylophone" "yacht" "zoologie" "zodiaque" "zebre")
        local idx=$((RANDOM % ${#mots[@]}))
        texte[$id_count]=${mots[$idx]}
        resultat[$id_count]=${mots[$idx]}
    fi
    pos_x[$id_count]=$((RANDOM % (LARG - 20) + 2))
    pos_y[$id_count]=3
    ((id_count++))
}

# --- INTERFACES ---
show_menu() {
    tput cnorm; clear
    echo -e "${R}${BOLD}"
    cat << 'EOF'
          ___      ,----.  ,--.--------.    ,----.      _,.---._                   _,.---._     .=-.-.                ,----.  
  .-._ .'=.'\  ,-.--` , \/==/,  -   , -\,-.--` , \  ,-.' , -  `.   .-.,.---.   ,-.' , -  `.  /==/_ /_,..---._   ,-.--` , \ 
 /==/ \|==|  ||==|-  _.-`\==\.-.  - ,-./==|-  _.-` /==/_,  ,  - \ /==/  `   \ /==/_,  ,  - \|==|, /==/,   -  \ |==|-  _.-` 
 |==|,|  / - ||==|   `.-. `--`\==\- \  |==|   `.-.|==|   .=.     |==|-, .=., |==|   .=.     |==|  |==|   _   _\|==|   `.-. 
 |==|  \/  , /==/_ ,    /      \==\_ \/==/_ ,    /|==|_ : ;=:  - |==|   '='  /==|_ : ;=:  - |==|- |==|  .=.   /==/_ ,    / 
 |==|- ,   _ |==|    .-'        |==|- ||==|    .-' |==| , '='     |==|- ,   .'|==| , '='     |==| ,|==|,|   | -|==|    .-'  
 |==| _ /\   |==|_  ,`-._       |==|, ||==|_  ,`-._ \==\ -    ,_ /|==|_  . ,'. \==\ -    ,_ /|==|- |==|  '='   /==|_  ,`-._ 
 /==/  / / , /==/ ,     /       /==/ -//==/ ,     /  '.='. -   .' /==/  /\ ,  ) '.='. -   .' /==/. /==|-,   _`//==/ ,     / 
 `--`./  `--``--`-----``        `--`--``--`-----``     `--`--''   `--`-`--`--'    `--`--''   `--`-``-.`.____.' `--`-----``  
EOF
    echo -e "${NC}"
    echo -e "           ${Y}[1]${NC} Mode MOTS"
    echo -e "           ${Y}[2]${NC} Mode CALCUL MENTAL (0-10)"
    echo -e "           ${Y}[3]${NC} OPTIONS (Hardcore: $( $HARDCORE && echo -e "${R}ON" || echo -e "${G}OFF")${NC})"
    echo -e "           ${Y}[4]${NC} QUITTER"
    echo -ne "\n  Choix : "
    read -n 1 opt
    case $opt in
        1) MODE="mots"; VITESSE=0.9; start_game ;;
        2) MODE="maths"; VITESSE=0.5; start_game ;;
        3) if $HARDCORE; then HARDCORE=false; else HARDCORE=true; fi; show_menu ;;
        4) cleanup ;;
        *) show_menu ;;
    esac
}

start_game() {
    clear; tput civis; stty -echo
    SCORE=0; VIE=3; id_count=0; SAISIE=""
    unset pos_x pos_y texte resultat
    local compteur_spawn=0

    while true; do
        # --- Système de Spawn Unique et Propre ---
        ((compteur_spawn++))
        local delai_spawn=6
        [ "$MODE" == "maths" ] && delai_spawn=5
        $HARDCORE && delai_spawn=$((delai_spawn / 2))

        if [ $compteur_spawn -ge $delai_spawn ]; then
            if [ ${#pos_y[@]} -lt 8 ]; then
                spawn_meteor
            fi
            compteur_spawn=0
        fi

        # Affichage Entête
        tput cup 0 0
        echo -e "${C}SCORE: $SCORE | VIES: $VIE | MODE: $MODE${NC}"
        echo -e "SAISIE : ${Y}${SAISIE}${NC}           " 
        echo -e "${G}$(printf '%*s' "$LARG" '' | tr ' ' '-')${NC}"

        # Mouvement et Dessin
        for i in "${!pos_y[@]}"; do
            # Effacer l ancienne position (assez d'espaces pour les mots longs)
            tput cup ${pos_y[$i]} ${pos_x[$i]}; printf "                         " 
            
            pos_y[$i]=$((pos_y[$i] + 1))

            if [[ ${pos_y[$i]} -ge $SOL ]]; then
                ((VIE--))
                unset "pos_x[$i]" "pos_y[$i]" "texte[$i]" "resultat[$i]"
                [ $VIE -le 0 ] && break 2
                continue
            fi
            tput cup ${pos_y[$i]} ${pos_x[$i]}
            echo -e "${R}${BOLD}[${texte[$i]}]${NC}"
        done
       
        tput cup $SOL 0
        echo -e "${G}$(printf '%*s' "$LARG" '' | tr ' ' '#' )${NC}"

# Lecture clavier (Validation AUTOMATIQUE et SILENCIEUSE)
        if read -t $VITESSE -n 1 touche; then
            if [[ "$touche" == $'\x7f' ]]; then # Backspace
                SAISIE="${SAISIE%?}"
            else
                SAISIE+="$touche"
            fi

            # --- VERIFICATION AUTO ---
            for i in "${!resultat[@]}"; do
                if [[ "$SAISIE" == "${resultat[$i]}" ]]; then
                    # Effacer visuellement
                    tput cup ${pos_y[$i]} ${pos_x[$i]}; printf "                         "
                    # Supprimer de la mémoire
                    unset "pos_x[$i]" "pos_y[$i]" "texte[$i]" "resultat[$i]"
                    ((SCORE++))
                    SAISIE="" # Vider la saisie pour le mot suivant
                    printf '\a' # Petit bip de succès
                    break
                fi
            done
        fi
    done
    clear
    echo -e "${R}${BOLD}GAME OVER !${NC}"
    echo -e "${C}Score final : $SCORE${NC}"
    sleep 3
    show_menu
}

show_menu
