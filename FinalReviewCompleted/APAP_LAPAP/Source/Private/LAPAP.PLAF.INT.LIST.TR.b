* @ValidationCode : MjotMTk5MjAyMDc3NTpVVEYtODoxNjg5NzQ5NjU2MTYyOklUU1M6LTE6LTE6Mzg0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:16
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 384
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PLAF.INT.LIST.TR(Y.REC)
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.LAPAP.PLAF.NOTIFY.PARAM
    $INSERT I_F.REDO.RESTRICTIVE.LIST ;*  R22 Auto Conversion -END

    GOSUB LOAD
    GOSUB PROCESS
    GOSUB SEND.NOTIFY
RETURN
LOAD:
    Y.DATA                  = Y.REC

    IF Y.DATA GT " " THEN
        Y.PARAM.ID          = "LISTA.RESTRICTIVA"
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

*Busca en lista interna
    NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.LIST = ''; LIST.POS = '';
    SEL.CMD = "SELECT ":FN.REDO.RESTRICTIVE.LIST:" WITH NUMERO.DOCUMENTO EQ " :Y.DATA"";
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
    Y.ID = SEL.LIST;
    R.REST =''; REST.ERR ='';
    CALL F.READ(FN.REDO.RESTRICTIVE.LIST,Y.ID,R.REST,F.REDO.RESTRICTIVE.LIST,REST.ERR)
    Y.CED.ID           = R.REST<RESTR.LIST.NUMERO.DOCUMENTO>
    Y.NAME             = R.REST<RESTR.LIST.NOMBRES>
    Y.LAST.NAME        = R.REST<RESTR.LIST.APELLIDOS>
    Y.CUS.NAME         = Y.NAME:" ":Y.LAST.NAME
    Y.CUS.NAME         = CHANGE(Y.CUS.NAME,"]"," ")
    Y.NACIONALITY      = R.REST<RESTR.LIST.NACIONALIDAD>
RETURN

SEND.NOTIFY:

    V.EB.API.ID = 'LAPAP.PLAF.INT.LIST.TR'
    Y.PARAMETRO.ENVIO = Y.PERFIL:"::":Y.SYSTEM:"::":Y.EMAIL:"::":Y.CUS.NAME:"::":Y.CED.ID:"::":Y.NACIONALITY:"::":Y.COMCEPTO:"::":"N/A"

    CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)
RETURN
END
