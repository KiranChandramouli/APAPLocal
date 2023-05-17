SUBROUTINE LATAM.CARD.ORDER.SPLIT.PROCESS(ACCOUNT.ID,ACCOUNT,CARD.CHARGE,CHARGES,CHARGE.DATE,LCY.AMT)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.SPLIT.VALIDATE.1
*--------------------------------------------------------------------------------------------------------
*Description  : This is a process routine called in LATAM.CARD.ORDER.PROCESS
*Linked With  : LATAM.CARD.ORDER
*In Parameter : ACCOUNT.ID,ACCOUNT,CARD.CHARGE,CHARGES,CHARGE.DATE,LCY.AMT
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 9 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
* 20 MAY 2011   KAVITHA                PACS00024249              STOCK REGISTER Updation has been removed as new design has been implemented for stock maintainence
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.ISSUE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CARD.CHARGE
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.DATES
    $INSERT I_F.PAYMENT.STOP.TYPE
    $INSERT I_F.CARD.STATUS
    $INSERT I_F.COMPANY
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CARD.REPAYMENT.DATE
    $INSERT I_F.CARD.BILL.CLOSE.DATE
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.STOCK.PARAMETER
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.MNEMONIC.DAO
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_GTS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.LATAM.CARD.CLASS.CODE
*-----------------------------------------------



    GOSUB INIT.PARA
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------
**********
INIT.PARA:
**********
    FN.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.CARD.ORDER  = ''
    CALL OPF(FN.CARD.ORDER,F.CARD.ORDER)

    FN.CARD.ORDER.NAU = 'F.LATAM.CARD.ORDER$NAU'
    F.CARD.ORDER.NAU = ''
    CALL OPF(FN.CARD.ORDER.NAU,F.CARD.ORDER.NAU)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FV.CRD.TYP = 'F.CARD.TYPE'
    FP.CRD.TYP = ''
    CALL OPF(FV.CRD.TYP,FP.CRD.TYPE)

    AZ.INSTALLED = 0
    LOCATE 'AZ' IN R.COMPANY(EB.COM.APPLICATIONS)<1,1> SETTING AZ.INSTALLED THEN
        FV.AZ.ACC = 'F.AZ.ACCOUNT'
        FP.AZ.ACC = ''
        CALL OPF(FV.AZ.ACC,FP.AZ.ACC)
        AZ.INSTALLED = 1
    END
*
    FV.STO.REG = 'F.STOCK.REGISTER'
    FP.STO.REG = ''
    CALL OPF(FV.STO.REG,FP.STO.REG)
*
    AZ.ACC.REC = ''
**
    FV.CRD.ISS = 'F.CARD.ISSUE'
    FP.CRD.ISS = ''
    CALL OPF(FV.CRD.ISS,FP.CRD.ISS)
*
    FV.CRD.ISS.AC = 'F.CARD.ISSUE.ACCOUNT'
    FP.CRD.ISS.AC = ''
    CALL OPF(FV.CRD.ISS.AC,FP.CRD.ISS.AC)
*
    AZ.INSTALLED = 0
    LOCATE 'AZ' IN R.COMPANY(EB.COM.APPLICATIONS)<1,1> SETTING AZ.INSTALLED THEN
        FV.AZ.ACT.SUB.ACC = 'F.AZ.ACTIVE.SUB.ACC'
        FP.AZ.ACT.SUB.ACC = ''
        CALL OPF(FV.AZ.ACT.SUB.ACC,FP.AZ.ACT.SUB.ACC)
        AZ.INSTALLED = 1
    END
*
    PD.INSTALLED = 0
    LOCATE 'PD' IN R.COMPANY(EB.COM.APPLICATIONS)<1,1> SETTING PD.INSTALLED THEN
        FV.PD.PAY.DUE = 'F.PD.PAYMENT.DUE'
        FP.PD.PAY.DUE = ''
        CALL OPF(FV.PD.PAY.DUE,FP.PD.PAY.DUE)
        PD.INSTALLED = 1
    END
*
    F.CARD.CHARGE='' ; FN.CARD.CHARGE = "F.CARD.CHARGE"
    CALL OPF(FN.CARD.CHARGE,F.CARD.CHARGE)

    ER=''

