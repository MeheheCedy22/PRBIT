#import "charged-ieee.typ": ieee
#import "wordometer.typ": word-count, total-words 

#set text(lang: "sk")

// for counting words
#show: word-count

#show: ieee.with(
  title: [Balík nástrojov Microsoft Sysinternals],
  authors: (
    (
      name: "Marek Čederle",
      department: [Fakulta informatiky a informačných technológií],
      organization: [Slovenská Technická Univerzita v Bratislave],
      location: [Bratislava, Slovensko],
      email: "xcederlem@stuba.sk"
    ),
  ),
  abstract: [Táto práca sa zaoberá analýzou a experimentovaním s bezpečnostnými nástrojmi z balíka Microsoft Sysinternals. Tento balík obsahuje široké spektrum nástrojov určených na správu, diagnostiku a monitorovanie operačného systému Microsoft Windows, s dôrazom na bezpečnosť. Práca sa sústredí na vybrané nástroje, konkrétne Process Explorer, Autoruns, TCPView a Process Monitor, pričom každý z nich bol použitý pri testovaný reálnych vzoriek malvéru. V rámci experimentov bola využitá cloudová virtuálna infraštruktúra pre zabezpečenie bezpečného prostredia na spúšťanie malvéru. Cieľom práce bolo demonštrovať funkcie týchto nástrojov pri detekcii a analýze škodlivých aktivít. Výsledky ukázali, že nástroje z balíka Sysinternals poskytujú robustné možnosti pre monitoring a analýzu systémových procesov a sú užitočným doplnkom v oblasti kybernetickej bezpečnosti.],
  index-terms: ("Sysinternals", "Microsoft", "Windows", "malvér", "kybernetická bezpečnosť", "virtuálny stroj", "Process Explorer", "Process Monitor", "Autoruns", "TCPView"),
  // bib - full: true - znamena ze zobrazi zdroje aj bez priameho citovania
  bibliography: bibliography("refs.bib", full: true),
  // supplement pouzivam priamo pri kazdej figure aby som vedel rozdelit tabulky od obrazkov
  // figure-supplement: [],
)

// pridane az po ieee aby email nedavalo underline
// robi aby linky boli clickable
#show link: underline



= Funkčný opis bezpečnostného nástroja
== Úvod do Microsoft Sysinternals
Windows Sysinternals je balík nástrojov, ktorý sa zameriava na správu, diagnostiku, riešenie problémov a monitorovanie operačného systému MS #footnote[Microsoft] Windows. Pôvodne Sysinternals bola webová stránka (predtým známa ako ntinternals) vytvorená v roku 1996 a prevádzkovala ju spoločnosť Winternals Software LP so sídlom v Austine v Texase. Založili ju softvéroví vývojári Bryce Cogswell a Mark Russinovich. 18. júla 2006 spoločnosť Winternals bola zakúpená spoločnosťou Microsoft.

Webová stránka obsahovala niekoľko freewarových nástrojov na správu a monitorovanie počítačov s operačným systémom MS Windows. Spoločnosť predávala aj nástroje na obnovu dát a profesionálne edície svojich freewarových nástrojov @enwiki:1248667707.
Aktuálny zoznam nástrojov @microsoft-sysinternals je zobrazený v @tab:tools.

