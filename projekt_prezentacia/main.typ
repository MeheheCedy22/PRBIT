// original touying version: 0.4.2, current: 0.4.2, newest: 0.5.3
#import "touying/touying.typ": *
// original unify version: 0.6.0, current: 0.7.0, newest: 0.7.0
#import "unify/unify.typ": num
#import "academic-conf-pre.typ" as theme-aus

#set text(lang: "sk")

#let s = theme-aus.register(aspect-ratio: "4-3") //4-3, 16-9
#let s = (s.methods.info)(
  self: s,
  title: [Balík nástrojov Microsoft Sysinternals],
  short-title: [MS Sysinternals],
  author: [Marek Čederle],
  date: [02.12.2024],
  institution: [Fakulta informatiky a informačných technológií \
    Slovenská Technická Univerzita v Bratislave],
)

#let (init, slides, touying-outline, alert, speaker-note, tblock) = utils.methods(s)
#let (slide, empty-slide, title-slide, outline-slide, new-section-slide, ending-slide) = utils.slides(s)

#show: init
#show: slides.with(title-slide: false)

#title-slide(authors: [Marek Čederle \
  #set text(size: 0.9em)
  xcederlem\@stuba.sk
])

// Table of contents
#outline-slide()

= Úvod
== Microsoft Sysinternals
- Pôvodne `ntinternals` od spoločnosti Winternals Software
- Zakladatelia:
  - Mark Russinovich
  - Bryce Cogswell
- Spoločnosť Winternals Software bola v roku 2006 odkúpená spoločnosťou Microsoft
- Nástroje slúžiace pre pre správu, diagnostiku a monitorovanie systémov s OS Windows.

== Zoznam nástrojov
#figure(
  caption: [Zoznam nástrojov balíka Sysinternals],
  supplement: [Tabuľka č.],
  placement: auto,
  
  table(
    inset: (x: 8pt, y: 4.5pt),
    fill: (x, y) => if calc.rem(y, 2) == 1  { rgb("#efefef") },
    columns: 4,

    [AccessChk], [DiskView], [*Process Explorer*], [RegHide], 
    [AccessEnum], [Disk Usage (DU)], [*Process Monitor*], [RegJump], 
    [AdExplorer], [EFSDump], [PsExec], [Registry Usage (RU)], 
    [AdInsight], [FindLinks], [PsFile], [SDelete], 
    [AdRestore], [Handle], [PsGetSid], [ShareEnum], 
    [Autologon], [Hex2dec], [PsInfo], [ShellRunas], 
    [*Autoruns*], [Junction], [PsKill], [Sigcheck], 
    [BgInfo], [LDMDump], [PsList], [Streams], 
    [BlueScreen], [ListDLLs], [PsLoggedOn], [Strings], 
    [CacheSet], [LiveKd], [PsLogList], [Sync], 
    [ClockRes], [LoadOrder], [PsPasswd], [Sysmon], 
    [Contig], [LogonSessions], [PsPing], [*TCPView*], 
    [Coreinfo], [MoveFile], [PsService], [VMMap], 
    [Ctrl2Cap], [NotMyFault], [PsShutdown], [VolumeID], 
    [DebugView], [NTFSInfo], [PsSuspend], [WhoIs], 
    [Desktops], [PendMoves], [PsTools], [WinObj], 
    [Disk2vhd], [PipeList], [RAMMap], [ZoomIt], 
    [DiskExt], [PortMon], [RDCMan], [---], 
    [DiskMon], [ProcDump], [RegDelNull], [---], 
  )
) <tab:tools>

// neviem ci existuje alternativa ako urobit new page s istym nazvom nech mozem pokracovat
== Microsoft Sysinternals
#tblock(title: [Vybrané nástroje])[
  - Process Explorer
  - Autoruns
  - TCPView
  - Process Monitor (ProcMon)
]

#tblock(title: [Prečo?])[
  - Nástroje zamerané na:
    - bezpečnosť
    - analýzu správania procesov (malvéru)
    - diagnostiku systému
  - Veľké množstvo nástrojov, mimo rozsah projektu
]

