* @ValidationCode : MjotMTE5NDk3NzAyNTpDcDEyNTI6MTY4MjA3MDAzNzY2Mjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:10:37
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
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ATM.PARAMETER.FIELD.DEFINITIONS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.CATEGORY
    $INSERT I_F.TRANSACTION
    $INSERT I_F.CURRENCY.MARKET
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CHEQUE.TYPE
*-----------------------------------------------------------------------------
    GOSUB INITIALISE

    GOSUB DEFINE.FIELDS

RETURN
*
*-----------------------------------------------------------------------------
*
DEFINE.FIELDS:

*** FIELD DEFINITIONS FOR ATM.PARAMETER

    ID.F = "KEY" ; ID.N = "10.1" ; ID.T = '' ; ID.T = 'A'
*
    Z = 0
*
    Z+=1 ; F(Z) = "BANK.IMD" ; N(Z) ="006.1.C"
    Z+=1 ; F(Z) = "XX<NETWORK.IMD" ; N(Z) = "010..C" ; T(Z) = "ANY"
    Z+=1 ; F(Z) = "XX-NET.IMD.CATEG" ; N(Z) = "6..C" ; T(Z)<4> = "R##-###"
    CHECKFILE(Z) = "CATEGORY":@FM:EB.CAT.DESCRIPTION:@FM:"L"
    Z+=1 ; F(Z) = "XX-NET.IMD.AC.SUFX" ; N(Z) = "8" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX>NET.IMD.INT.AC" ; N(Z) = "12..C" ; T(Z)="INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.SHORT.TITLE:@FM:"L"
    Z+=1 ; F(Z) = "TXN.GCC.INT.AC" ; N(Z) = "12..C" ; T(Z) = "INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.SHORT.TITLE:@FM:"L"
    Z+=1 ; F(Z) = "ACCT.NO.LEN" ; N(Z) = "2.1.C"
    Z+=1 ; F(Z) = "XX.CHEQUE.TYPE" ; N(Z) = "4" ; T(Z) = "A"
    CHECKFILE(Z) = "CHEQUE.TYPE":@FM:CHEQUE.TYPE.DESCRIPTION:@FM:"L"
    Z+=1 ; F(Z) = "BAL.UPLOAD.FILE" ; N(Z) = "20.1.C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "BAL.UPLOAD.PATH" ; N(Z) = "40..C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "CARD.UPLOAD.FILE" ; N(Z) = "20.1.C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "CARD.UPLOAD.PATH" ; N(Z) = "40..C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "LOG.FILE.LOC" ; N(Z) = "40..C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "DAYS.IN.HIST" ; N(Z) = "2.1"
    Z+=1 ; F(Z) = "DB.TXN.CODE" ; N(Z) = "3.1.C"
    CHECKFILE(Z) = "TRANSACTION":@FM:AC.TRA.NARRATIVE:@FM:"L"
    Z+=1 ; F(Z) = "CR.TXN.CODE" ; N(Z) = "3.1.C"
    CHECKFILE(Z) = "TRANSACTION":@FM:AC.TRA.NARRATIVE:@FM:"L"
    Z+=1 ; F(Z) = "DB.SUSP.ACCT" ; N(Z) = "12.1.C" ; T(Z)="INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.SHORT.TITLE:@FM:"L"
    Z+=1 ; F(Z) = "CR.SUSP.ACCT" ; N(Z) = "12.1.C" ; T(Z)="INT"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.SHORT.TITLE:@FM:"L"
    Z+=1 ; F(Z) = "COMM.CATEG" ; N(Z) = "6..C" ; T(Z)<4> = "R##-###"
    CHECKFILE(Z) = "CATEGORY":@FM:EB.CAT.DESCRIPTION:@FM:"L"
    Z+=1 ; F(Z) = "POSTING.DATE" ; N(Z) = "15.1.C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX.LOCAL.REF" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX.ATM.SERVICES" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "MARKET" ; N(Z) = "2" ; T(Z)<3> = "NOINPUT"
    CHECKFILE(Z) = "CURRENCY.MARKET":@FM:EB.CMA.DESCRIPTION:@FM:"L"
    Z+=1 ; F(Z) = "XX.LOG.FILE.PATH" ; N(Z) = "50" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "XX.BAL.FILE.PATH" ; N(Z) = "50" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "XX.CRD.FILE.PATH" ; N(Z) = "50" ; T(Z)<3> = "NOINPUT"
* Srivats - 20020218 field to determine download level of balances
    Z+=1 ; F(Z) = "DOWNLOAD.LEVEL" ; N(Z) = "10" ; T(Z)<2> = "FULL_MOVEMENT"
*
*
    Z+=1 ; F(Z) = "ACC.MAP.RTN" ; N(Z) = "35" ; T(Z) = 'A' ; T(Z)<3> = ""
    Z+=1 ; F(Z) = "AT.BAL.REQ" ; N(Z) = "1" ; T(Z) = 'A'
    Z+=1 ; F(Z) = "MAP.ENQ.LOCN" ; N(Z) = "35" ; T(Z) = 'A' ; T(Z) = "A"
    Z+=1 ; F(Z) = "FTP.UPLOAD.IP" ; N(Z) = "35" ; T(Z) = 'A'
    Z+=1 ; F(Z) = "FTP.USER" ; N(Z) = "35" ; T(Z) = 'A'
    Z+=1 ; F(Z) = "FTP.PASSWORD" ; N(Z) = "35" ; T(Z) = 'A'
    Z+=1 ; F(Z) = "FTP.REMOTE.DIR" ; N(Z) = "50" ; T(Z) = 'A'
    Z+=1 ; F(Z) = "XX.ENQ.CHG.PCODE" ; N(Z) = "15" ; T(Z) = 'A'
*    Z+=1 ; F(Z) = "DEFAULT.IMD" ; N(Z) = "15" ; T(Z) = 'A'
    Z+=1 ; F(Z) = "RESERVED2" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED1" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "XX.OVERRIDE" ; N(Z) = "35" ; T(Z)<3>= "NOINPUT"

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
