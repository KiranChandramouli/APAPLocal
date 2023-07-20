* @ValidationCode : MjoyMDc5MTE3NTE6Q3AxMjUyOjE2ODkzMTIzODEzNzg6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 10:56:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>531</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.TDANUCHG.RT(Y.LCO.ID)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.LATAM.CARD.ORDER
    $INSERT  I_F.AC.CHARGE.REQUEST
    $INSERT  I_F.ST.LAPAP.TD.ANUAL.CH
    $INSERT  I_F.DATES
    $INSERT  I_L.APAP.TDANUCHG.COMMON
    $INSERT  I_F.ACCOUNT

    CALL F.READ(FN.DATE,'DO0010001',R.DATE, F.DATE, DATE.ERR)
    Y.LAST.WORKING.DAY = R.DATE<EB.DAT.LAST.WORKING.DAY>
    Y.CAN.PROCESS.FLAG = 'Y'
    CALL F.READ(FN.LCO,Y.LCO.ID,R.LCO, F.LCO, TD.LCO.ERR)
*We're goin to use CARD.IS.ISSUE.DATE instead of CARD.IS.ACTIVE.DATE, because some cards doesn't have actove.date...
    Y.ACTIVE.DATE = R.LCO<CARD.IS.ISSUE.DATE>
*We're going to process if active.date month is today's month and active.date year is not today's year ...
    IF (Y.ACTIVE.DATE[5,2] EQ Y.LAST.WORKING.DAY[5,2]) AND (Y.ACTIVE.DATE[1,4] NE Y.LAST.WORKING.DAY[1,4]) THEN
        Y.CANT.CUS = DCOUNT(R.LCO<CARD.IS.CUSTOMER.NO>,@VM)
        Y.CUSTOMER = R.LCO<CARD.IS.CUSTOMER.NO, Y.CANT.CUS>
        Y.CANT.ACC = DCOUNT(R.LCO<CARD.IS.ACCOUNT>,@VM)
        Y.ACCOUNT = R.LCO<CARD.IS.ACCOUNT, Y.CANT.ACC>
        Y.ST = R.LCO<CARD.IS.CARD.STATUS>
        Y.TYPE.OF.CARD = R.LCO<CARD.IS.TYPE.OF.CARD>
        Y.CARD.TYPE = R.LCO<CARD.IS.CARD.TYPE>

        CALL F.READ(FN.ACC,Y.ACCOUNT,R.ACC, F.ACC, ACC.ERR)
*Excluir de realizar cargos las cuentas de categoría 6007 (ACCOUNT>CATEGORY>6007)
        IF R.ACC<AC.CATEGORY> EQ '6007' THEN
            Y.CAN.PROCESS.FLAG = 'N'
        END
*Excluir de realizar cargos las cuentas marcadas no realizar cargos (ACCOUNT> WAIVE.LEDGER.FEE>Y)
        IF R.ACC<AC.WAIVE.LEDGER.FEE> EQ 'Y' THEN
            Y.CAN.PROCESS.FLAG = 'N'
        END
*Excluir de realizar cargos las cuentas inactivas 3 años y abandonadas (ACCOUNT>L.AC.STATUS1>3YINACTIVE), (ACCOUNT>L.AC.STATUS1>ABANDONED)
        CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS1",AC.POS.1)
        CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS2",AC.POS.2)
        IF R.ACC<AC.LOCAL.REF,AC.POS.1> EQ '3YINACTIVE' THEN
            Y.CAN.PROCESS.FLAG = 'N'
        END
        IF R.ACC<AC.LOCAL.REF,AC.POS.1> EQ 'ABANDONED' THEN
            Y.CAN.PROCESS.FLAG = 'N'
        END
*Excluir de realizar cargos las cuentas con estatus fallecidas (ACCOUNT>L.AC.STATUS2>DECEASED)
        IF R.ACC<AC.LOCAL.REF,AC.POS.2> EQ 'DECEASED' THEN
            Y.CAN.PROCESS.FLAG = 'N'
        END
*Excluir de realizar cargos las TD adicionales(LATAM.CARD.ORDER>TYPE.OF.CARD>ADDITIONAL/ADICIONAL) de las TDVF (LATAM.CARD.ORDER>CARD.TYPE>TDVF)
        IF Y.CARD.TYPE EQ 'TDVF' THEN
            IF Y.TYPE.OF.CARD EQ 'ADDITIONAL' OR Y.TYPE.OF.CARD EQ 'ADICIONAL' THEN
                Y.CAN.PROCESS.FLAG = 'N'
            END
        END

        T.MSG = Y.LCO.ID : " " : TD.LCO.ERR
        CALL OCOMO(T.MSG)
        IF Y.CAN.PROCESS.FLAG EQ 'Y' THEN
            IF Y.ST EQ 74 OR Y.ST EQ 90 OR Y.ST EQ 94 THEN
                Y.CARD.T = Y.LCO.ID[1,4]
                CALL F.READ(FN.TD.ANU,Y.CARD.T,R.TD.ANU, F.TD.ANU, TD.ANU.ERR)
                Y.QNT.CC = DCOUNT(R.TD.ANU<2>,@VM)          ;*ST.LAP10.ACC.CATEGORY TO 2
                CC.POS = ''
                FOR A = 1 TO Y.QNT.CC STEP 1
                    IF R.TD.ANU<2,A> EQ R.ACC<AC.CATEGORY> THEN
                        CC.POS = A
                        BREAK
                    END
                NEXT A
                Y.CHARGE.CODE = R.TD.ANU<1,CC.POS>
                IF CC.POS NE '' THEN
*Y.CHARGE.CODE = R.TD.ANU<1>
                    T.MSG = Y.LCO.ID : "|" : R.ACC<AC.CATEGORY> : "|" : Y.ST : "|" : Y.ACCOUNT : "|" : Y.CHARGE.CODE : "|" : R.TD.ANU<2,A>
*CALL OCOMO(T.MSG)
                    Y.TRANS.ID = ""
                    Y.APP.NAME = "AC.CHARGE.REQUEST"
                    Y.VER.NAME = Y.APP.NAME :",L.APAP.ADI"
                    Y.FUNC = "I"
                    Y.PRO.VAL = "PROCESS"
                    Y.GTS.CONTROL = ""
                    Y.NO.OF.AUTH = ""
                    FINAL.OFS = ""
                    OPTIONS = ""
                    R.ACR = ""

                    R.ACR<CHG.CHARGE.CODE> = Y.CHARGE.CODE
                    R.ACR<CHG.CUSTOMER.NO> = Y.CUSTOMER
                    R.ACR<CHG.DEBIT.ACCOUNT> = Y.ACCOUNT


                    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)
                    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"TD.ADI.CH",'')
                END ELSE
                    CALL OCOMO(Y.LCO.ID : "|" : R.ACC<AC.CATEGORY> : "|" : Y.ST : "|" : "CARGO-CATEGORIA NO PARAMETRIZADO")
                END



            END
        END
*CALL JOURNAL.UPDATE('')
    END



RETURN

END
