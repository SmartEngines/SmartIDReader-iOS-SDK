# Smart IDReader Documents Reference

  * [Document types](#document-types)
  * [Smart CardReader fields](#smart-cardreader-fields)
  * [Smart 3D OCR MRZ fields](#smart-3d-ocr-mrz-fields)
  * [Smart PassportReader fields](#smart-passportreader-fields)
  * [Smart IDReader fields](#smart-idreader-fields)
    - [Driver's licence of Russian Federation fields](#drivers-licence-of-russian-federation-fields)
    - [Vehicle registration certificate of Russian Federation fields](#vehicle-registration-certificate-of-russian-federation-fields)
    - [Insurance individual account number of Russian Federation fields](#insurance-individual-account-number-of-russian-federation-fields)
    - [Russian international biometric passport fields](#russian-international-biometric-passport-fields)
    - [Kazakhstan ID cards fields](#kazakhstan-id-cards-fields)
    - [Chinese passport fields](#chinese-passport-fields)
    - [USA passport fields](#usa-passport-fields)
    - [Philippine passport fields](#philippine-passport-fields)
    - [UK Driving licence fields](#uk-driving-licence-fields)
    - [UK Passport fields](#uk-passport-fields)
    - [Austrian Driving Licence fields](#austrian-driving-licence-fields)
    - [Austrian ID card fields](#austrian-id-card-fields)
    - [Austrian passport fields](#austrian-passport-fields)
    - [German Driving Licence fields](#german-driving-licence-fields)
    - [German ID card fields](#german-id-card-fields)
    - [German passport fields](#german-passport-fields)
    - [Spanish ID card fields](#spanish-id-card-fields)
    - [Malaysian ID card fields](#malaysian-id-card-fields)
    - [Japanese Driving licence fields](#japanese-driving-licence-fields)
    - [Japanese Health Insurance card fields](#japanese-health-insurance-card-fields)
    - [Japanese passport fields](#japanese-passport-fields)
    - [Indian passport fields](#indian-passport-fields)
    - [Syrian passport fields](#syrian-passport-fields)
    - [Belarusian passport fields](#belarusian-passport-fields)
    - [Belarusian driving licence fields](#belarusian-driving-licence-fields)
    - [Russian visa fields](#russian-visa-fields)

Smart IDReader, being in itself a framework for recognition and automatic entry of various identification documents, also provides interface for separate modules developed by [Smart Engines Ltd.](http://smartengines.biz) and designed for recognition of specific documents, such as bank cards or MRZ documents, which are implemented as a separate recognition engines inside Smart IDReader core. This reference lists the complete set of supported document types across all the modules of Smart IDReader framework, with the list of extracted fields.

## Document types

*Please keep in mind that not all of these document types may be available in your build of the Smart IDReader SDK.*

|  Internal Engine     |      Document type          |  Description     |
|:--------------------:|:-------------    |:-----    |
| Smart CardReader     | `card.embossed`     | Bank cards with embossed fields, front side          |
| Smart CardReader     | `card.indent`       | Bank cards with indent-printed fields, front side    |
| Smart 3D OCR MRZ     | `mrz.mrp`  | [ICAO Doc 9303](http://www.icao.int/publications/pages/publication.aspx?docnum=9303) Machine-readable passports <br> (2 lines, 44 characters each) |
| Smart 3D OCR MRZ     | `mrz.td1`  | [ICAO Doc 9303](http://www.icao.int/publications/pages/publication.aspx?docnum=9303) Machine-readable travel document TD-1 <br> (3 lines, 30 characters each) |
| Smart 3D OCR MRZ     | `mrz.td2`  | [ICAO Doc 9303](http://www.icao.int/publications/pages/publication.aspx?docnum=9303) Machine-readable travel document TD-2 <br> (2 lines, 36 characters each) |
| Smart 3D OCR MRZ     | `mrz.mrva` | [ICAO Doc 9303](http://www.icao.int/publications/pages/publication.aspx?docnum=9303) Machine-readable visa MRV-A <br> (2 lines, 44 characters each) |
| Smart 3D OCR MRZ     | `mrz.mrvb` | [ICAO Doc 9303](http://www.icao.int/publications/pages/publication.aspx?docnum=9303) Machine-readable visa MRV-B <br> (2 lines, 36 characters each)|
| Smart 3D OCR MRZ     | `mrz.mrvrus` | MRZ-like zone on visa of Russian Federation <br> (2 lines, 44 characters each) |
| Smart 3D OCR MRZ     | `mrz.cnis`   | MRZ-like zone on French national identity card <br> (2 lines, 36 characters each) |
| Smart 3D OCR MRZ     | `mrz.m3z`    | MRZ-like zone on citizen passport of Russian Federation <br> (2 lines, 44 characters each) |
| Smart 3D OCR MRZ     | `mrz.chedl`    | MRZ-like zone on Swiss driving licence <br> (3 lines, 9, 30 and 30 characters) |
| Smart PassportReader | `rus.passport.national` | Citizen passport of Russian Federation, <br> pages 2 and 3 |
| Smart IDReader       | `rus.drvlic.type1` | Driver's licence of Russian Federation <br> ('pink and cyan' cards, front side) |
| Smart IDReader       | `rus.drvlic.type2` | Driver's licence of Russian Federation <br> ('yellow' cards, front side) |
| Smart IDReader       | `rus.drvlic.type2` | Driver's licence of Russian Federation <br> (vertical laminated cards, front side) |
| Smart IDReader       | `rus.sts.new` | Vehicle registration certificate of Russian Federation <br> (new 'pink' cards, front and back) |
| Smart IDReader       | `rus.sts.old` | Vehicle registration certificate of Russian Federation <br> (old 'yellow' cards, front and back) |
| Smart IDReader       | `rus.snils.type1` | Insurance individual account number (SNILS) of <br> Russian Federation (laminated cards, front side) |
| Smart IDReader       | `rus.snils.type2` | Insurance individual account number (SNILS) of <br> Russian Federation (card-size, front side) |
| Smart IDReader       | `rus.passport.biometric` | Russian international passport (biometric, main page) |
| Smart IDReader       | `kaz.id.type1` | Kazakhstan ID card (old, with 2-line MRZ, front and back) |
| Smart IDReader       | `kaz.id.type2` | Kazakhstan ID card (new, with 3-line MRZ, front and back) |
| Smart IDReader       | `chn.passport.old` | Chinese passport (old type, main page) |
| Smart IDReader       | `chn.passport.new` | Chinese passport (new type, main page) |
| Smart IDReader       | `usa.passport.old` | USA passport (old type - hexagonal shapes on <br> the backgound, main page) |
| Smart IDReader       | `usa.passport.new` | USA passport (new type, main page) |
| Smart IDReader       | `phl.passport.type1` | Philippine passport (non-biometric, <br> birth place and gender in the same line, main page) |
| Smart IDReader       | `phl.passport.type2` | Philippine passport (non-biometric, <br> birth place and gender in separate lines, main page) |
| Smart IDReader       | `gbr.drvlic.type1` | UK Driving Licence (common type, front) |
| Smart IDReader       | `gbr.drvlic.type2` | UK Driving Licence (flag or tire on the right, front) |
| Smart IDReader       | `gbr.drvlic.provisional` | UK Provisional Driving Licence (front) |
| Smart IDReader       | `gbr.passport.type1`| UK passport (non-biometric, main page) |
| Smart IDReader       | `gbr.passport.type2`| UK passport (biometric, main page) |
| Smart IDReader       | `aut.drvlic.type1` | Austrian Driving Licence (title at the top, front) |
| Smart IDReader       | `aut.drvlic.type2` | Austrian Driving Licence (title in the top-right corner, front) |
| Smart IDReader       | `aut.id.common` | Austrian ID card (front) |
| Smart IDReader       | `aut.passport.type1` | Austrian passport (eagle in the top-left corner, main page) |
| Smart IDReader       | `deu.drvlic.common` | German Driving Licence (front) |
| Smart IDReader       | `deu.id.type1` | German ID card (card-size, front) |
| Smart IDReader       | `deu.id.type2` | German ID card (TD-1 MRZ on the front, front) |
| Smart IDReader       | `deu.passport.type1` | German passport (yellow, eagle in the background, main page) |
| Smart IDReader       | `esp.id.type1` | Spanish ID card (front) |
| Smart IDReader       | `mys.id.type1` | Malaysian ID card (MyKad, front) |
| Smart IDReader       | `jpn.drvlic.type1` | Japanese Driving licence (front) |
| Smart IDReader       | `jpn.insurance.type1` | Japanese Health Insurance card (front) |
| Smart IDReader       | `jpn.passport.type1` | Japanese passport (main page) |
| Smart IDReader       | `ind.passport.type1` | Indian passport (main page) |
| Smart IDReader       | `syr.passport.type1` | Syrian passport (main page) |
| Smart IDReader       | `blr.passport.type1` | Belarusian passport (main page) |
| Smart IDReader       | `blr.drvlic.type1` | Belarusian driving licence (front) |
| Smart IDReader       | `rus.visa.type1` | Russian visa (main page) |


## Smart CardReader fields

The following table lists the fields extracted by Smart CardReader engine (for documents `card.embossed` and `card.indent`).

| Field name | Format | Example | Description |
|:-----------|:-------|:--------|:------------|
|`number`|String of digits <br> separated by spaces|`5123 4567 8901 2345`|Number of the bank card|
|`expiry_date`|`MMSYY` where `MM` stands <br> for month, `YY` stands for year <br> and `S` stands for separator character|`01/22`|Expiry date of the bank card|
|`name`|String with latin characters, <br> spaces and dots|`MR. SAM CARDHOLDER`|Name of the cardholder<br> as printed on the card|

## Smart 3D OCR MRZ fields

The following table lists the fields extracted by Smart 3D OCR MRZ engine (for MRZ documents `mrz.mrp`, `mrz.td1`, `mrz.td2`, `mrz.mrva`, `mrz.mrvb`, `mrz.mrvrus`, `mrz.cnis`, `mrz.m3z`).

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`doc_type_code`            |`mrz.*`|2 symbols (first two characters of MRZ)|`P<`|Code representation of the MRZ document subtype|
|`first_name`               |`mrz.*`|String of latin characters separated by spaces|`SAM JOHN`|First name of the document holder|
|`second_name`              |`mrz.*`|String of latin characters separated by spaces|`TRAVELLER`|Last name of the document holder|
|`gender`                   |`mrz.*`|Single character: `M`, `F` or `<`|`M`|Gender code of the document holder|
|`nationality`              |`mrz.*`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|`UTO`|Nationality of the document holder|
|`country`                  |`mrz.*`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|`UTO`|Issuing authority code|
|`number`                   |`mrz.*`|9-character string|`BF12345<<`|Document number as appears in the MRZ|
|`number_formatted`         |`mrz.*`|String of characters|`BF12345`|Formatted document number string|
|`birth_date`               |`mrz.*`|`YYMMDD`|`990102`|Date of birth as appears in the MRZ|
|`birth_date_formatted`     |`mrz.*`|`DD.MM.YYYY`|`02.01.1999`|Formatted date of birth|
|`expiry_date`              |`mrz.*` except `mrz.m3z` and `mrz.cnis`|`YYMMDD`|`200102`|Expiry date of the MRZ document|
|`expiry_date_formatted`    |`mrz.*` except `mrz.m3z` and `mrz.cnis`|`DD.MM.YYYY`|`02.01.2020`|Formatted expiry date of the MRZ document|
|`opt_data_1`               |`mrz.*`|String of characters|`88393 000`|Formatted optional data on the first MRZ line (at the discretion of issuer)|
|`opt_data_2`               |`mrz.*`|String of characters|`88393 000`|Formatted optional data on the second MRZ line (at the discretion of issuer)|
|`department_code`          |`mrz.m3z`|`DDD-DDD` string|`100-100`|Russian citizen passport authority code|
|`issue_date`               |`mrz.m3z`|`YYMMDD`|`000102`|Issue date of the Russian citizen passport|
|`issue_date_formatted`     |`mrz.m3z`|`DD.MM.YYYY`|`02.01.2000`|Formatted issue date of the Russian citizen passport|

## Smart PassportReader fields

The following table lists the fields extracted by Smart PassportReader (for Russian citizen passport `rus.passport.national`).

| Field name | Format | Example | Description |
|:-----------|:-------|:--------|:------------|
|`authority`|UTF-8 cyrillic string|`УВД Г. МОСКВЫ`|Issuing authority|
|`authority_code`|`DDD-DDD`|`100-100`|Issuing authority code|
|`birthdate`|`DD.MM.YYYY`|`02.01.1980`|Date of birth|
|`birthplace`|UTF-8 cyrillic string|`Г. МОСКВА`|Place of birth|
|`gender`|UTF-8 cyrillic string|`МУЖ.`|Gender|
|`issue_date`|`DD.MM.YYYY`|`02.01.2000`|Passport issue date|
|`mrz_line1`|44-character string|`PNRUSIM8REK<<EVGENIQ<ALEKSANDROVI3<<<<<<<<<<`|First line of mrz.m3z zone|
|`mrz_line2`|44-character string|`1100000000RUS8209120M<<<<<<<4041217292000<46`|Second line of mrz.m3z zone|
|`name`|UTF-8 cyrillic string|`ИВАН`|First name|
|`patronymic`|UTF-8 cyrillic string|`ИВАНОВИЧ`|Patronymic (second name)|
|`surname`|UTF-8 cyrillic string|`ИВАНОВ`|Last name|
|`series`|`DDDD`|`1104`|Passport number series|
|`number`|`DDDDDD`|`123456`|Passport number|

## Smart IDReader fields

This sections lists the fields for different document types supported within Smart IDReader internal engine.

#### Driver's licence of Russian Federation fields

The following table lists the fields extracted by Smart IDReader from documents `rus.drvlic.type1`, `rus.drvlic.type2`, `rus.drvlic.type3`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------| 
|`number`|`rus.drvlic.*`|UTF-8 string `DD XX DDDDDD`, <br> where `D` is a digit <br>and `X` is either <br>digit or cyrillic letter|`11 22 333000`| Formatted document number|
|`birth_date`|`rus.drvlic.*`|`DD.MM.YYYY`|`02.01.1980`|Date of birth of <br>the document holder|
|`issue_date`|`rus.drvlic.*`|`DD.MM.YYYY`|`01.02.1999`|Document issue date|
|`expiration_date`|`rus.drvlic.*`|`DD.MM.YYYY`|`01.02.2009`|Document expiry date|
|`name_rus`|`rus.drvlic.*`|UTF-8 cyrillic string|`ИВАН`|Document holder <br>first name|
|`patronymic_rus`|`rus.drvlic.*`|UTF-8 cyrillic string|`ИВАНОВИЧ`|Document holder <br>patronymic (second name)|
|`surname_rus`|`rus.drvlic.*`|UTF-8 cyrillic string|`ИВАНОВ`|Document holder <br>last name|
|`name_and_patronymic_rus`|`rus.drvlic.type1`|UTF-8 cyrillic string|`ИВАН ИВАНОВИЧ`|Document holder <br>first name and patronymic, <br>as appears on the document|

#### Vehicle registration certificate of Russian Federation fields

The following table lists the fields extracted by Smart IDReader from documents `rus.sts.new` and `rus.sts.old`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`number`|`rus.sts.*`|UTF-8 string `DD XX DDDDDD`, <br> where `D` is a digit <br>and `X` is either <br>digit or cyrillic letter|`11 22 333000`| Formatted document number|
|`plate`|`rus.sts.new` (back side)|UTF-8 string `ADDDAADD[D]` where `A` is a cyrillic letter and `D` is a digit|`А123BC177`|Vehicle licence plate number|
|`vin`|`rus.sts.new` (back side)|17-character string|`1FTLP62W4XH128703`|Vehicle identification number|

#### Insurance individual account number of Russian Federation fields

The following table lists the fields extracted by Smart IDReader from document `rus.snils.type1` and `rus.snils.type2`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`number`|`rus.snils.*`|`DDD-DDD-DDD DD`|`123-456-789 64`|Document number|
|`name`|`rus.snils.*`|UTF-8 cyrillic string|`ИВАН`|Document holder first name|
|`patronymic`|`rus.snils.*`|UTF-8 cyrillic string|`ИВАНОВИЧ`|Document holder patronymic <br>(second name)|
|`surname`|`rus.snils.*`|UTF-8 cyrillic string|`ИВАНОВ`|Document holder last name|

#### Russian international biometric passport fields

The following table lists the fields extracted by Smart IDReader from document `rus.passport.biometric`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`authority`|`rus.passport.biometric`|UTF-8 string|`ФМС 10001`|Issuing authority|
|`birth_date`|`rus.passport.biometric`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`rus.passport.biometric`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`rus.passport.biometric`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`rus.passport.biometric`|UTF-8 cyrillic string|`Г.МОСКВА`|Birth place|
|`expiry_date`|`rus.passport.biometric`|`DD.MM.YYYY`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`rus.passport.biometric`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`rus.passport.biometric`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`rus.passport.biometric`|88 characters string|`P<RUSIVANOV<.....<00`|Full MRZ zone in one line|
|`gender`|`rus.passport.biometric`|UTF-8 cyrillic string|`Ж`|Gender (VIS)|
|`gender_mrz`|`rus.passport.biometric`|Single character|`F`|Gender (MRZ)|
|`issue_date`|`rus.passport.biometric`|`DD.MM.YYYY`|`01.01.2010`|Issue date (VIS)|
|`name_and_patronymic`|`rus.passport.biometric`|UTF-8 cyrillic string|`ИВАН ИВАНОВИЧ`|First name and patronymic|
|`name_mrz`|`rus.passport.biometric`|String of characters|`IVAN`|First name from MRZ|
|`nationality_mrz`|`rus.passport.biometric`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|`RUS`|Nationality of the document holder from MRZ|
|`number`|`rus.passport.biometric`|`DD DDDDDDD`|`10 1000000`|Document number (VIS)|
|`number_mrz`|`rus.passport.biometric`|`DDDDDDDDD`|`101000000`|Document number from MRZ|
|`surname`|`rus.passport.biometric`|UTF-8 cyrillic string|`ИВАНОВ`|Last name (VIS)|
|`surname_mrz`|`rus.passport.biometric`|String of characters|`IVANOV`|Last name from MRZ|

#### Kazakhstan ID cards fields

The following table lists the fields extracted by Smart IDReader from documents `kaz.id.type1` and `kaz.id.type2`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`kaz.id.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`kaz.id.*`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`kaz.id.*`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`expiry_date_mrz`|`kaz.id.*`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`kaz.id.*`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`kaz.id.*`|72 (`kaz.id.type1`) or 90 (`kaz.id.type2`) characters string|`IDKAZ<<...`|Full MRZ zone in one line|
|`gender_mrz`|`kaz.id.*`|Single character|`F`|Gender (MRZ)|
|`inn`|`kaz.id.*`|`DDDDDDDDDDDD`|`012345678901`|Personal INN (VIS)|
|`inn_mrz`|`kaz.id.type2`|`DDDDDDDDDDDD`|`012345678901`|Personal INN as appearas in MRZ|
|`name`|`kaz.id.*`|UTF-8 cyrillic string|`ИВАН`|First name|
|`name_mrz`|`kaz.id.*`|UTF-8 string|`IVAN`|First name from MRZ|
|`number`|`kaz.id.*`|`DDDDDDDDD`|`012345678`|Document number (VIS)|
|`number_mrz`|`kaz.id.*`|`DDDDDDDDD`|`012345678`|Document number from MRZ|
|`patronymic`|`kaz.id.*`|UTF-8 cyrillic string|`ИВАНОВИЧ`|Patronymic|
|`surname`|`kaz.id.*`|UTF-8 cyrillic string|`ИВАНОВ`|Last name|
|`surname_mrz`|`kaz.id.*`|UTF-8 string|`IVANOV`|Last name from MRZ|

#### Chinese passport fields

The following table lists the fields extracted by Smart IDReader from documents `chn.passport.old` and `chn.passport.new`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`chn.passport.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`chn.passport.*`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`chn.passport.*`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`chn.passport.*`|String of characters|`SHANGHAI`|Birth place|
|`country_mrz`|`chn.passport.*`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|`CHN`|Issuing authority code|
|`expiry_date`|`chn.passport.*`|`DD.MM.YYYY`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`chn.passport.*`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`chn.passport.*`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`chn.passport.*`|88 character string|`POCHN....<<00`|Full MRZ zone in one line|
|`gender`|`chn.passport.*`|Single character|`M`|Gender (VIS)|
|`gender_mrz`|`chn.passport.*`|Single character|`M`|Gender (MRZ)|
|`issue_date`|`chn.passport.*`|`DD.MM.YYYY`|`01.01.2000`|Issue date (VIS)|
|`issue_place`|`chn.passport.*`|String of characters|`SHANGHAI`|Issue place|
|`name`|`chn.passport.old`|String of characters|`LI`|First name (VIS)|
|`name_mrz`|`chn.passport.*`|String of characters|`LI`|First name from MRZ|
|`nationality`|`chn.passport.new`|String of characters|`CHINESE`|Nationality (VIS)|
|`nationality_mrz`|`chn.passport.*`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|`CHN`|Nationality from MRZ|
|`number`|`chn.passport.*`|`ADDDDDDDD`|`G01234567`|Document number (VIS)|
|`number_mrz`|`chn.passport.*`|`ADDDDDDDD`|`G01234567`|Document number from MRZ|
|`opt_data_2_mrz`|`chn.passport.*`|String of characters|`01234ABCDE`|Optional information from second MRZ line|
|`surname`|`chn.passport.old`|String of characters|`WANG`|Last name (VIS)|
|`surname_and_name`|`chn.passport.new`|`SURNAME, NAME`|`WANG, LI`|Last and first name (VIS)|
|`surname_mrz`|`chn.passport.*`|String of characters|`WANG`|Last name from MRZ|


#### USA passport fields

The following table lists the fields extracted by Smart IDReader from documents `usa.passport.new` and `usa.passport.old`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`usa.passport.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`usa.passport.*`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`usa.passport.*`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`usa.passport.*`|String of characters|`NEW YORK, U.S.A.`|Birth place|
|`expiry_date`|`usa.passport.*`|`DD.MM.YYYY`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`usa.passport.*`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`usa.passport.*`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`usa.passport.*`|88 character string|`P<USA....<<00`|Full MRZ zone in one line|
|`gender`|`usa.passport.*`|Single character|`M`|Gender (VIS)|
|`gender_mrz`|`usa.passport.*`|Single character|`M`|Gender (MRZ)|
|`issue_date`|`usa.passport.*`|`DD.MM.YYYY`|`01.01.2000`|Issue date (VIS)|
|`name`|`usa.passport.*`|String of characters|`JOHN`|First name (VIS)|
|`name_mrz`|`usa.passport.*`|String of characters|`JOHN`|First name from MRZ|
|`nationality_mrz`|`usa.passport.*`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|`USA`|Nationality from MRZ|
|`number`|`usa.passport.*`|`DDDDDDDDD`|`001234567`|Document number (VIS)|
|`number_mrz`|`usa.passport.*`|`DDDDDDDDD`|`001234567`|Document number from MRZ|
|`opt_data_2_mrz`|`usa.passport.*`|String of characters|`01234ABCDE`|Optional information from second MRZ line|
|`surname`|`usa.passport.*`|String of characters|`SMITH`|Last name (VIS)|
|`surname_mrz`|`usa.passport.*`|String of characters|`SMITH`|Last name from MRZ|


#### Philippine passport fields

The following table lists the fields extracted by Smart IDReader from documents `phl.passport.type1` and `phl.passport.type2`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`phl.passport.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`phl.passport.*`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`phl.passport.*`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`phl.passport.*`|String of characters|`MANILA`|Birth place|
|`expiry_date`|`phl.passport.*`|`DD.MM.YYYY`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`phl.passport.*`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`phl.passport.*`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`phl.passport.*`|88 character string|`P<PHL....<<00`|Full MRZ zone in one line|
|`gender`|`phl.passport.*`|Single character|`M`|Gender (VIS)|
|`gender_mrz`|`phl.passport.*`|Single character|`M`|Gender (MRZ)|
|`issue_date`|`phl.passport.*`|`DD.MM.YYYY`|`01.01.2000`|Issue date (VIS)|
|`middle_name`|`phl.passport.*`|String of characters|`JANE`|Middle name (VIS)|
|`name`|`phl.passport.*`|String of characters|`JOHN`|First name (VIS)|
|`name_mrz`|`phl.passport.*`|String of characters|`JOHN`|First name from MRZ|
|`nationality_mrz`|`phl.passport.*`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|`PHL`|Nationality from MRZ|
|`number`|`phl.passport.*`|`AADDDDDDD`|`AB1234567`|Document number (VIS)|
|`number_mrz`|`phl.passport.*`|`AADDDDDDD`|`AB1234567`|Document number from MRZ|
|`surname`|`phl.passport.*`|String of characters|`SMITH`|Last name (VIS)|
|`surname_mrz`|`phl.passport.*`|String of characters|`SMITH`|Last name from MRZ|


#### UK Driving licence fields


The following table lists the fields extracted by Smart IDReader from documents `gbr.drvlic.type1`, `gbr.drvlic.type2` and `gbr.drvlic.provisional`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`authority`|`gbr.drvlic.*`|String of characters|`DVLA`|Issuing authority|
|`birth_date`|`gbr.drvlic.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date|
|`birth_place`|`gbr.drvlic.*`|String of characters|`UNITED KINGDOM`|Birth place|
|`birth_place_and_birth_date`|`gbr.drvlic.*`|`DD.MM.YYYY <SSS>`|`01.01.1990 UNITED KINGDOM`|Birth date and birth place as appears on the document|
|`expiry_date`|`gbr.drvlic.*`|`DD.MM.YYYY`|`01.01.2020`|Expiry date|
|`issue_date`|`gbr.drvlic.*`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`name`|`gbr.drvlic.*`|String of characters|`JOHN`|First name|
|`number`|`gbr.drvlic.*`|String of characters|`SMITH00000000000 00`|Document number|
|`surname`|`gbr.drvlic.*`|String of characters|`SMITH`|Last name|


#### UK Passport fields

The following table lists the fields extracted by Smart IDReader from documents `gbr.passport.type1` and `gbr.passport.type2`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`authority`|`gbr.passport.*`|String of characters|`IPS`|Issuing authority|
|`birth_date`|`gbr.passport.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`gbr.passport.*`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`gbr.passport.*`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`gbr.passport.*`|String of characters|`LONDON`|Birth place|
|`expiry_date`|`gbr.passport.*`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`gbr.passport.*`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`gbr.passport.*`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`gbr.passport.*`|88 character string|`P<GBR....<<00`|Full MRZ zone in one line|
|`gender`|`gbr.passport.*`|Single character|`M`|Gender (VIS)|
|`issue_date`|`gbr.passport.*`|`DD.MM.YYYY`|`01.01.2000`|Issue date (VIS)|
|`name`|`gbr.passport.*`|String of characters|`JOHN`|First name (VIS)|
|`name_mrz`|`gbr.passport.*`|String of characters|`JOHN`|First name from MRZ|
|`nationality`|`gbr.passport.*`|String of characters|`BRITISH CITIZEN`|Nationality|
|`number`|`gbr.passport.*`|`DDDDDDDDD`|`01234567`|Document number (VIS)|
|`number_mrz`|`gbr.passport.*`|`DDDDDDDDD`|`01234567`|Document number from MRZ|
|`surname`|`gbr.passport.*`|String of characters|`SMITH`|Last name (VIS)|
|`surname_mrz`|`gbr.passport.*`|String of characters|`SMITH`|Last name from MRZ|


#### Austrian Driving Licence fields

The following table lists the fields extracted by Smart IDReader from documents `aut.drvlic.type1` and `aut.drvlic.type2`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`aut.drvlic.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date|
|`birth_place`|`aut.drvlic.*`|String of characters|`WIEN`|Birth place|
|`birth_place_and_birth_date`|`aut.drvlic.*`|`DD.MM.YYYY <SSS>`|`01.01.1990 WIEN`|Birth date and birth place as appears on the document|
|`expiry_date`|`aut.drvlic.type1`|`DD.MM.YYYY`|`01.01.2020`|Expiry date|
|`issue_date`|`aut.drvlic.*`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`issue_place`|`aut.drvlic.*`|String of characters|`WIEN`|Place of issue|
|`name`|`aut.drvlic.*`|String of characters|`JOHN`|First name|
|`number`|`aut.drvlic.*`|`DDDDDDDD`|`01234567`|Document number|
|`surname`|`aut.drvlic.*`|String of characters|`SMITH`|Last name|


#### Austrian ID card fields

The following table lists the fields extracted by Smart IDReader from the document `aut.id.common`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`aut.id.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date|
|`gender`|`aut.id.*`|Single character|`M`|Gender|
|`name`|`aut.id.*`|String of characters|`JOHN`|First name|
|`number`|`aut.id.*`|`DDDDDDDD`|`01234567`|Document number|
|`surname`|`aut.id.*`|String of characters|`SMITH`|Last name|


#### Austrian passport fields

The following table lists the fields extracted by Smart IDReader from the document `aut.passport.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`aut.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`aut.passport.type1`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`aut.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`aut.passport.type1`|String of characters|`WIEN`|Birth place|
|`dvr_number`|`aut.passport.type1`|`AAA DDDDDDD`|`DVR 0123456`|DVR number (vertical on the right)|
|`expiry_date`|`aut.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`aut.passport.type1`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`aut.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`aut.passport.type1`|88 characters string|`P<AUT...<0`|Full MRZ zone in one line|
|`height`|`aut.passport.type1`|`DD CM` or `DDD CM`|`180 CM`|Height|
|`issue_date`|`aut.passport.type1`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`name`|`aut.passport.type1`|String of characters|`JOHN`|First name|
|`name_mrz`|`aut.passport.type1`|String of characters|`JOHN`|First name from MRZ|
|`number`|`aut.passport.type1`|`A DDDDDDD`|`P 0123456`|Document number (VIS)|
|`number_mrz`|`aut.passport.type1`|`ADDDDDDD`|`P0123456`|Document number from MRZ|
|`surname`|`aut.passport.type1`|String of characters|`SMITH`|Last name (VIS)|
|`surname_mrz`|`aut.passport.type1`|String of characters|`SMITH`|Last name from MRZ|


#### German Driving Licence fields

The following table lists the fields extracted by Smart IDReader from the document `deu.drvlic.common`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`deu.drvlic.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date|
|`birth_place`|`deu.drvlic.*`|String of characters|`BERLIN`|Birth place|
|`issue_date`|`deu.drvlic.*`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`issue_place`|`deu.drvlic.*`|String of characters|`BERLIN`|Place of issue|
|`issue_place_second`|`deu.drvlic.*`|String of characters|`MAIN`|Place of issue - second line|
|`name`|`deu.drvlic.*`|String of characters|`JOHN`|First name|
|`number`|`deu.drvlic.*`|`NNNNNNNNNNN` (alphanumeric)|`J0000T0000K`|Document number|
|`surname`|`deu.drvlic.*`|String of characters|`SMITH`|Last name|
|`surname_second`|`deu.drvlic.*`|String of characters|`SMITH`|Last name - second line|


#### German ID card fields

The following table lists the fields extracted by Smart IDReader from documents `deu.id.type1` and `deu.id.type2`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`deu.id.*`|`DD.MM.YYYY`|`01.01.1990`|Birth date|
|`birth_date_and_nationality`|`deu.id.type1`|`DD.MM.YYYY <SSS>`|`01.01.1990 DEUTSCH`|Birth date and nationality as appears on the document|
|`birth_date_mrz`|`deu.id.type2`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`deu.id.type2`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`deu.id.*`|String of characters|`BERLIN`|Birth place|
|`birth_place_and_birth_date`|`deu.id.type2`|`DD.MM.YYYY <SSS>`|`01.01.1990 BERLIN`|Birth date and birth place as appears on the document|
|`expiry_date`|`deu.id.*`|`DD.MM.YYYY`|`01.01.2020`|Expiry date|
|`expiry_date_mrz`|`deu.id.type2`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`deu.id.type2`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`deu.id.type2`|72 characters string|`IDD<<...<0`|Full MRZ zone in one line|
|`name`|`deu.id.*`|String of characters|`JOHN`|First name|
|`name_mrz`|`deu.id.type2`|String of characters|`JOHN`|First name from MRZ|
|`nationality`|`deu.id.*`|String of characters|`DEUTSCH`|Nationality|
|`number`|`deu.id.*`|`NNNNNNNNN` (alphanumeric) for `deu.id.type1`, 9 or 10 digits for `deu.id.type2`|`012345678`|Document number|
|`number_mrz`|`deu.id.type2`|`DDDDDDDDD`|`012345678`|Document number from MRZ|
|`rfid_number`|`deu.id.type1`|`DDDDDD`|`012345`|RFID access code|
|`surname`|`deu.id.*`|String of characters|`SMITH`|Last name|
|`surname_mrz`|`deu.id.type2`|String of characters|`SMITH`|Last name from MRZ|
|`surname_second`|`deu.id.*`|String of characters|`SMITH`|Last name - second line|


#### German passport fields

The following table lists the fields extracted by Smart IDReader from document `deu.passport.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`deu.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`deu.passport.type1`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`deu.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`deu.passport.type1`|String of characters|`BERLIN`|Birth place|
|`expiry_date`|`deu.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`deu.passport.type1`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`deu.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`deu.passport.type1`|88 characters string|`P<D<<...<0`|Full MRZ zone in one line|
|`gender`|`deu.passport.type1`|Single character|`M`|Gender|
|`issue_date`|`deu.passport.type1`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`name`|`deu.passport.type1`|String of characters|`JOHN`|First name|
|`name_mrz`|`deu.passport.type1`|String of characters|`JOHN`|First name from MRZ|
|`nationality`|`deu.passport.type1`|String of characters|`DEUTSCH`|Nationality|
|`number`|`deu.passport.type1`|`NNNNNNNNN` (alphanumeric)|`CH2345678`|Document number (VIS)|
|`number_mrz`|`deu.passport.type1`|`NNNNNNNNN` (alphanumeric)|`CH2345678`|Document number from MRZ|
|`surname`|`deu.passport.type1`|String of characters|`SMITH`|Last name (VIS)|
|`surname_mrz`|`deu.passport.type1`|String of characters|`SMITH`|Last name from MRZ|
|`surname_second`|`deu.passport.type1`|String of characters|`SMITH`|Last name - second line|


#### Spanish ID card fields

The following table lists the fields extracted by Smart IDReader from document `esp.id.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`esp.id.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date|
|`expiry_date`|`esp.id.type1`|`DD.MM.YYYY`|`01.01.2020`|Expiry date|
|`gender`|`esp.id.type1`|Single character|`M`|Gender|
|`idesp`|`esp.id.type1`|`AAADDDDDD`|`AAA012345`|Identity card serial number|
|`name`|`esp.id.type1`|String of characters|`JOHN`|First name|
|`nationality`|`esp.id.type1`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|`ESP`|Nationality|
|`number`|`esp.id.type1`|`DDDDDDDDA`|`01234567A`|Document number|
|`surname`|`esp.id.type1`|String of characters|`SMITH`|Primary last name|
|`surname_second`|`esp.id.type1`|String of characters|`SMITH`|Secondary last name|


#### Malaysian ID card fields

The following table lists the fields extracted by Smart IDReader from document `mys.id.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`address_line1`|`mys.id.type1`|String of characters|`NO 1`|1st line of address|
|`address_line2`|`mys.id.type1`|String of characters|`STREETNAME`|2nd line of address|
|`address_line3`|`mys.id.type1`|String of characters|`CITY NAME`|3rd line of address|
|`address_line4`|`mys.id.type1`|String of characters|`REGION NAME`|4th line of address|
|`address_line5`|`mys.id.type1`|String of characters|`EXTRA LINE`|5th line of address (if exists)|
|`birth_date`|`mys.id.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date (extracted<br> from number)|
|`birth_place`|`mys.id.type1`|String of characters|`REGION NAME`|Birth place (extracted<br> from number)|
|`gender`|`mys.id.type1`|`PEREMPUAN` or `LELAKI`|`LELAKI`|Gender|
|`name`|`mys.id.type1`|String of characters|`JOHN SMITH`|Full name|
|`nationality`|`mys.id.type1`|String of characters|`WARGANEGARA`|Nationality|
|`number`|`mys.id.type1`|`DDDDDD-DD-DDDD`|`900101-01-0123`|Document number|


#### Japanese Driving licence fields

The following table lists the fields extracted by Smart IDReader from document `jpn.drvlic.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`number`|`jpn.drvlic.type1`|`DDDDDDDDDDDD`|`012345678901`|Document number|


#### Japanese Health Insurance card fields

The following table lists the fields extracted by Smart IDReader from document `jpn.insurance.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`insurance_type`|`jpn.insurance.type1`|`DDDDD`|`01234`|Insurance type (top-right corner)|
|`organization`|`jpn.insurance.type1`|`DDDDDDDD`|`01234567`|Organization code|
|`serial_number`|`jpn.insurance.type1`|String of digits|`012`|Serial number|
|`insurer_number`|`jpn.insurance.type1`|`DDDDDDDD`|`01234567`|Insurer number|


#### Japanese passport fields

The following table lists the fields extracted by Smart IDReader from document `jpn.passport.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`jpn.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`jpn.passport.type1`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`jpn.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`jpn.passport.type1`|String of characters|`TOKYO`|Birth place (Registered domicile)|
|`expiry_date`|`jpn.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`jpn.passport.type1`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`jpn.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`jpn.passport.type1`|88 characters string|`P<JPN...<00`|Full MRZ zone in one line|
|`gender`|`jpn.passport.type1`|Single character|`M`|Gender|
|`gender_mrz`|`jpn.passport.type1`|Single character|`M`|Gender from MRZ|
|`issue_date`|`jpn.passport.type1`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`name`|`jpn.passport.type1`|String of characters|`JOHN`|First name|
|`name_mrz`|`jpn.passport.type1`|String of characters|`JOHN`|First name from MRZ|
|`nationality`|`jpn.passport.type1`|String of characters|`JAPAN`|Nationality|
|`number`|`jpn.passport.type1`|`AADDDDDDD`|`AB2345678`|Document number (VIS)|
|`number_mrz`|`jpn.passport.type1`|`AADDDDDDD`|`AB2345678`|Document number from MRZ|
|`surname`|`jpn.passport.type1`|String of characters|`SMITH`|Last name (VIS)|
|`surname_mrz`|`jpn.passport.type1`|String of characters|`SMITH`|Last name from MRZ|


#### Indian passport fields

The following table lists the fields extracted by Smart IDReader from document `ind.passport.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`ind.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`ind.passport.type1`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`ind.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`birth_place`|`ind.passport.type1`|String of characters|`MUMBAI`|Birth place|
|`expiry_date`|`ind.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Expiry date (VIS)|
|`expiry_date_mrz`|`ind.passport.type1`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`ind.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`ind.passport.type1`|88 characters string|`P<IND...<0`|Full MRZ zone in one line|
|`gender`|`ind.passport.type1`|Single character|`M`|Gender|
|`gender_mrz`|`ind.passport.type1`|Single character|`M`|Gender from MRZ|
|`issue_date`|`ind.passport.type1`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`issue_place`|`ind.passport.type1`|String of characters|`MUMBAI`|Issue place|
|`name`|`ind.passport.type1`|String of characters|`JOHN`|First name|
|`name_mrz`|`ind.passport.type1`|String of characters|`JOHN`|First name from MRZ|
|`nationality`|`ind.passport.type1`|String of characters|`INDIAN`|Nationality|
|`number`|`ind.passport.type1`|`ADDDDDDD`|`A0123456`|Document number (VIS)|
|`number_mrz`|`ind.passport.type1`|`ADDDDDDD`|`A0123456`|Document number from MRZ|
|`surname`|`ind.passport.type1`|String of characters|`SMITH`|Last name (VIS)|
|`surname_mrz`|`ind.passport.type1`|String of characters|`SMITH`|Last name from MRZ|

#### Syrian passport fields

The following table lists the fields extracted by Smart IDReader from document `syr.passport.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`birth_date`|`syr.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date (VIS)|
|`birth_date_mrz`|`syr.passport.type1`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`syr.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`expiry_date_mrz`|`syr.passport.type1`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`syr.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`full_mrz`|`syr.passport.type1`|88 characters string|`PNSYR...<00`|Full MRZ zone in one line|
|`gender_mrz`|`syr.passport.type1`|Single character|`M`|Gender from MRZ|
|`name_mrz`|`syr.passport.type1`|String of characters|`JOHN`|First name from MRZ|
|`number_mrz`|`syr.passport.type1`|`DDDDDDDDD`|`012345678`|Document number from MRZ|
|`surname_mrz`|`syr.passport.type1`|String of characters|`SMITH`|Last name from MRZ|

#### Belarusian passport fields

The following table lists the fields extracted by Smart IDReader from document `blr.passport.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`number`|`blr.passport.type1`|`AADDDDDDD`|`AB0123456`|Document number|
|`number_mrz`|`blr.passport.type1`|`AADDDDDDD`|`AB0123456`|Document number from MRZ|
|`birth_date`|`blr.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date|
|`birth_date_mrz`|`blr.passport.type1`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`blr.passport.type1`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`expiry_date`|`blr.passport.type1`|`DD.MM.YY`|`20.01.01`|Expiry date|
|`expiry_date_mrz`|`blr.passport.type1`|`YYMMDD`|`200101`|Expiry date as appears in MRZ|
|`expiry_date_mrz_formatted`|`blr.passport.type1`|`DD.MM.YYYY`|`01.01.2020`|Formatted expiry date from MRZ|
|`birth_place`|`blr.passport.type1`|`String of characters`|`REPUBLIC OF BELARUS`|Birth place|
|`full_mrz`|`blr.passport.type1`|`88 characters string`|`P<BLR...`|Full MRZ zone in one line|
|`issue_date`|`blr.passport.type1`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`gender`|`blr.passport.type1`|`Single character`|`M`|Gender|
|`gender_mrz`|`blr.passport.type1`|`Single character`|`M`|Gender from MRZ|
|`name`|`blr.passport.type1`|`String of characters`|`DMITRY`|First name|
|`name_mrz`|`blr.passport.type1`|`String of characters`|`DMITRY`|First name from MRZ|
|`surname`|`blr.passport.type1`|`String of characters`|`IVANOV`|Last name|
|`surname_mrz`|`blr.passport.type1`|`String of characters`|`IVANOV`|Last name from MRZ|
|`id`|`blr.passport.type1`|`DDDDDDDADDDAAD`|`0123456A789BC0`|Identification number|
|`nationality_mrz`|`blr.passport.type1`|`String of characters`|`BLR`|Nationality from MRZ|

#### Belarusian driving licence fields

The following table lists the fields extracted by Smart IDReader from document `blr.drvlic.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`number`|`blr.drvlic.type1`|`DAADDDDDD`|`0AB012345`|Document number|
|`birth_date`|`blr.drvlic.type1`|`DD.MM.YYYY`|`01.01.1990`|Birth date|
|`birth_place`|`blr.drvlic.type1`|UTF-8 cyrillic string|`МОГИЛЕВСКАЯ ОБЛ`|Birth place|
|`expiry_date`|`blr.drvlic.type1`|`DD.MM.YYYY`|`20.01.2020`|Expiry date|
|`issue_date`|`blr.drvlic.type1`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`name`|`blr.drvlic.type1`|UTF-8 cyrillic string|`ИВАН`|First name|
|`patronymic`|`blr.drvlic.type1`|UTF-8 cyrillic string|`ИВАНОВИЧ`|Patronymic (second name)|
|`surname`|`blr.drvlic.type1`|`UTF-8 cyrillic string`|`ИВАНОВ`|Last name|

#### Russian visa fields

The following table lists the fields extracted by Smart IDReader from document `rus.visa.type1`.

| Field name | Document types | Format | Example | Description |
|:-----------|:---------------|:-------|:--------|:------------|
|`duration`|`rus.visa.type1`|`DDD`|`100`|Duration of days|
|`issue_date`|`rus.visa.type1`|`DD.MM.YYYY`|`01.01.2000`|Issue date|
|`entry_date`|`rus.visa.type1`|`DD.MM.YYYY`|`01.01.2000`|Entry from date|
|`until_date`|`rus.visa.type1`|`DD.MM.YYYY`|`01.01.2000`|Stay until date|
|`nationality`|`rus.visa.type1`|UTF-8 cyrillic string|`ИНДОНЕЗИЯ`|Nationality|
|`visa_id`|`rus.visa.type1`|UTF-8 cyrillic string|`АБВ01234`|VISA ID|
|`surname_given_names`|`rus.visa.type1`|UTF-8 cyrillic string|`ИВАНОВ ИВАН ИВАНОВИЧ`|Surname, given names|
|`surname_given_names_eng`|`rus.visa.type1`|string|`IVANOV IVAN IVANOVICH`|Surname, given names (eng)|
|`passport_number`|`rus.visa.type1`|Alphanumeric string|`012ABC3456`|Passport number|
|`birth_date`|`rus.visa.type1`|`DD.MM.YYYY`|`01.01.2000`|Birth date|
|`gender`|`rus.visa.type1`|UTF-8 cyrillic string|`МУЖ`|Gender|
|`invitation_number`|`rus.visa.type1`|`DADDDDDDD`|`2A1234567`|Invitation number|
|`birth_date_mrz`|`rus.visa.type1`|`YYMMDD`|`900101`|Date of birth as appears in MRZ|
|`birth_date_mrz_formatted`|`rus.visa.type1`|`DD.MM.YYYY`|`01.01.1990`|Formatted date of birth from MRZ|
|`nationality_mrz`|`rus.visa.type1`|[ISO 3166-1](http://www.iso.org/iso/home/standards/country_codes.htm) three-letter|ITA|Nationality from MRZ|
|`doc_num_mrz`|`rus.visa.type1`|Alphanumeric string|12345678AA|Passport number from MRZ|
|`doc_type_code_mrz`|`rus.visa.type1`|one-letter|V|Document type from MRZ|
|`full_mrz`|`rus.visa.type1`|88 characters string|`VXXX...`|Full MRZ zone in one line|
|`gender_mrz`|`rus.visa.type1`|Single character|`M`|Gender from MRZ|
|`name_mrz`|`rus.visa.type1`|String of characters|`DMITRY`|First name from MRZ|
|`surname_mrz`|`rus.visa.type1`|String of characters|`IVANOV`|Last name from MRZ|
|`opt_data_2_mrz`|`rus.visa.type1`|String of characters|`012ABC`|Optional information from second MRZ line|
