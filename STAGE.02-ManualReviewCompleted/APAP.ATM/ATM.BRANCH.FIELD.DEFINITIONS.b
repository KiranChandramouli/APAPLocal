* @ValidationCode : MjoxMTc3MzE5NzQ2OkNwMTI1MjoxNjgyMDY5MTIzMzE5OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 14:55:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM,
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ATM.BRANCH.FIELD.DEFINITIONS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*/gp Changed id field properties to include identification of atms at HBL
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CATEGORY
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.TXN.TYPE.CONDITION
*-----------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB DEFINE.FIELDS

RETURN
*
*-----------------------------------------------------------------------------
*
DEFINE.FIELDS:
*Modified for PACS00054730----------------------------------------------------
    ID.F = "ATM.BRANCH.CODE" ; ID.N = "008.1" ; ID.T = 'A'
*end of Modification----------------------------------------------------------
    Z = 0
*
* Srivats 20020306 - Removed Check fields (WAFA specific change)
*      Z+=1 ; F(Z) = "COMPANY.CODE" ; N(Z) ="10.1.C" ; T(Z) = "COM"
    Z+=1 ; F(Z) = "COMPANY.CODE" ; N(Z) ="10.1" ; T(Z) = "COM"
    CHECKFILE(Z) = "COMPANY":@FM:EB.COM.MNEMONIC:@FM:"L"
    Z+=1 ; F(Z) = "XX<DEVICE.ID" ; N(Z) = "004.1"
    Z+=1 ; F(Z) = "XX-DEV.ID.CATEG" ; N(Z) = "6..C" ; T(Z)<4> = "R##-###"
    CHECKFILE(Z) = "CATEGORY":@FM:EB.CAT.DESCRIPTION:@FM:"L"
    Z+=1 ; F(Z) = "XX-DEV.ID.AC.SUFX" ; N(Z) = "8..C" ; T(Z) = "A"
*    Z+=1 ; F(Z) = "XX-DEV.ID.AC.SUFXE"; N(Z) = "4" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX>DEV.ID.INT.ACCT" ; N(Z) = "12..C" ; T(Z)="INT"
* CHECKFILE(Z) = "ACCOUNT":FM:AC.SHORT.TITLE:FM:"L"
    Z+=1 ; F(Z) = "XX<UTILITY.NAME" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-UTIL.NO" ; N(Z) = "002"
    Z+=1 ; F(Z) = "XX-UTIL.CATEG" ; N(Z) = "6..C"
    CHECKFILE(Z) = "CATEGORY":@FM:EB.CAT.DESCRIPTION:@FM:"L" ; T(Z)<4> = "R##-###"
    Z+=1 ; F(Z) = "XX-UTIL.AC.SUFX" ; N(Z) = "004..C"
    Z+=1 ; F(Z) = "XX>UTIL.INT.ACCT" ; N(Z) = "12..C" ; T(Z)="INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.SHORT.TITLE:@FM:"L"
    Z+=1 ; F(Z) = "XX.LOCAL.REF" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "BOOK.CODE" ; N(Z) = "35" ; T(Z) = ''

*
    Z+=1 ; F(Z) = "TRANSACTION.TYPE" ; N(Z) = "6" ; T(Z) = 'A'
    CHECKFILE(Z) = "FT.TXN.TYPE.CONDITION":@FM:FT6.SHORT.DESCR:@FM:"L"
*

    Z+=1 ; F(Z) = "RESERVED8" ; N(Z) = "35" ; T(Z) = ''
    T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "RESERVED7" ; N(Z) = "35" ; T(Z) = ''
    T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "RESERVED6" ; N(Z) = "35" ; T(Z) = ''
    T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "RESERVED5" ; N(Z) = "35" ; T(Z) = ''
    T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "RESERVED4" ; N(Z) = "35" ; T(Z) = ''
    T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "RESERVED3" ; N(Z) = "35" ; T(Z) = ''
    T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "RESERVED2" ; N(Z) = "35" ; T(Z) = ''
    T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "RESERVED1" ; N(Z) = "35" ; T(Z) = ''
    T(Z)<3> = "NOINPUT"
*

    V = Z + 9
RETURN
*
*-----------------------------------------------------------------------------
*
INITIALISE:
    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
*
* Define often used checkfile variables
*
RETURN
*
*-----------------------------------------------------------------------------
*
END
