* @ValidationCode : MjoxMTY2MDgzMDc2OkNwMTI1MjoxNjk4NDA1NTM5OTU4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.TGIBS.READ.CONCAT(Y.DATA,RESPONSE.PARAM)

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                Nochanges
*-----------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    Y.FILE.NAME = TRIM(FIELDS(Y.DATA,"*",1))
    Y.ID = TRIM(FIELDS(Y.DATA,"*",2))

    R.CONCAT = ""
*    PRINT Y.FILE.NAME : "-" : Y.ID

    IF Y.FILE.NAME EQ "" OR Y.ID EQ "" THEN
        RESPONSE.PARAM = ""
        RETURN
    END

    FN.FILE = Y.FILE.NAME
    F.FILE = ""

    CALL OPF(FN.FILE,F.FILE)

    READ R.CONCAT FROM F.FILE, Y.ID  ELSE
        Y.ERROR = "RECORD MISSING"
    END

RESPONSE.PARAM = FIELDS(R.CONCAT<1,1,1>,'*',2)

    RETURN