RETURN
*--------------------------------------
************
PROCESS.PARA:
************
    GOSUB PERFORM.CHARGE.ACCOUNTING

    IF TEXT EQ 'NO' THEN
        V$ERROR=1
        MESSAGE = "ERROR"
        RETURN
    END

    IF R.NEW(CARD.IS.NEW.REPAY.DATE)[1,8] LT R.NEW(CARD.IS.REPAY.DATE)[1,8] THEN
        R.NEW(CARD.IS.LST.REPAY.DATE) = R.NEW(CARD.IS.NEW.REPAY.DATE)[1,8]
        R.NEW(CARD.IS.NEW.REPAY.DATE) = ''
    END

    IF R.NEW(CARD.IS.NEW.BILLING.CLOSE) NE '' AND R.NEW(CARD.IS.NEW.BILLING.CLOSE)[1,8] LT R.NEW(CARD.IS.BILLING.CLOSE)[1,8] THEN
        CARD.ISS = RAISE(R.NEW(CARD.IS.ACCOUNT))
* LOOP
*     REMOVE ACC.ID FROM CARD.ISS SETTING POS
* UNTIL ACC.ID EQ ''
*     READ.WRITE = 'DELETE.SINGLE'
*     CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.BILLING.CLOSE)[1,8],"CARD.BILL.CLOSE.DATE",READ.WRITE,ACC.ID,'')
*     READ.WRITE = 'WRITE'
*     CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.NEW.BILLING.CLOSE)[1,8],"CARD.BILL.CLOSE.DATE",READ.WRITE,ACC.ID,'')
* REPEAT
        R.NEW(CARD.IS.BILLING.CLOSE)[1,8] = R.NEW(CARD.IS.NEW.BILLING.CLOSE)[1,8]

        R.NEW(CARD.IS.LST.BILLING.CLOSE) = R.NEW(CARD.IS.NEW.BILLING.CLOSE)[1,8]
        R.NEW(CARD.IS.NEW.BILLING.CLOSE) = ''

    END
    GOSUB STOCK.UPDATION
RETURN
***************************************************************************
*



*---------------------------------------------------------------------------
STOCK.UPDATION:
*****************
* For the updation of stock.register whne the stock.reg.id is not null
    IF V$FUNCTION EQ 'I' THEN
        IF R.NEW(CARD.IS.CARD.STATUS) EQ R.OLD(CARD.IS.CARD.STATUS) THEN
            UPD.DONE = 1
        END ELSE
            UPD.DONE = 0
        END

        IF R.OLD(CARD.IS.CARD.STATUS) EQ '' AND R.NEW(CARD.IS.CARD.STATUS) EQ '91' THEN
            UPD.DONE = 0
        END
    END ELSE
        UPD.DONE = 0
    END
    GOSUB UPD.DONE.LOOP
RETURN
*----------------------------------------------------------------------------------
UPD.DONE.LOOP:
****************
* UPD.DONE is used to ensure that the stock.register is updated only once (i.e) an authorised CARD.ISSUE with a change in cancellation date or
* charges should not update the stock.register. Updation should take place only when the status change

* PACS00024249 -S

*    IF NOT(UPD.DONE) THEN
*        GOSUB PROC.STOCK.REG  ;*Newly added
*   END

*PACS00024249 -E


    IF V$FUNCTION EQ 'R' THEN
* GOSUB PROCESS.REV     ;*Newly added
    END
    IF V$FUNCTION EQ 'I' AND R.OLD(CARD.IS.CARD.STATUS) NE '' THEN
        GOSUB PROC.INPUT.STATUS   ;*Newly added
    END
*
RETURN

*------------CHARGES-------------------------------------------------------
PERFORM.CHARGE.ACCOUNTING:
**************************
    IF ID.OLD NE '' THEN
        RETURN
    END

    IF V$FUNCTION EQ 'D' OR V$FUNCTION EQ 'R' THEN
        RETURN
    END

    IF CHARGES THEN
        YR.MULTI.STMT=''
        CALL CARD.ISSUE.CHARGES(ACCOUNT.ID,ACCOUNT,CARD.CHARGE,CHARGES,CHARGE.DATE,YR.MULTI.STMT,LCY.AMT)
        IF R.NEW.LAST(CARD.IS.RECORD.STATUS)[2,2] EQ 'NA' AND R.NEW(CARD.IS.STMT.NO) EQ 'VAL' THEN
            VAL.CHG='CHG'
        END ELSE
            VAL.CHG='VAL'
        END
        CALL EB.ACCOUNTING('CC',VAL.CHG,YR.MULTI.STMT,'')
        RETURN
    END

    IF R.NEW(CARD.IS.STMT.NO) EQ 'VAL' THEN
        R.NEW(CARD.IS.STMT.NO)=''
        CALL EB.ACCOUNTING('CC','DEL','','')
    END