#figure(
  caption: [Zoznam nástrojov balíka Sysinternals],
  placement: auto,
  supplement: [Tabuľke č.],
  table(
    inset: (x: 4pt, y: 3pt),
    fill: (x, y) => if calc.rem(y, 2) == 1  { rgb("#efefef") },
    columns: 3,

    [AccessChk], [Junction], [PsService],
    [AccessEnum], [LDMDump], [PsShutdown],
    [AdExplorer], [ListDLLs], [PsSuspend],
    [AdInsight], [LiveKd], [PsTools],
    [AdRestore], [LoadOrder], [RAMMap],
    [Autologon], [LogonSessions], [RDCMan],
    [*Autoruns*], [MoveFile], [RegDelNull],
    [BgInfo], [NotMyFault], [RegHide],
    [BlueScreen], [NTFSInfo], [RegJump],
    [CacheSet], [PendMoves], [Registry Usage (RU)],
    [ClockRes], [PipeList], [SDelete],
    [Contig], [PortMon], [ShareEnum],
    [Coreinfo], [ProcDump], [ShellRunas],
    [Ctrl2Cap], [*Process Explorer*], [Sigcheck],
    [DebugView], [*Process Monitor*], [Streams],
    [Desktops], [PsExec], [Strings],
    [Disk2vhd], [PsFile], [Sync],
    [DiskExt], [PsGetSid], [Sysmon],
    [DiskMon], [PsInfo], [*TCPView*],
    [DiskView], [PsKill], [VMMap],
    [Disk Usage (DU)], [PsList], [VolumeID],
    [EFSDump], [PsLoggedOn], [WhoIs],
    [FindLinks], [PsLogList], [WinObj],
    [Handle], [PsPasswd], [ZoomIt],
    [Hex2dec], [PsPing], [---],
  )
) <tab:tools>

== Prehľad vybraných nástrojov
Pre účely tohto projektu sme sa zamerali iba na pár vybraných nástrojov z balíku nástrojov Sysinternals, ktoré sú zamerané na bezpečnosť alebo majú uplatnenie v tejto oblasti. Je to predovšetkým kvôli tomu, že Sysinternals obsahuje nesmierne veľa rôznych nástrojov a bolo by to mimo rozsahu a zamerania tejto práce v predmete PRBIT #footnote[Princípy bezpečnosti v informačných technológiách].

=== Process Explorer
Process explorer je nástroj, ktorý má veľmi podobné funkcionality ako klasický Task Manager #footnote[Správca úloh], ktorý je vstavaný v každom operačnom systéme MS Windows už od verzie Windows NT 4.0. Vie zobraziť využite CPU #footnote[procesora] procesmi na danom systéme. Taktiež využitie operačnej pamäte jednotlivými procesmi, ich PID #footnote[Process ID] a popis. Jeho výhodou je, že je veľmi podrobný oproti jednoduchému Správcovi úloh, hlavne čo sa týka informácií ohľadom správy pamäte. Niektorý ľudia ho nazývajú aj "Task Manager na steroidoch" alebo "Super Task Manager". Zobrazuje procesy v tzv. stromovej štruktúre čo znamená, že je jednoducho vidieť, ktorý proces spustil iný proces (resp. ktorý proces je rodičom ďalších procesov). Po kliknutí na vybraný proces, program dokáže zobraziť vlákna #footnote[threads] daného procesu a dynamické knižnice #footnote[DLL --- Dynamic-Link Library], ktoré používa. Po otvorení vlastností jednotlivého procesu nám vyskočí okno, kde sú všetky podrobnosti, ktoré sa vôbec o procese v rámci operačného systému dajú získať. Nástroj obsahuje aj vyhľadávanie procesov, čo bola funkcionalita, ktorú napríklad Správca úloh získal až vo verzii Windows 11. Ďalšou funkciou Process Explorera je aj možnosť zobraziť informácie o sieťových pripojeniach, ktoré daný proces vytvára. Taktiež dokáže zobraziť bezpečnostné politiky, ktoré boli aplikované na daný proces. V neposlednom rade tento nástroj vie poslať vzorku daného procesu (programu) na webovú stránku #link("https://www.virustotal.com/gui/home/upload")[VirusTotal.com], ktorá slúži na skenovanie potenciálne škodlivého softvéru #footnote[malvér]. Nástroj dokáže overiť signatúry ostatných spustených programov, t.z. či je daný program podpísaný oficiálnym certifikátom spoločnosti, ktorá ho vyvíja. Samozrejmosťou je spomenúť aj veľmi užitočnú funkciu nástroja, ktorú vieme vyvolať kliknutím na ikonu "mieridla" v hlavnom menu, ktorá pri kliknutí na hocijaké okno vie identifikovať proces, ktorému dané okno patrí, čo môže byť užitočné napríklad pri systéme, na ktorom sa nachádza Adware.

