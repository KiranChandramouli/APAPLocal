* @ValidationCode : MjozMjM3NzkzNzU6VVRGLTg6MTY4OTc0OTY1NjE5NTpJVFNTOi0xOi0xOjI4NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:16
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 285
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PLAF.NOTIFY.RT(REC)
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,FM to @FM,VM to @VM,SM to @SM
* 14-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.LAPAP.PLAF.NOTIFY.PARAM
    $INSERT I_F.REDO.RESTRICTIVE.LIST ;*R22 Auto Conversion -END

    GOSUB LOAD
    GOSUB PROCESS
    GOSUB SEND.NOTIFY
RETURN
LOAD:
    Y.DATA                  = REC

    IF Y.DATA EQ "RESTRICTIVA" THEN
        Y.PARAM.ID          = "LISTA.RESTRICTIVA"
    END

    IF Y.DATA EQ "JUDICIAL" THEN
        Y.PARAM.ID          = "DATA.JUDICIAL"
    END

    FN.REDO.RESTRICTIVE.LIST = 'F.REDO.RESTRICTIVE.LIST'
    F.REDO.RESTRICTIVE.LIST = ''
    CALL OPF(FN.REDO.RESTRICTIVE.LIST,F.REDO.RESTRICTIVE.LIST)

    FN.ST.APAP.PLAF.NOTIFY.PARAM = 'F.ST.LAPAP.PLAF.NOTIFY.PARAM'
    F.ST.APAP.PLAF.NOTIFY.PARAM = ''
    CALL OPF(FN.ST.APAP.PLAF.NOTIFY.PARAM,F.ST.APAP.PLAF.NOTIFY.PARAM)

RETURN

PROCESS:
    R.PARAM =''; PARAM.ERR ='';
    CALL F.READ(FN.ST.APAP.PLAF.NOTIFY.PARAM,Y.PARAM.ID,R.PARAM,F.ST.APAP.PLAF.NOTIFY.PARAM,PARAM.ERR)
    Y.PERFIL             = R.PARAM<ST.FT.LAP94.PLANTILLA>
    Y.SYSTEM             = R.PARAM<ST.FT.LAP94.SYSTEM>
    Y.EMAIL              = R.PARAM<ST.FT.LAP94.EMAIL>
    Y.COMCEPTO           = R.PARAM<ST.FT.LAP94.CONCEPTO>


    Y.CED.ID            = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER);
    Y.CUS.NAME          = R.NEW(REDO.CUS.PRF.CUSTOMER.NAME);
    Y.LOC.REF           = R.NEW(REDO.CUS.PRF.LOCAL.REF);
    Y.LOC.REF           = CHANGE(Y.LOC.REF,@VM,@FM)
    Y.LOC.REF           = CHANGE(Y.LOC.REF,@SM,@FM)
    Y.NACIONALITY       = Y.LOC.REF<4>
    Y.BRITHDATE         = Y.LOC.REF<5>
RETURN

SEND.NOTIFY:

    V.EB.API.ID = 'LAPAP.PLAF.NOTIFY.RT'
    Y.PARAMETRO.ENVIO = Y.PERFIL:"::":Y.SYSTEM:"::":Y.EMAIL:"::":Y.CUS.NAME:"::":Y.CED.ID:"::":Y.NACIONALITY:"::":Y.COMCEPTO:"::":Y.BRITHDATE

    CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)
RETURN
END