RETURN
**
*
REPAY.DEL:
*********
    DEL.FLG = ''
    CARD.ISS = RAISE(R.NEW(CARD.IS.ACCOUNT))
    LOOP
        REMOVE ACC.ID FROM CARD.ISS SETTING POS
    UNTIL ACC.ID EQ ''
        CALL F.READ(FV.CRD.ISS.AC,ACC.ID,CRD.ISS.AC.REC,FP.CRD.ISS.AC,ERR34)
        IF CRD.ISS.AC.REC<2> EQ '' THEN     ;* Only if more than one card issues to the same account
            READ.WRITE = 'DELETE.SINGLE'
            CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.REPAY.DATE)[1,8],"CARD.REPAYMENT.DATE",READ.WRITE,ACC.ID,'')
*    CONTINUE
        END

        GOSUB REPAY.LOOP.REPEAT   ;* newly added
        IF DEL.FLG EQ 'Y' THEN
*
            READ.WRITE = 'DELETE.SINGLE'
            CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.REPAY.DATE)[1,8],"CARD.REPAYMENT.DATE",READ.WRITE,ACC.ID,'')
        END
*
    REPEAT
RETURN
*---------------------------------------------------------------------------------------------------------------------
BILLING.DEL:
**************
    DEL.FLG = ''
    CARD.ISS = RAISE(R.NEW(CARD.IS.ACCOUNT))
*
    LOOP
        REMOVE ACC.ID FROM CARD.ISS SETTING POS
    UNTIL ACC.ID EQ ''
        CALL F.READ(FV.CRD.ISS.AC,ACC.ID,CRD.ISS.AC.REC,FP.CRD.ISS.AC,ERR34)
        IF CRD.ISS.AC.REC<2> EQ '' THEN     ;* Only if more than one card issues to the same account
            READ.WRITE = 'DELETE.SINGLE'
            CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.BILLING.CLOSE)[1,8],"CARD.BILL.CLOSE.DATE",READ.WRITE,ACC.ID,'')
*            CONTINUE
        END
        GOSUB PROC.LOOP.REPEAT    ;*newly added
        IF DEL.FLG EQ 'Y' THEN
            READ.WRITE = 'DELETE.SINGLE'
            CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.BILLING.CLOSE)[1,8],"CARD.BILL.CLOSE.DATE",READ.WRITE,ACC.ID,'')
        END

    REPEAT
*
RETURN
*----------------------------------------
************
PROCESS.REV:
************
    CARD.ISS = RAISE(R.NEW(CARD.IS.ACCOUNT))
    U.DEL.CARD.REPAY = 1
    U.DEL.BILL.CLOSE = 1
*  CRD.RPY.FLAG = 0
    LOOP
        REMOVE ACC.ID FROM CARD.ISS SETTING POS
    UNTIL ACC.ID EQ ''
        CALL F.READ(FV.CRD.ISS.AC,ACC.ID,CRD.ISS.AC.REC,FP.CRD.ISS.AC,ERR34)
        IF CRD.ISS.AC.REC<2>  THEN          ;* Only if more than one card issues to the same account
            READ.WRITE = 'DELETE.SINGLE'
            CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.REPAY.DATE)[1,8],"CARD.REPAYMENT.DATE",READ.WRITE,ACC.ID,'')
            READ.WRITE = 'DELETE.SINGLE'
            CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.BILLING.CLOSE)[1,8],"CARD.BILL.CLOSE.DATE",READ.WRITE,ACC.ID,'') ;**CI_10014349 E
*            CONTINUE
        END
        GOSUB PROCESS.REV.LOOP
*
        IF U.DEL.CARD.REPAY THEN
            READ.WRITE = 'DELETE.SINGLE'
            CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.REPAY.DATE)[1,8],"CARD.REPAYMENT.DATE",READ.WRITE,ACC.ID,'')
        END
*
        IF U.DEL.BILL.CLOSE THEN
            READ.WRITE = 'DELETE.SINGLE'
            CALL EB.READ.WRITE.TABLE(R.NEW(CARD.IS.BILLING.CLOSE)[1,8],"CARD.BILL.CLOSE.DATE",READ.WRITE,ACC.ID,'')
        END

    REPEAT
