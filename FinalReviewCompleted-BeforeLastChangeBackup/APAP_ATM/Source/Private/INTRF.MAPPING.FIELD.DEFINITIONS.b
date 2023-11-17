* @ValidationCode : MjoxOTEzMjExMjI2OkNwMTI1MjoxNjg0NTAyMzc4MzcyOmFqaXRoOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 18:49:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE INTRF.MAPPING.FIELD.DEFINITIONS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*  DATE            WHO          REFERENCE           DESCRIPTION
* 13 Dec 2010   Balagurunathan    ODR-2010-08-0469  Id lenth is changed
* Date                  who                   Reference
* 24-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 24-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
*
*-----------------------------------------------------------------------------
    GOSUB INITIALISE

    GOSUB DEFINE.FIELDS

RETURN
*
*-----------------------------------------------------------------------------
*
DEFINE.FIELDS:

*** FIELD DEFINITIONS FOR INTRF.MAPPING

    ID.F = "INTRF.MAPPING.KEY" ; ID.N = "26.1" ; ID.T = 'A'
*
    Z = 0
*
    Z+=1 ; F(Z) = "XX.LL.DESCRIPTION" ; N(Z) ="35.1" ; T(Z) = "A"
    Z+=1 ; F(Z) = "MSG.TYPE" ; N(Z) = "15" ; T(Z) = "" ; T(Z)<2> = "REQUEST_RESPONSE_ERROR"
    Z+=1 ; F(Z) = "APPLICATION" ; N(Z) = "40..C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "OFS.FUNCTION" ; N(Z) = "1" ; T(Z) = "A"
    Z+=1 ; F(Z) = "OFS.OPERATION" ; N(Z) = "10" ; T(Z) = "A"
    Z+=1 ; F(Z) = "OFS.UTIL.NAME" ; N(Z) = "40" ; T(Z)="A"
*29-10-03 S
    Z+=1 ; F(Z) = "OFS.COM.CODE" ; N(Z) = "35" ; T(Z)="A"

    Z+=1 ; F(Z) = "ID.GEN" ; N(Z) = "60" ; T(Z) = "A"

    Z+=1 ; F(Z) = "OFS.USER" ; N(Z) = "20.1.C" ; T(Z) = "A"
    CHECKFILE(Z) = "USER.SIGN.ON.NAME"
    Z+=1 ; F(Z) = "OFS.PASSWORD" ; N(Z) ="35" ; T(Z)= "PASSWD"
    Z+=1 ; F(Z) = "RES.MAP.ID" ; N(Z) = "26" ; T(Z) = "A"
    Z+=1 ;
    F(Z) = "ERROR.MAP.ID" ; N(Z) = "13" ; T(Z) = "A"
    CHECKFILE(Z)='INTRF.MAPPING'
    Z+=1 ; F(Z) = "XX<INTRF.FLD.NAME" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-XX.INTRF.FLD.PS" ; N(Z)="35" ; T(Z)="A"
    Z+=1 ; F(Z) = "XX-GLO.FLD.NAME" ; N(Z) = "32..C" ; T(Z) = "A"

    Z+=1 ; F(Z) = "XX-GLO.FLD.LN.TYPE" ; N(Z) = "3" ; T(Z) = ""
    T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "XX-GLO.CONSTANT" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-FIELD.SOURCE" ; N(Z) = "9" ; T(Z)<2> = "INT_EXT_TAB_RTN_CLS_CON_ENQ.SEL_ENQ.VAL"
    Z+=1 ; F(Z) = "XX>FIELD.SRC.VALUE" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "RES.Y.N" ; N(Z)="1" ; T(Z)=""; T(Z)<2> = "Y_N"
    Z+=1 ; F(Z) = "ERROR.CONV.TAB" ; N(Z) = "6" ; T(Z) = "A"
    CHECKFILE(Z) = "INTRF.ERROR"
    Z+=1 ; F(Z) = "ERROR.ID" ; N(Z) = "35" ; T(Z) = "A"

*Z+=1 ; F(Z) = "ENQ.CHG.RTN" ; N(Z) = "20" ; T(Z) = "A"


*
*
    Z+=1 ; F(Z) = "RESERVED10" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED9" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED8" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED7" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED6" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED5" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED4" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED3" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
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
