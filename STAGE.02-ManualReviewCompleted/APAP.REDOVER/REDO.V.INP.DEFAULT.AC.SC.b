* @ValidationCode : MjotMTUwNDkxNDk0NTpDcDEyNTI6MTY4MTIxMzgwMDA0MjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:20:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.DEFAULT.AC.SC
*-------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.REDO.SC.MM.VERSION.PARAM

MAIN:


    FN.REDO.SC.MM.VERSION.PARAM = 'F.REDO.SC.MM.VERSION.PARAM'
    F.REDO.SC.MM.VERSION.PARAM = ''
    CALL OPF(FN.REDO.SC.MM.VERSION.PARAM,F.REDO.SC.MM.VERSION.PARAM)

    Y.ID = APPLICATION:PGM.VERSION
    CALL F.READ(FN.REDO.SC.MM.VERSION.PARAM,Y.ID,R.REDO.SC.MM.VERSION.PARAM,F.REDO.SC.MM.VERSION.PARAM,PAR.ERR)

    Y.CUR = R.NEW(SC.SBS.SECURITY.CURRENCY)

    LOCATE Y.CUR IN R.REDO.SC.MM.VERSION.PARAM<REDO.SMV.CURRENCY,1> SETTING POS THEN
        R.NEW(SC.SBS.BR.ACC.NO) = R.REDO.SC.MM.VERSION.PARAM<REDO.SMV.ACCOUNT,POS>
    END
RETURN

END
