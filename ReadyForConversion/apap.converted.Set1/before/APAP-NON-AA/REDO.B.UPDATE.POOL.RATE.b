*-----------------------------------------------------------------------------
* <Rating>-200</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.UPDATE.POOL.RATE(ACC.ID)
*----------------------------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is attached to the batch job REDO.B.UPDATE.POOL.RATE which updates the local reference field TASA.POOL
*   based on the value in the local table POOL.RATE and other related local reference fields in ACCOUNT and AZ.ACCOUNT
* ---------------------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
*
* 03-MAY-2010  N.Satheesh Kumar   ODR-2009-10-0325       Initial Creation
* 19-DEC-2010  JEEVA T             PACS00171685          COB PERFORMANCE
* 20-DEC-2011  Pradeep S          PACS00171685           Logic changed to improve performance
* 26-DEC-2011  H GANESH           PACS00164151 - B.16    Change logic for Pool rate.
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.GROUP.CREDIT.INT
    $INSERT I_F.GROUP.DATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.REDO.POOL.RATE
    $INSERT I_REDO.B.UPDATE.POOL.RATE.COMMON
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End

    IF CONTROL.LIST<1,1> EQ 'ACCOUNT' THEN
        GOSUB UPDATE.ACC
    END ELSE
        GOSUB UPDATE.AZ.ACC
    END
    RETURN

*----------
UPDATE.ACC:
*----------
*----------------------------------------------------------------------------------------------------------
* This section updates the local reference field TASA.POOL  based on the value in the local table POOL.RATE
*   and other related local reference fields in ACCOUNT application
* ---------------------------------------------------------------------------------------------------------
    SLAB.INT.RATE.FLAG = ''
    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)        ;*Tus Start
    R.ECB='' ; ECB.ERR=''
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",ACC.ID,R.ECB,ECB.ERR)     ;*Tus End
    Y.EB.REVIEW = R.ACCOUNT<AC.LOCAL.REF,ACC.REVIEW.POS>
    IF R.ACCOUNT AND Y.EB.REVIEW EQ 'YES' THEN
        R.ACCOUNT.BKP = ''
        R.ACCOUNT.BKP=R.ACCOUNT
        ACC.CUR = R.ACCOUNT<AC.CURRENCY>
        ACC.CATEG = R.ACCOUNT<AC.CATEGORY>
        ACC.COND = R.ACCOUNT<AC.CONDITION.GROUP>
* ACC.BAL  =  R.ACCOUNT<AC.WORKING.BALANCE> ;*Tus Start
        ACC.BAL  = R.ECB<ECB.WORKING.BALANCE>     ;*Tus End
        Y.ACCT.CAP.DATE = R.ACCOUNT<AC.CAP.DATE.CR.INT,1>
        ACC.POOL.RATE = R.ACCOUNT<AC.LOCAL.REF,ACC.TASA.POOL.POS>
        ACI.DATE.CNT = DCOUNT(R.ACCOUNT<AC.ACCT.CREDIT.INT>,VM)
        ACI.DATE =R.ACCOUNT<AC.ACCT.CREDIT.INT,ACI.DATE.CNT>
        GOSUB READ.GROUP.DATE
        GOSUB PROCESS.ACC.POOL.RATE
    END
    RETURN

*---------------
READ.GROUP.DATE:
*---------------
* New Section - PACS00171685

    Y.GD.ID = ACC.COND:ACC.CUR
    R.GROUP.DATE = ''
    CALL F.READ(FN.GROUP.DATE,Y.GD.ID,R.GROUP.DATE,F.GROUP.DATE,ERR.GD)
    GCI.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>
    RETURN          ;* Return READ.GROUP.DATE