=== AutoRuns
Nástroj Autoruns slúži na správu programov, ktoré sa spúšťajú pri štarte systému #footnote[ASEP --- AutoStart Extensibility Points]. Taktiež ako predošlý nástroj, aj nástroj Autoruns vie odoslať vzorky na webovú stránku #link("https://www.virustotal.com/gui/home/upload")[VirusTotal.com], aby overil, či dané programy sú škodlivé a vie overiť aj signatúry programov. Tento nástroj vie zobraziť veľa rôznych kategórií, ktoré označujú ako, kedy a akým spôsobom sa spúšťa daný program pri štarte operačného systému. 
Najzaujímavejšie kategórie sú:
- *Logon:* Programy, spúšťajúce sa po prihlásený používateľa na daný systém.
- *Explorer:* Doplnky a rozšírenia "shellu" pre prieskumník systému Windows. Môžu zahŕňať položky kontextovej ponuky (ponuka vyvolaná po kliknutí pravým tlačidlom) a iné rozšírenia.
- *Scheduled Tasks:* Programy nastavené na spúšťanie pomocou Plánovača úloh #footnote[Task Scheduler] systému Windows. Tieto programy sa spúšťajú na nejakú akciu (trigger) čo môže byť napríklad čas.
- *Services:* Služby systému Windows, ktoré sa spúšťajú na pozadí. Môžu byť nastavené na spúšťanie spolu so systémom, s oneskorením alebo manuálne.
- *Drivers:* Ovládače, ktoré sa načítajú počas spúšťania systému.
V každej kategórii sa nachádzajú kľúče registrov, kde sú dané informácie uložené. Môžu sa však nachádzať aj v súborovom systéme, napríklad ak si vytvoríme vlastný odkaz na aplikáciu, ktorá sa ma zapnúť pri spustený systému #footnote[Startup application].

=== TCPView
Nástroj TCPView slúži na monitorovanie sieťovej aktivity. Nie je to však tak komplexný nástroj ako napríklad Wireshark, ktorý vie zachytávať priamo packety a celú sieťovú komunikácia daného zariadenia, na ktorom je spustený. TCPView slúži skorej na zistenie, či nejaké procesy na pozadí sa nepripájajú na nežiadané IP adresy. Môžeme povedať že je grafickým ekvivalentom pre program "netstat", ktorý je dostupný cez príkazový riadok #footnote[CLI --- Command Line Interface] s nejakými vylepšeniami. Jedno z vylepšení je, že zobrazuje názov procesu a jeho PID, ktorý nadviazal spojenie, pokúša nadviazať spojenie alebo počúva na prichádzajúcu komunikáciu. Medzi štandardné funkcie, ktoré ponúka patrí zobrazenie lokálnej a vzdialenej IP adresy, taktiež lokálny a vzdialený port a protokol použití na komunikáciu (TCP #footnote[TCP --- Transmission Control Protocol] / UDP#footnote[UDP --- User Datagram Protocol]). Nakoniec vie zobraziť čas, kedy bola komunikácia vytvorená a počet prenesených a prijatých packetov.

