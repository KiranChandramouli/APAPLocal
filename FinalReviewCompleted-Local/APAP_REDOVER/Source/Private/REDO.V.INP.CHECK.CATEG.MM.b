* @ValidationCode : MjotMTIxNTg3MzQxOkNwMTI1MjoxNjgyNDEyMzQ4MjM5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:48
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
SUBROUTINE REDO.V.INP.CHECK.CATEG.MM
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.REDO.SC.MM.VERSION.PARAM


MAIN:

    FN.REDO.SC.MM.VERSION.PARAM = 'F.REDO.SC.MM.VERSION.PARAM'
    F.REDO.SC.MM.VERSION.PARAM = ''
    CALL OPF(FN.REDO.SC.MM.VERSION.PARAM,F.REDO.SC.MM.VERSION.PARAM)

    Y.ID = ID.NEW
    CALL F.READ(FN.REDO.SC.MM.VERSION.PARAM,Y.ID,R.REDO.SC.MM.VERSION.PARAM,F.REDO.SC.MM.VERSION.PARAM,PAR.ERR)
    Y.PAR.CATEG = R.REDO.SC.MM.VERSION.PARAM<REDO.SMV.CATEGORY>

    Y.MM.CATEG = R.NEW(MM.CATEGORY)

    IF Y.PAR.CATEG NE Y.MM.CATEG THEN
        AF = MM.CATEGORY
        ETEXT = 'EB-CATEG.NOT.SAME'
        CALL STORE.END.ERROR
    END

    Y.CUR = R.NEW(MM.CURRENCY)
    LOCATE Y.CUR IN R.REDO.SC.MM.VERSION.PARAM<REDO.SMV.CURRENCY,1> SETTING POS THEN
        R.NEW(MM.DRAWDOWN.ACCOUNT) = R.REDO.SC.MM.VERSION.PARAM<REDO.SMV.ACCOUNT,POS>
    END

RETURN

END
