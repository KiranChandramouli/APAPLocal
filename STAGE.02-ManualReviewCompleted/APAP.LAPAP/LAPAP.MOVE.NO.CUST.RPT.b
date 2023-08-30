$PACKAGE APAP.LAPAP
* @ValidationCode : MjoxODg5MzIyNDk4OkNwMTI1MjoxNjgyMDc3ODI4NTIwOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:20:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

SUBROUTINE LAPAP.MOVE.NO.CUST.RPT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE              DESCRIPTION

* 21-APR-2023  Conversion tool   R22 Auto conversion    BP is removed in Insert File, INCLUDE to INSERT , FM to @FM
* 21-APR-2023    Narmadha V      R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.HOLD.CONTROL ;*R22 Auto conversion - END

    GOSUB LOAD.FILE
    GOSUB PROCESS

LOAD.FILE:
    Y.TODAY = TODAY
    Y.NAME.FINAL = "Divisas_No_Clientes_":Y.TODAY:".txt"

    FN.HOLD.CONTROL = 'F.HOLD.CONTROL'
    F.HOLD.CONTROL = ''
    CALL OPF(FN.HOLD.CONTROL,F.HOLD.CONTROL)

    FN.DIR.ORIGEN   ='../bnk.data/eb/&HOLD&'
    F.DIR.ORIGEN    =''
    CALL OPF(FN.DIR.ORIGEN,F.DIR.ORIGEN)

    FN.DIR.DESTINO   ='../bnk.data/eb/&HOLD&'
    F.DIR.DESTINO   =''
    CALL OPF(FN.DIR.DESTINO,F.DIR.DESTINO)


    DIR.ORIGEN          = '../bnk.data/eb/&HOLD&'
    OPEN DIR.ORIGEN TO DIR.ORIGEN ELSE
    END
    DIR.DESTINO         = '../bnk.interface/REG.REPORTS'
    OPEN DIR.DESTINO TO DIR.DESTINO ELSE
    END

RETURN

PROCESS:

    NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.HOLD = ''; HOLD.POS = '';
    SEL.CMD = "SELECT ":FN.HOLD.CONTROL:" WITH REPORT.NAME EQ 'LAPAP.ENQ.NO.CUS' AND BANK.DATE EQ " :Y.TODAY"";

    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
    Y.COUNT.CUST = DCOUNT(SEL.LIST,@FM);
*IF Y.COUNT.CUST GT 0 THEN
*    Y.RPT.ID = SEL.LIST;
*END

    LOOP
        REMOVE Y.RPT.ID FROM SEL.LIST SETTING CUS.POS
    WHILE Y.RPT.ID DO
        EXECUTE 'COPY FROM &HOLD& TO ../bnk.interface/REG.REPORTS ':Y.RPT.ID:",":Y.NAME.FINAL
    REPEAT
RETURN
END