*---------------------
PROCESS.ACC.POOL.RATE:
*---------------------
* New Section - PACS00171685

    R.REDO.POOL.RATE = ''
    CALL F.READ(FN.REDO.POOL.RATE,ACC.CUR,R.REDO.POOL.RATE,F.REDO.POOL.RATE,ERR.RPR)
    IF R.REDO.POOL.RATE THEN
        BUY.RATE = R.REDO.POOL.RATE<PL.RATE.INDEF.LIAB.RATE>
        IF BUY.RATE NE ACC.POOL.RATE THEN
            R.ACCOUNT<AC.LOCAL.REF,ACC.OLD.RATE.POS,-1>=ACC.POOL.RATE
            R.ACCOUNT<AC.LOCAL.REF,ACC.TASA.POOL.POS> = BUY.RATE
            GOSUB PROCESS.INTEREST
            R.ACCOUNT<AC.LOCAL.REF,ACC.PROFITLOSS.POS> = BUY.RATE - ACC.INT.RATE
            GOSUB WRITE.ACCOUNT
        END ELSE
            GOSUB CHECK.DIFF.NEXT.WORK.DAY
            VAR.DATE = VAR.TODAY.DATE
            GOSUB PROCESS.CHECK.ACI.GCI
            CNT  = 1
            LOOP
            WHILE CNT LT Y.DIFF.DAYS
                VAR.DATE = VAR.TODAY.DATE
                NO.OF.DAYS = "+":CNT:"C"
                CALL CDT('',VAR.DATE,NO.OF.DAYS)
                GOSUB PROCESS.CHECK.ACI.GCI
                CNT++
            REPEAT
        END
    END

    IF NOT(SLAB.INT.RATE.FLAG) THEN
        GOSUB PROCESS.INTEREST
        R.ACCOUNT<AC.LOCAL.REF,ACC.PROFITLOSS.POS> = BUY.RATE - ACC.INT.RATE
        GOSUB WRITE.ACCOUNT
    END

    RETURN
*--------------------------
CHECK.DIFF.NEXT.WORK.DAY:
*--------------------------

    VAR.NEXT.DATES = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    VAR.TODAY.DATE = TODAY
    Y.REGION = ''
    Y.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,VAR.TODAY.DATE,VAR.NEXT.DATES,Y.DIFF.DAYS)

    RETURN
*-------------------------
PROCESS.CHECK.ACI.GCI:
*-------------------------

    Y.ACI.CONCAT.ID = "ACI-":VAR.DATE
    CALL F.READ(FN.REDO.W.UPD.REVIEW.ACCT,Y.ACI.CONCAT.ID,R.REDO.W.UPD.REVIEW.ACCT,F.REDO.W.UPD.REVIEW.ACCT,Y.ERR)
    Y.ACI.ID = ACC.ID:"-":VAR.DATE
    LOCATE Y.ACI.ID IN R.REDO.W.UPD.REVIEW.ACCT SETTING POS.ACI THEN
        CALL F.READ(FN.ACCOUNT.CREDIT.INT,Y.ACI.ID,R.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT,CGI.ERR)
        GOSUB PROCESS.ACI
        R.ACCOUNT<AC.LOCAL.REF,ACC.PROFITLOSS.POS> = BUY.RATE - ACC.INT.RATE
        GOSUB WRITE.ACCOUNT
    END ELSE
        Y.GCI.CONCAT.ID = "GCI-":ACC.CUR:"-":VAR.DATE
        CALL F.READ(FN.REDO.W.UPD.REVIEW.ACCT,Y.GCI.CONCAT.ID,R.REDO.W.UPD.REVIEW.ACCT,F.REDO.W.UPD.REVIEW.ACCT,Y.ERR)
        Y.GCI.ID = ACC.COND:ACC.CUR:VAR.DATE
        LOCATE Y.GCI.ID IN R.REDO.W.UPD.REVIEW.ACCT SETTING POS.ACI THEN
            R.GROUP.CREDIT.INT = ''
            CALL F.READ(FN.GROUP.CREDIT.INT,Y.GCI.ID,R.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT,CGI.ERR)
            GOSUB PROCESS.GCI
            R.ACCOUNT<AC.LOCAL.REF,ACC.PROFITLOSS.POS> = BUY.RATE - ACC.INT.RATE
            GOSUB WRITE.ACCOUNT
        END
    END

    RETURN
