* @ValidationCode : MjotMTkwNjkyMDcxNDpDcDEyNTI6MTY4MjMzMTMyMTkyNzpJVFNTOi0xOi0xOjQ4MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 480
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.GET.CARD.ACC.RT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       VM to @VM,  ++ to +=
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.BIN

    GOSUB INI
    GOSUB OPEN.FILES
    GOSUB GET.ACCOUNT
    GOSUB FIN

INI:
    Y.NO.TARJETA = O.DATA
    SEL.LIST = ''
    NO.OF.RECS = ''
    SEL.ERR = ''
RETURN

OPEN.FILES:
    FN.ACC  = "FBNK.ACCOUNT"
    FV.ACC  = ""
    R.ACC  = ""
    ACC.ERR = ""
    CALL OPF(FN.ACC,FV.ACC)
    FN.LCO = "F.LATAM.CARD.ORDER"
    FV.LCO = ""
    R.LCO = ""
    LCO.ERR = ""
    CALL OPF(FN.LCO,FV.LCO)

    FN.RCB = "F.REDO.CARD.BIN"
    FV.RCB = ""
    R.RCB = ""
    RCB.ERR= ""
    CALL OPF(FN.RCB,FV.RCB)

    Y.ACCOUNT=""
RETURN

GET.ACCOUNT:

    Y.TD.ACC.ID=''

    Y.CARD.BIN=Y.NO.TARJETA[1,6]
    CALL F.READ(FN.RCB,Y.CARD.BIN,R.RCB,FV.RCB,RCB.ERR)

    IF R.RCB THEN
        Y.CARD.TYPE=R.RCB<REDO.CARD.BIN.CARD.TYPE>
        Y.COUNT = DCOUNT(Y.CARD.TYPE,@VM)

        Y.CNT =1
        LOOP
        WHILE Y.CNT LE Y.COUNT
            Y.ID.TYPE = Y.CARD.TYPE<1,Y.CNT>
            Y.TD.ACC.ID = Y.ID.TYPE:'.':Y.NO.TARJETA
            CALL F.READ(FN.LCO, Y.TD.ACC.ID , R.LCO, FV.LCO, LCO.ERR)
            IF R.LCO THEN
                Y.ACCOUNT = R.LCO<CARD.IS.ACCOUNT>
                BREAK
            END
            Y.CNT += 1
        REPEAT
    END

RETURN
FIN:
    O.DATA = Y.ACCOUNT
RETURN

END