=== Process Monitor (ProcMon)
Je to špeciálny nástroj na monitorovanie operačného systému v reálnom čase. Zachytáva podrobné udalosti týkajúce sa súborového systému, registrov a aktivity procesov, čo ho robí veľmi cenným nástrojom pri diagnostike a riešení problémov v systéme.
Medzi jeho kľúčové funkcie patrí:
- *Filtrovanie udalostí:* ProcMon poskytuje robustné možnosti filtrovania, ktoré umožňujú používateľom filtrovať udalosti na základe kritérií, ako je názov procesu, cesta alebo typ operácie.
- *Sledovanie systémových volaní:* Zachytáva systémové volania, čím poskytuje náhľad na správanie aplikácií pri ich interakcii so systémovými prostriedkami Windowsu.
- *Zachytávanie krátko existujúcich procesov:* Na rozdiel od Process Explorera, Process Monitor dokáže zachytiť aj procesy, ktoré existujú len krátko, napríklad spustenie príkazu "ipconfig" v príkazovom riadku.
Ako aj každý iný logovací nástroj, ProcMon zobrazuje čas záznamu, názov procesu, jeho PID, vykonanú operáciu (napr. čítanie z registra, zapísanie súboru a pod.), cestu k objektu, nad ktorým danú operáciu vykonal, výsledok operácie a v poslednom rade detailné informácie o operácii.
Taktiež vie podobne ako Process Explorer zobraziť výpis bežiacich procesov v stromovej štruktúre s tým, že má pridaný stĺpec "lifetime" čo zobrazuje, ako dlho proces bol spustený keď bol zapnutý nástroj ProcMon. V sekcii "Process Activity Summary" vie nástroj zobraziť využitie systémových prostriedkov počas toho ako bol nástroj spustený. Obsahuje viacej takýchto pod-nástrojov, ktoré zobrazujú využitie prostriedkov danej kategórie, počas toho ako bol ProcMon spustený. Na záver, nástroj vie spočítať počet výskytov reťazcov z vybranej kategórie.
ProcMon je teda všestranný nástroj, na monitorovanie a analýzu operačného systému v reálnom čase. Ako hovorí Mark Russinovich, tvorca tohto nástroja: "When in doubt, run ProcMon", čo vo voľnom preklade znamená "Ak si nie ste istí, spustite ProcMon".

= Požiadavky na inštaláciu a postup pri inštalácii
== Systémové požiadavky
Systémové požiadavky na nainštalovanie balíka nástrojov Sysinternals sú v podstate rovnaké, ako na samotný operačný systém MS Windows, pretože Sysinternals podporuje všetky aktuálne verzie MS Windows. Môžeme ich vidieť v @tab:sys-req. Podporuje aj viacero CPU architektúr, medzi ktoré patria 64-bit, 32-bit a ARM #footnote[Advanced RISC Machines --- používa sa pri procesoroch mobilných zariadení].