*----------------
PROCESS.INTEREST:
*----------------

    ACC.INT.RATE = ''
    Y.ACI.ID = ACC.ID:"-":ACI.DATE
    R.ACCOUNT.CREDIT.INT = ''
    CALL F.READ(FN.ACCOUNT.CREDIT.INT,Y.ACI.ID,R.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT,CGI.ERR)
    IF R.ACCOUNT.CREDIT.INT THEN
        GOSUB PROCESS.ACI
    END ELSE
        Y.GCI.ID = Y.GD.ID:GCI.DATE
        R.GROUP.CREDIT.INT = ''
        CALL F.READ(FN.GROUP.CREDIT.INT,Y.GCI.ID,R.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT,CGI.ERR)
        GOSUB PROCESS.GCI
    END

    RETURN

*-----------
PROCESS.GCI:
*-----------
*--------------------------------------------------------------------
* This section gets the required details from GROUP.CREDIT.INT record
*--------------------------------------------------------------------

    CI.LIM.AMT = R.GROUP.CREDIT.INT<IC.GCI.CR.LIMIT.AMT>
    INT.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE>
    BASIC.RATE.KEY = R.GROUP.CREDIT.INT<IC.GCI.CR.BASIC.RATE>
    GOSUB GET.INT.RATE
    RETURN

*-----------
PROCESS.ACI:
*-----------
*----------------------------------------------------------------------
* This section gets the required details from ACCOUNT.CREDIT.INT record
*----------------------------------------------------------------------

    CI.LIM.AMT = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.LIMIT.AMT>
    INT.RATE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.INT.RATE>
    BASIC.RATE.KEY = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.BASIC.RATE>
    GOSUB GET.INT.RATE
    RETURN

*------------
GET.INT.RATE:
*------------
*-----------------------------------------------------------------------------------------------------
* This section gets the interest rate based on the amount and assigns it to the common variable O.DATA
*-----------------------------------------------------------------------------------------------------
    INT.RATE.CNT = DCOUNT(INT.RATE,VM)
    IF INT.RATE.CNT EQ 1 THEN
        SLAB.INT.RATE.FLAG = '1'
        ACC.INT.RATE = INT.RATE
        RETURN
    END
    BASIC.RATE.CNT = DCOUNT(BASIC.RATE.KEY,VM)
    IF BASIC.RATE.CNT EQ 1 THEN
        SLAB.INT.RATE.FLAG = '1'
        BASIC.RATE.KEY := ACC.CUR:TODAY
        BASIC.RATE = ''
        CALL EB.GET.INTEREST.RATE(BASIC.RATE.KEY,BASIC.RATE)
        ACC.INT.RATE = BASIC.RATE
        RETURN
    END
