* @ValidationCode : MjoxMzg3MTM3MjU0OkNwMTI1MjoxNjg0MjIyNzk2MDI3OklUU1M6LTE6LTE6ODcxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 871
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.NOFILE.ACCT.CLOSURE.RCPT.RT(Y.FINAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.STMT.ENTRY


    LOCATE "ACCOUNT.NUMBER" IN D.FIELDS<1> SETTING LI.POS THEN
        Y.ACCT.ID = D.RANGE.AND.VALUE<LI.POS>
    END
    GOSUB INITIAL
    GOSUB GET.DATA

INITIAL:
    FN.ACC  = "F.ACCOUNT"
    F.ACC  = ""
    R.ACC  = ""
    ACC.ERR = ""
    CALL OPF(FN.ACC,F.ACC)
    FN.AC.CL  = "F.ACCOUNT.CLOSURE"
    F.AC.CL  = ""
    R.AC.CL  = ""
    AC.CL.ERR = ""
    CALL OPF(FN.AC.CL,F.AC.CL)
    FN.CUS = "F.CUSTOMER"
    F.CUS  = ""
    R.CUS  = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,F.CUS)
    FN.NCF  = "F.REDO.NCF.ISSUED"
    F.NCF  = ""
    R.NCF  = ""
    NCF.ERR = ""
    CALL OPF(FN.NCF,F.NCF)
    FN.STMT.EN = "F.STMT.ENTRY"
    F.STMT.EN = ""
    R.STMT.EN = ""
    STMT.EN.ERR = ""
    CALL OPF(FN.STMT.EN,F.STMT.EN)

RETURN

GET.DATA:

    HIS.REC = ''
    YERROR = ''
    FN.AC.HIS = 'F.ACCOUNT$HIS' ; F.AC.HIS = ''
    Y.REC.ID = Y.ACCT.ID
    CALL OPF(FN.AC.HIS,F.AC.HIS)
    CALL EB.READ.HISTORY.REC(F.AC.HIS,Y.REC.ID,HIST.REC,YERROR)
    V.ACCOUNT = Y.ACCT.ID
    V.ACC.TITLE = HIST.REC<AC.ACCOUNT.TITLE.1> : HIST.REC<AC.ACCOUNT.TITLE.2>
    V.ACC.CUSTOMER = HIST.REC<AC.CUSTOMER>
    V.MONTO = HIST.REC<AC.AMNT.LAST.DR.CUST>
    IF V.MONTO LT 0 THEN
        V.MONTO = V.MONTO * -1
    END
    V.MONTO.NCF = HIST.REC<AC.AMNT.LAST.DR.BANK>
    IF V.MONTO.NCF LT 0 THEN
        V.MONTO.NCF = V.MONTO.NCF * -1
    END
    V.CLOSURE.DATE = HIST.REC<AC.CLOSURE.DATE>
    V.CONCEPTO = "CIERRE DE CUENTA"
    V.ACC.STATUS = HIST.REC<AC.RECORD.STATUS>
    Y.ID.NCF = V.ACC.CUSTOMER : "." : V.CLOSURE.DATE : "." : Y.ACCT.ID

    CALL F.READ(FN.NCF,Y.ID.NCF,R.NCF,F.NCF,NCF.ERR)
    V.NCF = R.NCF<ST.IS.NCF>
    IF V.NCF EQ '' THEN
        V.MONTO.NCF = 0.00
    END
    GOSUB GET.DATA2
    IF V.ACC.STATUS EQ "CLOSED" THEN
        GOSUB SET.FINAL
    END
RETURN

GET.DATA2:
    SEL.CMD.0 = "SELECT " : FN.STMT.EN : " WITH ACCOUNT.NUMBER EQ " : Y.ACCT.ID : " AND TRANSACTION.CODE EQ 126 SAMPLE 1"
    CALL EB.READLIST(SEL.CMD.0,SEL.LIST.0,"",NO.OF.RECS.0,SEL.0.ERR)
    LOOP REMOVE RECORD.ID FROM SEL.LIST.0 SETTING STMT.POS.0
    WHILE RECORD.ID DO

        SEL.CMD.0.1 = "SELECT " : FN.STMT.EN : " WITH @ID LIKE  " : RECORD.ID[1,15] : "... AND TRANSACTION.CODE EQ 125"
        CALL EB.READLIST(SEL.CMD.0.1,SEL.LIST.0.1,"",NO.OF.RECS.0.1,SEL.0.1.ERR)
        LOOP REMOVE RECORD.ID.1 FROM SEL.LIST.0.1 SETTING STMT.POS.0.1
        WHILE RECORD.ID.1 DO
            CALL F.READ(FN.STMT.EN,RECORD.ID.1,R.STMT.EN,F.STMT.EN,STMT.EN.ERR)

            IF R.STMT.EN NE '' THEN
                IF R.STMT.EN<AC.STE.AMOUNT.LCY> EQ V.MONTO THEN
                    V.STMT.ACC = R.STMT.EN<AC.STE.ACCOUNT.NUMBER>
                    GOSUB GET.STMT.ACC.INFO
                    BREAK
                END
            END
        REPEAT


    REPEAT

RETURN

GET.STMT.ACC.INFO:
    V.STMT.ACC.TITLE = ''
    CALL F.READ(FN.ACC,V.STMT.ACC,R.ACC,F.ACC,ACC.ERR)
    IF R.ACC NE '' THEN
        V.STMT.ACC.TITLE = R.ACC<AC.ACCOUNT.TITLE.1>
    END ELSE
        CALL EB.READ.HISTORY.REC(F.AC.HIS,V.STMT.ACC,R.ACC,ACC.ERR)
        V.STMT.ACC.TITLE = R.ACC<AC.ACCOUNT.TITLE.1> : R.ACC<AC.ACCOUNT.TITLE.2>
    END


*CALL F.READ(FN.ACC,V.STMT.ACC,R.ACC,F.ACC,ACC.ERR)

*Esto es una cuenta con prefijo DOP o USD...
    IF LEN(V.STMT.ACC) GT 11 AND V.STMT.ACC[1,1] NE "1" THEN
        V.STMT.ACC =  V.STMT.ACC[1,16]
    END
*Esto es una cuenta tipo 1XXXXXXXX
    IF V.STMT.ACC[1,1] EQ "1" THEN
*Con este substring evitamos salga el ;N
        V.STMT.ACC =  V.STMT.ACC[1,10]
    END
RETURN


SET.FINAL:
    Y.FINAL<-1> = V.ACCOUNT : "#" : V.ACC.TITLE : "#" : V.ACC.CUSTOMER : "#" : V.MONTO : "#" : V.MONTO.NCF : "#" : V.CLOSURE.DATE : "#" : V.CONCEPTO : "#" : V.NCF : "#" : V.STMT.ACC : "#" : V.STMT.ACC.TITLE
RETURN

END