#figure(
  caption: [Minimálne systémové požiadavky OS Windows],
  placement: auto,
  supplement: [Tabuľke č.],
  table(
    inset: (x: 4pt, y: 3pt),
    fill: (x, y) => if calc.rem(y, 2) == 1  { rgb("#efefef") },
    columns: 2,
    align: (left, left),

    // Header row
    [#strong("Komponent")],[#strong("Minimálne požiadavky")],

    // Data rows
    [Procesor],[1 GHz alebo rýchlejší,\ 2+ jadrá,\ CPU schválené Microsoftom],
    [Operačná pamäť (RAM)],[4 GB],
    [Úložisko],[64 GB alebo viac],
    [Firmware podpora],[podpora UEFI #footnote[Unified Extensible Firmware Interface] a Secure Boot #footnote[Zabezpečené spustenie]],
    [TPM #footnote[Trusted Platform Module]],[verzia 2.0 a vyššia],
    [Grafická karta],[Kompatibilná s DirectX 12 alebo vyšším,\ WDDM #footnote[Windows Display Driver Model] 2.0 ovladač],
    [Displej],[Vysoké rozlíšenie (720p), >9\" uhlopriečka, 8 bitov pre jeden farebný kanál],
  )
) <tab:sys-req>

== Stiahnutie balíka nástrojov
Balík nástrojov sa dá stiahnuť z oficiálnej webovej stránky Microsoftu. Je dostupný na adrese #link("https://learn.microsoft.com/en-us/sysinternals/downloads/"). Na tejto adrese vieme stiahnuť `.zip` súbor celého nástroja, alebo si vieme stiahnuť nami žiadané nástroje jednotlivo. Taktiež si vieme nástroj stiahnuť z obchodu aplikácií MS Store, kde budeme dostávať prípadné aktualizácie softvéru.

== Inštalácia, spustenie a konfigurácia
Ak si balík nástrojov stiahneme z oficiálnej stránky, tak ho nemusíme inštalovať, stačí extrahovať `.zip` súbory, kde sa už nachádzajú spustiteľné `.exe` súbory. V prípade, že balík získame z obchodu MS Store, tak sa nám automaticky nainštaluje a nemusíme nič ďalej robiť. V prípade stiahnutia ho vieme spustiť ako klasický program dvojitým kliknutím alebo pomocou príkazového riadku. Ak sme ho získali z obchodu MS Store, tak ho vieme nájsť pomocou vyhľadávania medzi aplikáciami alebo v štart menu. Ďalšia konfigurácia po inštalácii nie je nutná.

= Experimentovanie a overenie funkcionalít bezpečnostných nástrojov
== Príprava na experimentovanie
Na experimentovanie som sa rozhodol použiť virtuálny stroj#footnote[VM --- Virtual Machine] v cloude. Je to z toho dôvodu, že chcem spustiť reálny malvér na danom stroji a ide o bezpečnejšiu alternatívu ku spúšťaniu malvéru na lokálnej VM. Konkrétne som si vybral cloudovú službu Linode (dnes známu ako Linode by Akamai alebo skrátene Akamai#footnote[Spoločnosť Akamai odkúpila spoločnosť Linode v roku 2022]) pretože pomocou promo kódu som získal 100\$ na spojazdnenie virtuálnych strojov a mal som predošlé skúsenosti s touto platformou. Keďže zámerom môjho projektu je balík nástrojov zameraný na operačný systém Windows, potreboval som si vytvoriť virtuálny stroj na Linode. Naneštastie Linode neposkytuje priamo na výber OS Windows, ale ponúka iba GNU+Linux distribúcie ako napríklad Ubuntu, Debian, Arch, CentOS, Fedora, Kali, Rocky a mnohé ďalšie. Našiel som však veľmi dobrý návod na to, ako spojazdniť virtuálny stroj s OS Windows na platforme Linode @LinodeWindows.

Krátky prehľad krokov z uvedeného návodu, ktorý poskytol samotný autor, upravený podľa mojich potrieb:
- Vytvorte dva virtuálne počítače, jeden na Linode a jeden na vašom lokálnom počítači.
- Nainštalujte systém Windows do vášho miestneho virtuálneho počítača a povoľte pripojenie k vzdialenej ploche.
- Naklonujte disk miestneho virtuálneho počítača na VPS#footnote[Virtual Private Server --- Virtuálny súkromný server] Linode.
- Zväčšite veľkosť diskového oddielu systému Windows, aby ste zaplnili miesto na disku VPS.
- Na pripojenie k VPS použite #strike[RDP na miestnom počítači] GLISH#footnote[Graphical Linode Shell] (webovú grafickú konzolu) poskytovanú Linodom.

== Experimenty s vybranými nástrojmi
Keďže nástroje sú väčšinou používané kombinovane a nie samostatne, tak som experimentoval tým spôsobom, že som mal spustené všetky nástroje naraz a následne som spustil vybraný malvér a snažil sa zistiť jeho správanie respektíve, či by ho nástroje vedeli zachytiť.
Vybral som si nasledovné typy malvéru:
- Bitcoin Miner @malware_samples_fabrimagic72_1
- CryptBot @malware_samples_jstrosch_2_4
- Vidar Stealer @malware_samples_jstrosch_2_4
- DCRat - (Dark Crystal RAT#footnote[Remote Access Trojan]) @malware_samples_jstrosch_2_4
Zvolil som is práve tieto typy malvéru, pretože z ich typov vyplýva že budú zachytiteľné danými nástrojmi, napr. Vidar Stealer sa určite bude chcieť pripojiť na nejaké cudzie IP adresy, aby odoslal ukradnuté údaje útočníkovi a podobne.
Keďže zakaždým išlo o starší malvér, ktorý bol už dávno analyzovaný a zachytený, tak som musel vypnúť antivírus Windows Defender, ktorý ho detegoval a vždy ho chcel vymazať.

=== Bitcoin Miner
Stiahol som si daný malvér a extrahoval som ho pomocou aplikácie `7-zip`, pretože takýto malvér určený na testovanie sa dáva do šifrovaných archívov, aby sa predišlo náhodnému spusteniu. Následne som si zapol všetky vyššie spomenuté nástroje z balíka Sysinternals a spustil som malvér. Ako prvé som sa pozrel do Process Explorera a zapol som si odosielanie vzoriek na VirusTotal. VirusTotal do pár sekúnd vrátil stav 68/76, čo znamená že 68 anti-malvér enginov detegovalo že ide o malvér, čo môžeme vidieť na @fig:bitcoin_miner_process_explorer. Ukážku priamo zo stránky VirusTotal môžeme vidieť na @fig:bitcoin_miner_process_explorer_virustotal. Následne som si otvoril Autoruns, kde bohužiaľ nebolo nič vidieť. Mohlo to byť z dôvodu, že malvér detegoval že sa nachádza na virtuálnom stroji a nechcel sa pri tom ako bol spustený zapísať do registrov, aby sa skryl v systéme a nebol príliš viditeľný pre bezpečnostných analytikov. Potom pomocou nástroja TCPView, som občas vedel zachytiť, na ktoré cudzie IP adresy sa daný malvér snaží pripojiť, čo je možné vidieť na @fig:bitcoin_miner_TCPView. Keďže ide o starší malvér tak na daných IP adresách sa už asi nič nenachádzalo a preto sa tieto spojenia po chvíli zrušili. Na záver som si otvoril už dávno spustený ProcMon, ktorý zachytával správanie malvéru od začiatku spustenia. Na @fig:bitcoin_procmon si môžeme všimnúť, ktoré kľúče z registrov používal, aké sieťové spojenia vytváral a vyznačené, sú súbory ku ktorým pristupoval respektíve ich vytváral. Následne som sa išiel pozrieť, čo sú toto za súbory. Boli to obyčajné `.htm` súbory (zdrojové kódy webových stránok), ktoré však boli prázdne. Môžeme ich vidieť na @fig:bitcoin_procmon_random_files. Prázdne mohli byť z dôvodu že sa malvéru nepodarilo nič stiahnuť z webu keďže vyššie spomenuté IP adresy už neboli prístupné alebo tieto súbory, ako ich meno napovedá, slúžili iba na nejaké testovanie.

#figure(
  caption: [Bitcoin Miner --- Process Explorer],
  placement: none,
  image("resources/images/malware1_process_explorer.png"),
  supplement: [Obrázku č.],
) <fig:bitcoin_miner_process_explorer>

#figure(
  caption: [Bitcoin Miner --- VirusTotal],
  placement: none,
  image("resources/images/malware1_process_explorer_virustotal.png"),
  supplement: [Obrázku č.],
) <fig:bitcoin_miner_process_explorer_virustotal>

#figure(
  caption: [Bitcoin Miner --- TCPView],
  placement: none,
  image("resources/images/malware1_TCPView.png"),
  supplement: [Obrázku č.],
) <fig:bitcoin_miner_TCPView>

#figure(
  caption: [Bitcoin Miner --- Process Monitor],
  placement: none,
  image("resources/images/malware1_procmon.png"),
  supplement: [Obrázku č.],
) <fig:bitcoin_procmon>

#figure(
  caption: [Bitcoin Miner --- Náhodné súbory v prieskumníku],
  placement: none,
  image("resources/images/malware1_procmon_random_files.png"),
  supplement: [Obrázku č.],
) <fig:bitcoin_procmon_random_files>