*LIM.AMT.CNT = 0
*LOOP
*++LIM.AMT.CNT
*REMOVE LIM.AMT FROM CI.LIM.AMT SETTING LIM.AMT.POS
*WHILE LIM.AMT:LIM.AMT.POS
*IF ACC.BAL LE LIM.AMT THEN
*   BREAK
*END
*REPEAT
*    VAR.LIM.AMT.FLAG = ''
*    CHANGE VM TO FM IN CI.LIM.AMT
*    CI.LIM.AMT.CNT = DCOUNT(CI.LIM.AMT,FM)
*    LIM.AMT.CNT = 1
*    LOOP
*    WHILE LIM.AMT.CNT LE CI.LIM.AMT.CNT
*        LIM.AMT = CI.LIM.AMT<LIM.AMT.CNT>
*        IF ACC.BAL LE LIM.AMT THEN
*            VAR.LIM.AMT.FLAG = LIM.AMT.CNT
*            LIM.AMT.CNT = CI.LIM.AMT.CNT + 1
*        END
*        LIM.AMT.CNT++
*    REPEAT
*    IF VAR.LIM.AMT.FLAG THEN
*        LIM.AMT.CNT = VAR.LIM.AMT.FLAG
*    END ELSE
*        LIM.AMT.CNT = LIM.AMT.CNT - 1
*    END
*    IF INT.RATE<1,LIM.AMT.CNT> EQ '' THEN
*        IBASIC.RATE.KEY = BASIC.RATE.KEY<1,LIM.AMT.CNT>
*        IBASIC.RATE.KEY := ACC.CUR:TODAY
*        BASIC.RATE = ''
*        CALL EB.GET.INTEREST.RATE(IBASIC.RATE.KEY,BASIC.RATE)
*        ACC.INT.RATE = BASIC.RATE
*    END ELSE
*        ACC.INT.RATE = INT.RATE<1,LIM.AMT.CNT>
*    END
* THE SLAB RATE IS CALCUALTED ONLY FOR CAPITALISATION DATE IS FALL INBETWEEN TODAY TO NEXT WORKING DAY
* OTHERWISE THE VALUE IS UPDATED AS ZERO FOR SLAB RATES
    IF Y.ACCT.CAP.DATE GE TODAY THEN

        GOSUB CHECK.DIFF.NEXT.WORK.DAY

        VAR.DATE = VAR.TODAY.DATE

        GOSUB CHECK.SLAB.INT.RATE

        IF NOT(SLAB.CNT) THEN
            GOSUB CHECK.SLAB.INT.RATE.HOLIDAY
        END

    END ELSE
        SLAB.INT.RATE.FLAG = '1'
        ACC.INT.RATE = '0.00'
    END

    RETURN
*---------------------------
CHECK.SLAB.INT.RATE.HOLIDAY:
*---------------------------
    SLAB.CNT  = 1
    LOOP
    WHILE SLAB.CNT LT Y.DIFF.DAYS
        VAR.DATE = VAR.TODAY.DATE
        NO.OF.DAYS = "+":SLAB.CNT:"C"
        CALL CDT('',VAR.DATE,NO.OF.DAYS)
        GOSUB CHECK.SLAB.INT.RATE
        SLAB.CNT++
    REPEAT

    RETURN
*-------------------
CHECK.SLAB.INT.RATE:
*-------------------
    IF Y.ACCT.CAP.DATE EQ VAR.DATE THEN
        SLAB.INT.RATE.FLAG = '1'
        R.STMT.ACCT.CR = ''
        Y.STMT.ACCT.CR.ID = ACC.ID:"-":Y.ACCT.CAP.DATE

        CALL F.READ(FN.STMT.ACCT.CR,Y.STMT.ACCT.CR.ID,R.STMT.ACCT.CR,F.STMT.ACCT.CR,CR.ERR)

        IF R.STMT.ACCT.CR THEN
            Y.CR.INT.RATE =  R.STMT.ACCT.CR<IC.STMCR.CR.INT.RATE>
            CHANGE VM TO FM IN Y.CR.INT.RATE
            ACC.INT.RATE = MAXIMUM(Y.CR.INT.RATE)
            SLAB.CNT = Y.DIFF.DAYS + 1
        END
    END
    RETURN
*-------------
WRITE.ACCOUNT:
*-------------
*New Section - PACS00171685

    IF R.ACCOUNT AND R.ACCOUNT.BKP NE R.ACCOUNT THEN
        V = AC.AUDIT.DATE.TIME
        CALL F.LIVE.WRITE(FN.ACCOUNT,ACC.ID,R.ACCOUNT)
    END

    RETURN

