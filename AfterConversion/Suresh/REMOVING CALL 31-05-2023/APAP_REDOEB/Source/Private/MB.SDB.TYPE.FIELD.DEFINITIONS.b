* @ValidationCode : MjotMTYyNzY4NjExOTpDcDEyNTI6MTY4MTM4NDQzNzQ2MjpJVFNTOi0xOi0xOi0xNjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -16
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.TYPE.FIELD.DEFINITIONS
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY

    GOSUB INITIALISE
    GOSUB DEFINE.FIELDS

RETURN
*
*-----------------------------------------------------------------------------
DEFINE.FIELDS:

    ID.F = "SDB.TYPE" ; ID.N = "10..C" ; ID.T = "A"
*
    Z=0
    Z+=1 ; F(Z) = "XX.DESCRIPTION" ; N(Z) = "35.2" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX<BRANCH.CODE" ; N(Z) = "9.1" ; T(Z) = "A"; T(Z)<1> = 'COM'
    CHECKFILE(Z) = "COMPANY":@FM:EB.COM.COMPANY.NAME
    Z+=1 ; F(Z) = "XX-PERIODIC.RENT" ; N(Z) = "19.1" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "XX-VAT.ON.RENT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "XX-REFUND.DEPOSIT" ; N(Z) = "19.1" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "XX>XX.NO.OF.SDB.BR" ; N(Z) = "10.1.C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "TOT.NO.SDB" ; N(Z) = "5" ; T(Z) = ""; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "LOCAL.REF" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.5" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.4" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.3" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.2" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.1" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
*

    V = Z + 9

RETURN
*-----------------------------------------------------------------------------
INITIALISE:

    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""

RETURN
*-----------------------------------------------------------------------------
END
