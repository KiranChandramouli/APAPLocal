* @ValidationCode : MjotODkzNzAyMDE3OlVURi04OjE2ODk3NDk2NTc1NjA6SVRTUzotMTotMTotODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:17
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.UPD.AV.BAL
*-----------------------------------------------------------------------------------------------------------*
* Company Name   : APAP                                                                                     *
* Program Name   : LAPAP.UPD.AV.BAL                                                                         *
* Date           : 2017-09-01                                                                               *
* Author         : RichardHC                                                                                *
*-----------------------------------------------------------------------------------------------------------*
* Description:                                                                                              *
*------------                                                                                               *
* This program allow modify the balance available in corrupt accounts                                       *
*-----------------------------------------------------------------------------------------------------------*
*                                                                                                           *
* Modification History :                                                                                    *
* ----------------------                                                                                    *
*   Date           Author            Modification Description                                               *
* -------------  -----------       ---------------------------                                              *
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 17-07-2023    Narmadha V             R22 Manual Conversion   No Changes                                                                                                       *
*-----------------------------------------------------------------------------------------------------------*

*Importing the commons library and tables
    $INSERT I_COMMON ;*R22 Auto Conversion -STRAT
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.UPDATE.AV.BAL
    $INSERT I_F.ACCOUNT ;*R22 Auto Conversion -END
   $USING EB.LocalReferences


*Capturing the variable from browser layer.
    VAR.ID =  R.NEW(ST.LAP71.ACCOUNT.NUMBER)

*Using the corresponding version for ACCOUNT table.
    Y.VER.NAME = "ACCOUNT,MB.DM.LOAD"

*Table name.
    Y.APP.NAME = "ACCOUNT"

*Default value to send for imputter function.
    Y.FUNC = "I"

*Another important variables to fill during OFS message building.
    Y.PRO.VAL = "PROCESS"

    Y.GTS.CONTROL = ""

    Y.NO.OF.AUTH = ""

    FINAL.OFS = ""

    OPTIONS = ""

    R.ACC = ""

*Function to get the array number in local account.
*    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.AV.BAL",ACC.POS);* R22 UTILITY AUTO CONVERSION

*Asign the value 0 to previous result.
    R.ACC<AC.LOCAL.REF,ACC.POS> = "0"

*Building OFS message to send the request to T24.
    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,VAR.ID,R.ACC,FINAL.OFS)

*Putting the previous message in queue to be process through BNK/OFS.MESSAGE.SERVICE service.
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"DM.OFS.SRC.VAL",'')


END
