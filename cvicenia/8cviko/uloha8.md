# PRBIT - Princípy bezpečnosti informačných technológií
## Report - Domáca úloha č.8
#### Autor: Marek Čederle
#### Cvičenie: Pondelok 17:00


### Použité príkazy a ich vysvetlenie
#### Zadanie č.4

![Zadanie cast1](./images/zadanie_cast1.png)

1. plus 2.
Vytvorenie daných adresárov:
```powershell
mkdir C:\UDAJE
mkdir C:\UDAJE\FINANCNE
mkdir C:\UDAJE\PERSONALNE
```
3.
Vytvorenie súborov:
```powershell
notepad financne.txt
```
- napísal som tam text `financne test test`

```powershell
notepad personalne.txt
```
- napísal som tam text `personalne test test`

4.
Pridanie `user2` ako doménového používateľa:

![Add user2](./images/add_user2.png)

5.
Vytvorenie skupin:

![add groups](./images/create_groups.png)

6.
Pridanie používateľov do ich špecifikovaných skupín (ukážka iba toho druhého, ale prvý je dobre nastavený):

![add users to groups](./images/assign_users_to_groups.png)

7.
Povolenia pre priečinok `UDAJE`:

![permissions UDAJE](./images/udaje_handling.png)

Povolenia pre priečinok `FINANCNE`:

![permissions FINANCNE](./images/finance_folder_handling.png)

Povolenia pre priečinok `PERSONALNE`:

![permissions PERSONALNE](./images/personal_handling.png)

8.
a)
- Ako (prihlásený) admin som to vedel otvoriť a upravit.

b)

![8b](./images/8b.png)


c)

![8c](./images/8c.png)

d)

![8d1](./images/8d1.png)

![8d2](./images/8d2.png)

e)

![8e1](./images/8e1.png)

![8e2](./images/8e2.png)



#### Zadanie č.5

![Zadanie cast3](./images/zadanie_cast2.png)

`certutil` je nástroj vo Windowse, ktorý je primárne používaný na správu certifikátov a kľúčov. Vieme ho tiež použiť na sťahovanie súborov cez internet pomocou prepínača `-urlcache`, čo v preklade umožňuje pripojenie na web. Táto funkcia môže byť zneužitá na sťahovanie škodlivých súborov. Kvôli tomuto je vhoďné znemožniť, aby tento program pristupoval na internet.

Vytvorenie nového objektu skupinovej politiky s pravidlom pre zablokovanie prístupu ku `certutil`:

![block certutil](./images/blocked_certutil.png)

- rovnaké pravidlo som vytvoril aj pre program s cestou `%SystemRoot%\SysWOW64\certutil.exe`, čo je 32-bit verzia programu v adresári, kde sú uložené podporné ovladače pre 32-bit aplikácie
- t.z. zablokovanie pripojenia vo všetkých typoch firewallov

Otestovanie blokovania prístupu k `certutil`:

![test block](./images/certutil_test.png)

Červenou farbou je error output, ktorý bol vypísaný kvôli tomu že windows defender zablkovoval vykonanie daného programu pretože ma považoval za útočníka resp. že nejaký trojan sa to snaží vykonať.
Po tom, čo som vypol windows defender, tak bol program zablokovaný pomocou pravidla vo firewalle.