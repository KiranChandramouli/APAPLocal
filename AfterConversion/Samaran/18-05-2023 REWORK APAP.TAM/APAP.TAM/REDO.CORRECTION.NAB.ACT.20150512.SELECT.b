* @ValidationCode : Mjo1NTUxMzYwNDU6Q3AxMjUyOjE2ODQ0MTA0ODY2ODg6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 May 2023 17:18:06
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.CORRECTION.NAB.ACT.20150512.SELECT

** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.HELPTEXT
    $INSERT I_REDO.CORRECTION.NAB.ACT.20150512.COMMON



    CALL F.READ(FN.HELPTEXT,"REDO.NAB.CORRECTION.20150512-GB",R.HELPTEXT,F.HELPTEXT,HELP.ERR)
    Y.AA.IDS = R.HELPTEXT<EB.HLP.DETAIL>
    CHANGE @SM TO @FM IN Y.AA.IDS
    CHANGE @VM TO @FM IN Y.AA.IDS


    CALL BATCH.BUILD.LIST('', Y.AA.IDS)

RETURN

END