RETURN
*------------------------------------------------------------------------------------------------------------
***************
PROC.STOCK.REG:
***************
    IF NOT(R.NEW(CARD.IS.STOCK.REG.ID)) THEN
        RETURN
    END

    STO.REG.REC = ''

    CALL F.READ(FV.STO.REG,R.NEW(CARD.IS.STOCK.REG.ID),R.STOCK.REGISTER,FP.STO.REG,ERR131)

*STBP20081212 -S---> Updation of STOCK.REGISTER was commented initially because during CARD.ISSUE this update happens
* For a single CARD, updation in STOCK.REGISTER should happen only once. Due to few issues, the updation has been made at
* local table level.The Stock maintainence related values are passed to local fields in CARD.ISSUE to avoid double updation of STOCK.REGISTER

    STOCK.SERIES = R.NEW(CARD.IS.STOCK.SERIERS.ID)

    SERIES.REG = R.STOCK.REGISTER<STO.REG.SERIES.ID>
    CHANGE @VM TO @FM IN SERIES.REG
    STOCK.SERIES = "*":STOCK.SERIES:"*"
    LOCATE STOCK.SERIES IN SERIES.REG SETTING POS THEN
        SERIES.NO.POS = 1
        STOCK.SERIES.NO = R.STOCK.REGISTER<STO.REG.SERIES.NO,POS,SERIES.NO.POS>
        SERIES.BAL = R.STOCK.REGISTER<STO.REG.SERIES.BAL,POS>
    END
    STK.REG.BAL = R.STOCK.REGISTER<STO.REG.STO.REG.BAL>

    LOWER.RANGE = FIELD(STOCK.SERIES.NO,"-",1)
    UPPER.RANGE = FIELD(STOCK.SERIES.NO,"-",2)
    NEW.LOWER.RANGE = LOWER.RANGE + 1
    UPDATE.RANGE = NEW.LOWER.RANGE:'-':UPPER.RANGE

    R.STOCK.REGISTER<STO.REG.SERIES.NO,POS,SERIES.NO.POS> = UPDATE.RANGE
    R.STOCK.REGISTER<STO.REG.SERIES.BAL,POS> = SERIES.BAL - 1
    R.STOCK.REGISTER<STO.REG.STO.REG.BAL> = STK.REG.BAL - 1


*STBP20081212 -E
    IF ETEXT THEN
        AF = CARD.IS.CARD.START.NO
        CALL STORE.END.ERROR
    END

RETURN
*----------------------------------
****************
PROC.INPUT.STATUS:
*****************
    U.CARD.VALID = 1
    IF R.NEW(CARD.IS.EXPIRY.DATE) LE R.NEW(CARD.IS.REPAY.DATE) THEN
        ACC.TO.CHK = RAISE(R.NEW(CARD.IS.ACCOUNT))
        CALL CHECK.FOR.AZ.AND.PD(U.CARD.VALID,ACC.TO.CHK)       ;* Check if it is linked to AZ and a PD exists for it
        IF U.CARD.VALID THEN
*GOSUB REPAY.DEL
        END
    END ELSE
        IF R.NEW(CARD.IS.CANCELLATION.DATE) AND R.NEW(CARD.IS.CANCELLATION.DATE) LE R.NEW(CARD.IS.REPAY.DATE) THEN
            ACC.TO.CHK = RAISE(R.NEW(CARD.IS.ACCOUNT))
            CALL CHECK.FOR.AZ.AND.PD(U.CARD.VALID,ACC.TO.CHK)     ;* Check if it is linked to AZ and a PD exists for it
            IF U.CARD.VALID THEN
*GOSUB REPAY.DEL
            END
        END
    END
*
    GOSUB PROC.INPUT.STATUS.LOOP
RETURN
*--------------------
PROC.INPUT.STATUS.LOOP:
*************************
    IF R.NEW(CARD.IS.EXPIRY.DATE) LE R.NEW(CARD.IS.BILLING.CLOSE) THEN
        ACC.TO.CHK = RAISE(R.NEW(CARD.IS.ACCOUNT))
*CALL CHECK.FOR.AZ.AND.PD(U.CARD.VALID,ACC.TO.CHK)   ;* Check if it is linked to AZ and a PD exists for it
        IF U.CARD.VALID THEN
* GOSUB BILLING.DEL
        END
        RETURN
    END

    IF R.NEW(CARD.IS.CANCELLATION.DATE) AND  R.NEW(CARD.IS.CANCELLATION.DATE) LE R.NEW(CARD.IS.BILLING.CLOSE) THEN
        ACC.TO.CHK = RAISE(R.NEW(CARD.IS.ACCOUNT))