=== CryptBot
Pre tento malvér platil rovnaký postup ako bolo vyššie spomenuté, t.z. stiahol som si daný malvér a extrahoval som ho pomocou aplikácie `7-zip`. Následne som si zapol všetky vybrané nástroje z balíka Sysinternals a spustil som malvér. Tento proces bude platiť aj pre ďalšie typy malvéru. Napriek tomu, že ide o starší malvér, tak je dosť sofistikovaný a nespustí žiadnu škodlivú časť, ak je zároveň spustený nejaký nástroj, ktorý sleduje obsah pamäte iných procesov ako napriklad Process Explorer alebo ProcMon. To spôsobilo, že malvér vyhodil iba chybovú hlášku, ktorá je zobrazená na @fig:cryptbot a odmietol čokoľvek ďalej robiť. Zo zvedavosti som vypol všetky nástroje, ale malvér sa naďalej odmietal sa spustiť. V žiadnom nástroji nebolo nič zaujímavé vidieť, tak som prešiel na ďalšiu vzorku malvéru.

#figure(
  caption: [CryptBot --- Chybová hláška pri spustení],
  placement: none,
  image("resources/images/malware2_cant_execute.png"),
  supplement: [Obrázku č.],
) <fig:cryptbot>

=== Vidar Stealer
Po spustení malvéru som si najskôr zobrazil nástroj TCPView, keďže ide o info stealer, tak som dúfal, že sa bude snažiť pripájať na cudzie IP adresy, čo sa aj stalo a môžeme to vidieť na @fig:vidar_stealer_TCPView. Process Explorer zobrazoval využitie systému daným malvérom a zase po nahratí vzorky na VirusTotal, viacero anti-malvér enginov odhalilo proces ako malvér. Čo sa týka nástroja Autoruns, tak ani tento malvér si nezapísal do registrov žiadny mechanizmus na automatické spúštanie po štarte stroja a podobne. Process Monitor však ukázal zaujímavé informácie. Na @fig:vidar_stealer_ProcMon môžeme vidieť čo sa stalo po ukončení procesu `vidar.exe`. Keďže sa zobrazuje, ktoré kľúče v registroch proces zatvoril, znamená to, že tieto kľúče mal predtým otvorené. Ak sa bližšie pozrieme na názvy daných kľúčov, môžeme si všimnúť, že sa týkali predovšetkým webového priehladača, čo nám v podstate potvrdzuje to, že ide o info stealer.