= Opis vybraných nástrojov
== Process Explorer
- Podobný ako Task Manager s pridanými/vylepšenými funkciami
- Nazývaný aj ako "Task Manager na steroidoch"
- Stromová štruktúra procesov (parent #sym.arrow.r child)

#tblock(title: [Pridané funkcie])[
  - Dokáže zobraziť:
    - stack procesu/vlákna
    - DLL knižnice využívané procesom
    - sieťové spojenia procesu
  - Odoslanie vzorky na #underline[#link("https://www.virustotal.com/gui/home/upload")[VirusTotal.com]]
  - Overenie signatúr
  - Vyhľadávanie
]

== Autoruns
- Správa programov spúšťaných pri štarte systému
#tblock(title: "Funkcie")[
- Odoslanie vzorky na #underline[#link("https://www.virustotal.com/gui/home/upload")[VirusTotal.com]]
- Overenie signatúr
]

#figure(
  caption: [Záložky nástroja Autoruns],
  supplement: [Tabuľka č.],
  placement: none,
  
  table(
    inset: 10pt,
    fill: (x, y) => if calc.rem(y, 2) == 1  { rgb("#efefef") },
    columns: 2,
    align: (left, left),

    [*Kategória*], [*Popis*], 
    [Logon], [Programy spúšťané po prihlásení používateľa],
    [Explorer], [Rozšírenia a doplnky pre Windows Explorer],
    [Scheduled Tasks], [Úlohy spúšťané Plánovačom úloh],
    [Services], [Systémové služby spúšťané na pozadí],
    [Drivers], [Ovládače načítavané pri štarte systému],
  ),
) <fig:autoruns_categories>


== TCPView
- Monitorovanie sieťovej aktivity a spojení procesov
- Identifikácia nežiadúcich sieťových spojení
- Vylepšená GUI verzia CLI nástroja  `netstat`
- Podporuje TCP/UDP, IPv4/IPv6
- Jednoduchší ako Wireshark – nezachytáva detaily packetov, iba aktívne spojenia

== Process Monitor (ProcMon)
- Real-time monitorovanie operačného systému
- Diagnostika a riešenie problémov

#tblock(title: [Funkcie])[
  - Filtrovanie udalostí
  - Sledovanie krátko existujúcich procesov
  - Zobrazuje veľa podrobných informácií o procesoch
]

#quote(attribution: [Mark Russinovich],block: true)[
  When in doubt, run ProcMon!
]

= Experimentovanie
== Príprava na experimentovanie
- Vytvorenie virtuálneho stroja na cloudovej platforme `Linode`
- Stiahnutie balíka nástrojov z oficiálnej stránky

#tblock(title: "Prečo nie lokálne?")[
  - Vyššia bezpečnosť pri práci s malvérom
  - Neinfikovanie lokálneho stroja
]

== Experimenty
- Snažil som sa vybrať malvér na otestovanie funkcionality nástrojov
- Staršie vzorky malvéru (známe anti-malvér enginom)

#tblock(title: "Stiahnuté vzorky malvéru")[
  - Bitcoin Miner
  - CryptBot
  - Vidar Stealer
  - DCRat --- Dark Crystal RAT (Remote Access Trojan)
]

== Malware sample 1: Bitcoin Miner

#figure(
  supplement: [Obrázok č.],
  image("images/malware1_process_explorer.png", width: 84%),
  caption: [Bitcoin Miner --- Process Explorer],
) <fig:malware1-process_explorer>
  
#figure(
  supplement: [Obrázok č.],
  image("images/malware1_process_explorer_virustotal.png"),
  caption: [Bitcoin Miner --- #underline[#link("https://www.virustotal.com/gui/home/upload")[VirusTotal.com]]],
) <fig:malware1-virustotal>


#tblock(title: "Autoruns")[
  - Nenašla sa žiadna viditeľná aktivita
  - Malvér pravdepodobne skrýval svoje správanie
]

#tblock(title: "TCPView")[
  - Zachytené pokusy o pripojenie na vzdialené IP adresy
  - Spojenia boli neúspešné (neaktívne IP adresy)
]

