* @ValidationCode : MjotMTM4MzM1MjExOkNwMTI1MjoxNjgyNDEyMzU0MDcwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.TEMP.ACCOUNT.SEARCH.VP
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Edwin Charles D
*Program   Name    :REDO.V.TEMP.ACCOUNT.SEARCH.VP
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as VALIDATION  routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it it R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date           who                   Reference                           Description
* 29-JUN-2017     Edwin Charles D        R15 Upgrade                      Initial Creation
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T              R22 Manual Code Conversion         No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_System
    $INSERT I_F.REDO.SUNNEL.PARAMETER

    IF VAL.TEXT NE '' OR MESSAGE EQ 'VAL' THEN
        RETURN
    END

    FN.REDO.SUNNEL.PARAMETER='F.REDO.SUNNEL.PARAMETER'
    F.REDO.SUNNEL.PARAMETER=''

    GOSUB INIT
    GOSUB CHECK.STATUS
RETURN

*---------
INIT:
*---------

    LREF.APP = APPLICATION
    LREF.POS = ''
    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
        VAR.CARD.NO = R.NEW(FT.TN.L.FT.CR.CARD.NO)
        CALL System.setVariable("CURRENT.CARD.NO",VAR.CARD.NO)
        VAR.CARD.NO = VAR.CARD.NO[1,6]:'******':VAR.CARD.NO[13,4]
        R.NEW(FT.TN.L.FT.CR.CARD.NO) = VAR.CARD.NO
        Y.CARD.ACCT.ST = R.NEW(FT.TN.L.FT.AC.STATUS)
    END
RETURN

*------------
CHECK.STATUS:
*------------
    CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,'SYSTEM',R.REDO.SUNNEL.PARAMETER,ERR)
    Y.STATUS<2> = R.REDO.SUNNEL.PARAMETER<SP.CLOSED.STATUS>

    IF Y.CARD.ACCT.ST EQ Y.STATUS<2> THEN
        ETEXT="EB-REDO.CARD.CLOSED"
        CALL STORE.END.ERROR
    END
RETURN
END