*-------------
UPDATE.AZ.ACC:
*-------------
*----------------------------------------------------------------------------------------------------------
* This section updates the local reference field TASA.POOL  based on the value in the local table POOL.RATE
*   and other related local reference fields in AZ.ACCOUNT application
* ---------------------------------------------------------------------------------------------------------

    CALL F.READ(FN.AZ.ACCOUNT,ACC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR)
    IF R.AZ.ACCOUNT<AZ.ROLLOVER.DATE> GT R.DATES(EB.DAT.LAST.WORKING.DAY) AND R.AZ.ACCOUNT<AZ.ROLLOVER.DATE> LE TODAY ELSE
        RETURN
    END
    AZ.PRODUCT = R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>
    LOCATE AZ.PRODUCT IN AZ.PROD.LST<1> SETTING AZ.PROD.POS ELSE
        GOSUB UPDATE.LOAN.OR.DEP
    END
    IF DEP.OR.LOAN.LST<AZ.PROD.POS> NE 'DEPOSIT' THEN
        RETURN
    END
    AZ.CUR = R.AZ.ACCOUNT<AZ.CURRENCY>
    AZ.CATEG = R.AZ.ACCOUNT<AZ.CATEGORY>
    AZ.INT.RATE = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
    GRACE.DAYS = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.GRACE.DAYS>
    VAR.END.DATE = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.GR.END.DAT>
    NO.OF.DAYS = '+':GRACE.DAYS:'W'
    VAR.MATURITY.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    IF GRACE.DAYS AND VAR.MATURITY.DATE THEN
        CALL CDT('',VAR.MATURITY.DATE,NO.OF.DAYS)
        Y.END.DATE = VAR.MATURITY.DATE
        R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.GR.END.DAT> = Y.END.DATE
    END
    GOSUB GET.INTEREST
    AZ.POOL.RATE = R.AZ.ACCOUNT<AZ.LOCAL.REF,AZ.TASA.POOL.POS>
    IF AZ.POOL.RATE NE BUY.RATE THEN
        R.AZ.ACCOUNT<AZ.LOCAL.REF,AZ.OLD.RATE.POS,-1>=AZ.POOL.RATE
        R.AZ.ACCOUNT<AZ.LOCAL.REF,AZ.TASA.POOL.POS> = BUY.RATE
        R.AZ.ACCOUNT<AZ.LOCAL.REF,AZ.PROFITLOSS.POS> = BUY.RATE-AZ.INT.RATE
    END
    IF (AZ.POOL.RATE NE BUY.RATE) OR (Y.END.DATE NE VAR.END.DATE) THEN
        GOSUB WRITE.AZ.ACCOUNT
    END
    RETURN

*------------------
UPDATE.LOAN.OR.DEP:
*------------------
*--------------------------------------------------------------------------------------------------------------
* This section checks whether the given product is Deposit or Loan in the local common variable DEP.OR.LOAN.LST
* -------------------------------------------------------------------------------------------------------------

    R.AZ.PRODUCT.PARAMETER = ''
    CALL F.READ(FN.AZ.PRODUCT.PARAMETER,AZ.PRODUCT,R.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER,PARA.ERR)
    AZ.PROD.LST<AZ.PROD.POS> = AZ.PRODUCT
    DEP.OR.LOAN.LST<AZ.PROD.POS> = R.AZ.PRODUCT.PARAMETER<AZ.APP.LOAN.DEPOSIT>
    RETURN

*----------------
WRITE.AZ.ACCOUNT:
*----------------
*New Section - PACS00171685

    IF R.AZ.ACCOUNT AND BUY.RATE THEN
        V = AZ.AUDITOR.CODE
        CALL F.LIVE.WRITE(FN.AZ.ACCOUNT,ACC.ID,R.AZ.ACCOUNT)
    END

    RETURN

*-------
GET.INTEREST:
*-------
    Y.AZ.VALUE.DATE=R.AZ.ACCOUNT<AZ.VALUE.DATE>
    Y.AZ.MATURITY.DATE=R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    Y.REGION = ''
    Y.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,Y.AZ.VALUE.DATE,Y.AZ.MATURITY.DATE,Y.DIFF.DAYS)
    Y.DIFF.DAYS = Y.DIFF.DAYS:'D'
    BUY.RATE = ''
    RATE = ''
    CALL REDO.GET.POOL.RATE(AZ.CUR,Y.DIFF.DAYS,RATE)
    BUY.RATE = RATE<2>

    RETURN
END