#figure(
  caption: [Vidar Stealer --- Pripojenia na cudzie IP adresy],
  placement: none,
  image("resources/images/malware3_TCPView.png"),
  supplement: [Obrázku č.],
) <fig:vidar_stealer_TCPView>

#figure(
  caption: [Vidar Stealer --- Ukončenie procesu --- ProcMon],
  placement: none,
  image("resources/images/malware3_ProcMon.png"),
  supplement: [Obrázku č.],
) <fig:vidar_stealer_ProcMon>

=== DCRat
Po spustení malvéru som si zobrazil Process Explorer. Zistil som, že DCRat spustí pár pod-procesov, avšak po chvíli sa všetky ukončia. Samozrejme keďže ide o známy malvér, tak VirusTotal vrátil, že 33 zo 76 anti-malvér enginov identifikovalo, že ide o malvér. Bohužiaľ v nástroji Autoruns zase nebolo nič vidieť. V TCPView bolo zase vidieť, že sa malvér pripája na cudzie IP adresy, čo ako sme si mohli všimnúť je spoločné správanie všetkých malvérov, ktorý používajú sieťovú komunikáciu na vzdialené IP adresy na extrakciu ukradnutých dát, alebo v prípade RAT na vzdialený prístup ku danému stroju. Na to aby som bližšie mohli skúmať správanie malvéru, použili som nástroj ProcMon. Po otvorení stromového zobrazenia procesov v čase, na @fig:DCRat môžeme vidieť, že malvér stihol spustiť viacero sub-procesov. Nástroj taktiež zobrazoval veľa informácií o správaní malvéru, kde napríklad po vyfiltrovaní iba operácií so súborovým systémom môžeme na @fig:DCRat_cipher vidieť, že sa snažil o nejaké kryptografické operácie nad súbormi.