#figure(
  supplement: [Obrázok č.],
  image("images/malware1_TCPView.png"),
  caption: [Bitcoin Miner --- TCPView],
) <fig:malware1-tcpview>


== Malware sample 1: Bitcoin Miner
#tblock(title: "Process Monitor (ProcMon)")[
  - Zachytené aktivity:
    - Prístup ku kľúčom registrov
    - Vytváranie sieťových spojení
    - Vytváranie (prázdnych `.htm`) súborov
]

#figure(
  supplement: [Obrázok č.],
  image("images/malware1_procmon.png", width: 84%),
  caption: [Bitcoin Miner --- Process Monitor],
) <fig:malware1-procmon>

#figure(
  supplement: [Obrázok č.],
  image("images/malware1_procmon_random_files.png", width: 70%),
  caption: [Bitcoin Miner --- Náhodné súbory],
) <fig:malware1-procmon_random_files>


== Malware sample 2: CryptBot
#tblock(title: "CryptBot")[
  - Sofistikovaný malvér
  - Deteguje nástroje ako Process Explorer alebo ProcMon
  - Po vypnutí nástrojov sa stále odmietal spustiť

]
#figure(
  supplement: [Obrázok č.],
  image("images/malware2_cant_execute.png", width: 85%),
  caption: [CryptBot --- Chybová hláška],
) <fig:malware2>


== Malware sample 3: Vidar Stealer
#tblock(title: "Vidar Stealer")[
  - Process Explorer taktiež ukázal veľa detekcií z anti-malvér enginov
  - Malvér sa snažil odoslať údaje na vzdialené IP adresy
  - Autoruns nám zasa nič nezobrazil
  - Process Monitor odhalil interakciu s kľúčmi registrov súvisiacimi s webovým prehliadačom
]

#figure(
  supplement: [Obrázok č.],
  image("images/malware3_TCPView.png", width: 84%),
  caption: [Vidar Stealer --- TCPView],
) <fig:malware2>

#figure(
  supplement: [Obrázok č.],
  image("images/malware3_ProcMon.png", width: 84%),
  caption: [Vidar Stealer --- Process Monitor],
) <fig:malware3-procmon>

== Malware sample 4: DCRat
#tblock(title: "DCRat")[
- VirusTotal opäť identifikoval proces ako malvér
- Autoruns opäť neukázal žiadne záznamy (týkajúce sa malvéru)
- TCPView potvrdil pripojenie na vzidalené IP adresy
- Process Monitor odhalil viacero sub-procesov, ktoré sa po chvíli ukončili a pokusy o operácie nad súbormi
]
#figure(
  supplement: [Obrázok č.],
  image("images/malware4_ProcMon.png", width: 84%),
  caption: [DCRat --- Process Monitor],
) <fig:malware4-procmon>

#figure(
  supplement: [Obrázok č.],
  image("images/malware4_ProcMon_cipher.png", width: 84%),
  caption: [DCRat --- Operácie so súbormi],
) <fig:malware4-files>

== Experiment s legitímnym softvérom
#tblock(title: [Autoruns --- 7-zip])[
  
  - Legitímny softvér `7-zip` má neoverený certifikát (vývojár neplatí Microsoftu za licenciu)
  - VirusTotal vrátil 0 detekcií
  - Softvér sa zapísal do viacero kľúčov registrov
]

#figure(
  supplement: [Obrázok č.],
  image("images/autoruns_demonstration.png", width: 84%),
  caption: [Autoruns --- Ukážka pre legitímny softvér],
) <fig:malware4-files>

= Záver
== Zhodnotenie
#tblock(title: [Výhody])[
  - Veľmi užitočné nástroje pre detekciu a analýzu správania malvéru
  - Užitočné pre bezpečnostných expertov, IT technikov
]

#tblock(title: [Nevýhody])[
  - Pokročilé malvéry sa vyhýbajú detekcii
  - Obyčajný používatelia sa môžu v nástrojoch stratiť
]

#ending-slide(title: [Ďakujem za pozornosť!])[]

== Literatúra
#bibliography("refs.bib", full: true, style: "ieee", title: [])