*CALL CHECK.FOR.AZ.AND.PD(U.CARD.VALID,ACC.TO.CHK)   ;* Check if it is linked to AZ and a PD exists for it
        IF U.CARD.VALID THEN
* GOSUB BILLING.DEL
        END
    END

RETURN
****************
PROC.LOOP.REPEAT:
***************
    LOOP
        REMOVE CRD.ID FROM CRD.ISS.AC.REC SETTING POS
    UNTIL CRD.ID EQ '' OR DEL.FLG = 'N'
        IF ID.NEW EQ CRD.ID THEN
*            CONTINUE
        END
        CALL F.READ(FV.CRD.ISS,CRD.ID,CRD.ISS.REC,FP.CRD.ISS,ERR)
*
        GOSUB PROC.LOOP.REPEAT.PROCESS
        DEL.FLG = ''

    REPEAT
RETURN
*************************
PROC.LOOP.REPEAT.PROCESS:
*************************
    IF CRD.ISS.REC<CARD.IS.EXPIRY.DATE> LE CRD.ISS.REC<CARD.IS.BILLING.CLOSE> THEN
        DEL.FLG = 'Y'   ;* CONDITION STATISFIES FOR DELETE
    END ELSE
        IF CRD.ISS.REC<CARD.IS.CANCELLATION.DATE> THEN
            IF CRD.ISS.REC<CARD.IS.CANCELLATION.DATE> LE CRD.ISS.REC<CARD.IS.BILLING.CLOSE> THEN
                DEL.FLG = 'Y'         ;* CONDITION SATISIFIES FOR DELETE
            END ELSE
                DEL.FLG = 'N'         ;* DONOT DELETE FRM CONCAT FILE
            END
        END ELSE
            DEL.FLG = 'N' ;* DONOT DELETE FRM CONCAT FILE
        END
    END

RETURN
*--------------------------
****************
REPAY.LOOP.REPEAT:
*****************
    LOOP
        REMOVE CRD.ID FROM CRD.ISS.AC.REC SETTING POS
    UNTIL CRD.ID EQ '' OR DEL.FLG = 'N'
        IF ID.NEW EQ CRD.ID THEN
*            CONTINUE
        END

        CALL F.READ(FV.CRD.ISS,CRD.ID,CRD.ISS.REC,FP.CRD.ISS,ERR)
*
        DEL.FLG = ''
        GOSUB DEL.LOOP

    REPEAT
RETURN
*--------------------------------
***************
DEL.LOOP:
***************
    IF CRD.ISS.REC<CARD.IS.EXPIRY.DATE> LE CRD.ISS.REC<CARD.IS.REPAY.DATE> THEN
        DEL.FLG = 'Y'   ;* CONDITION STATISFIES FOR DELETE
    END ELSE
        IF CRD.ISS.REC<CARD.IS.CANCELLATION.DATE> THEN
            IF CRD.ISS.REC<CARD.IS.CANCELLATION.DATE> LE CRD.ISS.REC<CARD.IS.REPAY.DATE> THEN
                DEL.FLG = 'Y'         ;* CONDITION SATISIFIES FOR DELETE
            END ELSE
                DEL.FLG = 'N'         ;* DONOT DELETE FRM CONCAT FILE
            END
        END ELSE
            DEL.FLG = 'N' ;* DONOT DELETE FRM CONCAT FILE
        END
    END

RETURN
***************
PROCESS.REV.LOOP:
****************
    LOOP
        REMOVE CRD.ID FROM CRD.ISS.AC.REC SETTING POS
    UNTIL CRD.ID EQ ''
        IF ID.NEW EQ CRD.ID THEN
*            CONTINUE
        END
        CALL F.READ(FV.CRD.ISS,CRD.ID,CRD.ISS.REC,FP.CRD.ISS,ERR)
        IF R.NEW(CARD.IS.REPAY.DATE) EQ CRD.ISS.REC<CARD.IS.REPAY.DATE> AND U.DEL.CARD.REPAY THEN
            U.DEL.CARD.REPAY = 0
        END
        IF R.NEW(CARD.IS.BILLING.CLOSE) EQ CRD.ISS.REC<CARD.IS.REPAY.DATE> AND U.DEL.BILL.CLOSE THEN
            U.DEL.BILL.CLOSE = 0
*GOTO NO.DEL
        END
    REPEAT
RETURN
*--------------------------------
END