#figure(
  caption: [DCRat --- ProcMon],
  placement: none,
  image("resources/images/malware4_ProcMon.png"),
  supplement: [Obrázku č.],
) <fig:DCRat>

#figure(
  caption: [DCRat --- Operácie so súborovým systémom --- ProcMon],
  placement: none,
  image("resources/images/malware4_ProcMon_cipher.png"),
  supplement: [Obrázku č.],
) <fig:DCRat_cipher>


== Experiment s legitímnym softvérom
Keďže sme pomocou žiadneho malvéru nedemonštrovali funkcionalitu nástroja Autoruns, rozhodol som sa že ju demonštrujem na legitímnom softvéry. Z dôvodu predchádzajúcej skúsenosti som si vybral práve `7-zip` čo je nástroj na komprimáciu súborov. Keďže autor nechce platiť peniaze za certifikát, tak násntroj Autoruns udáva, že sa certifikát napriek tomu, že je program ním podpísaný nedá overiť. Túto skutočnosť si môžeme všimnúť na @fig:autoruns_demo. V tomto prípade, keďže ide o legitímny softvér, tak túto skutočnosť nemusíme nejako veľmi riešiť a taktiež VirusTotal udáva 0 identifikácií od anti-malvér enginov. Avšak v niektorých prípadoch sa malvér môže maskovať za legitímny softvér (čo aj často robí) napríklad aj za program `7-zip` z čoho vyplýva, že by sme to nemali brať na ľahkú váhu.

#figure(
  caption: [Demonštrovanie nástroja Autoruns],
  placement: none,
  image("resources/images/autoruns_demonstration.png"),
  supplement: [Obrázku č.],
) <fig:autoruns_demo>

= Zhodnotenie balíka nástrojov
Balík nástrojov Microsoft Sysinternals ponúka výbornú sadu nástrojov na vyhľadávanie a riešenie problémov spojených s malvérom a bezpečnostnými hrozbami v operačnom systéme Microsoft Windows. Programy Process Explorer, Autoruns, TCPView a Process Monitor umožňujú sledovať procesy, sieťovú aktivitu a zmeny v registroch, čo pomáha lepšie pochopiť správanie podozrivých aplikácií. Tieto nástroje spolu dokážu odhaliť a analyzovať aj zložitejšie hrozby. Experimenty na rôznych vzorkách malvéru ukázali, že sú veľmi užitočné, aj keď niektoré pokročilé druhy malvéru sa vedia vyhnúť detekcii, najmä na virtuálnych strojoch. Celkovo je táto sada nástrojov skvelým pomocníkom pre každého, kto sa zaoberá kybernetickou bezpečnosťou ale je vhodná aj pre "obyčajných" IT technikov alebo ľudí čo majú IT ako hobby.

#set heading(numbering: none)

= Poďakovanie
Chcel by som poďakovať úžasnému týmu a komunite, ktorý stoja za jazykom #link("https://github.com/typst/typst")[`Typst`], v ktorom bola táto práca písaná. Je výbornou a jednoduchou alternatívou jazyka `LaTeX` s prvkami jazyka `MarkDown`. Veľká vďaka patrí aj ľudom, ktorý stoja za jasnou a zrozumiteľnou dokumentáciou tohto jazyka. Na záver by som chcel poďakovať autorovi návodu na sprevádzkovanie Winodws 10 na Linode VPS @LinodeWindows a autorom GitHub repozitárov s vzorkami malvéru @malware_samples_fabrimagic72_1 @malware_samples_jstrosch_2_4.

// TODO: remove, USE: testing for how many words are in this document (idk about accuracy, but seems good)
// #text(stroke: 0.3pt + red)[There is total of #total-words/3000 words in this document to fullfil the requirements of the assignment.]
