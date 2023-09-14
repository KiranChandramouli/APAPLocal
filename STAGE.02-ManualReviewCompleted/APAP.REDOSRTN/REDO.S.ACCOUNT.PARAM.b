* @ValidationCode : MjotMTgwODQ1MTYyMzpDcDEyNTI6MTY4MDc2OTg4MDU4NDo5MTYzODotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:01:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE  REDO.S.ACCOUNT.PARAM(APPL.TYPE,OPERATION.TYPE,STMT.ENT.ID,STMT.RECORD)
*---------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to call REDO.S.PENDING.CHARGES if the category is in range specified
* If any routine is needed to be attached with ACCOUNTING.SUBRTN field of ACCOUNTING.PARAMETER,
* this routine can be used

* Input/Output:
*--------------
* IN : APPL.TYPE, OPERATION.TYPE, STMT.ENT.ID, STMT.RECORD
* OUT : APPL.TYPE, OPERATION.TYPE, STMT.ENT.ID, STMT.RECORD
*
* Dependencies:
*---------------
* CALLS : REDO.S.PENDING.CHARGES
* CALLED BY : -NA-
*
* Revision History:
*---------------------------------------------------------------------------
*   Date               who           Reference               Description
* 10-JAN-2010     SHANKAR RAJU     ODR-2009-10-0529         Initial Creation
* 26-NOV-2010     SHIVA PRASAD Y   ODR-2010-11-0196-CR12    Added GOSUB UPD.ACCOUNT to update local field - ACCOUNT
* 08-09-2011      PRABHU           PACS00125978             MODIFICATION
* 15-03-2012      Prabhu           PACS00182833             CALL rouitne to NCF added
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     FM TO @FM,VM TO @VM
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

*---------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.REDO.CHARGE.PARAM
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
*---------------------------------------------------------------------------


*--ODR-2010-11-0196-CR12 - Start ---
    GOSUB UPD.ACCOUNT
*--ODR-2010-11-0196-CR12 - End  ----
    GOSUB PENDING.CHARGE
*
    GOSUB OPEN.STMT.FT.FILES
    GOSUB WRITE.CONCAT.STO.FILES
    GOSUB GENERATE.NCF.UNMAP
RETURN
*---------------------------------------------------------------------------
*--ODR-2010-11-0196-CR12 - Start ---
************
UPD.ACCOUNT:
************

    CALL REDO.APAP.S.AC.AV.BAL.UPDATE(APPL.TYPE,OPERATION.TYPE,STMT.ENT.ID,STMT.RECORD)

RETURN
*--------------------------------------------------------------------------------------------------------
*--ODR-2010-11-0196-CR12 - End  ----
PENDING.CHARGE:
*~~~~~~~~~~~~~
*To Check if the range falls under Specified category

    FN.CHARGE.PARAM = 'F.REDO.CHARGE.PARAM'
    F.CHARGE.PARAM = ''

    CALL OPF(FN.CHARGE.PARAM,F.CHARGE.PARAM)

    IN.ACCT.CATEG = FIELD(STMT.RECORD,@FM,10)
    R.CHARGE.PARAM = '' ; CHG.ERR = ''

    CALL CACHE.READ(FN.CHARGE.PARAM,"SYSTEM",R.CHARGE.PARAM,CHG.ERR)

    RCP.CATEG.STR = R.CHARGE.PARAM<CHG.PARAM.ACCT.CATEG.STR>
    RCP.CATEG.END = R.CHARGE.PARAM<CHG.PARAM.ACCT.CATEG.END>

    NO.OF.STRT.CATEG=DCOUNT(RCP.CATEG.STR,@VM)
    COUNT.CAT = 1
    LOOP
    WHILE COUNT.CAT LE NO.OF.STRT.CATEG

        IF IN.ACCT.CATEG GE RCP.CATEG.STR<1,COUNT.CAT> AND IN.ACCT.CATEG LE RCP.CATEG.END<1,COUNT.CAT> THEN
            CALL REDO.S.PENDING.CHARGES(APPL.TYPE,OPERATION.TYPE,STMT.ENT.ID,STMT.RECORD,NCF.NT.REQ)
        END
        COUNT.CAT += 1
    REPEAT
RETURN
*---------------------------------------------------------------------------
*--------------------------------------------------------------------------
OPEN.STMT.FT.FILES:
*-------------------------------------------------------------------------
    FN.FT='F.FUNDS.TRANSFER'
    F.FT=''
    CALL OPF(FN.FT,F.FT)

    FN.STMT='F.STMT.ENTRY'
    F.STMT=''
    CALL OPF(FN.STMT,F.STMT)

    FN.REDO.STO='F.REDO.STO.STORE.LASTFIVE'
    F.REDO.STO=''
    CALL OPF(FN.REDO.STO,F.REDO.STO)

*!
    FN.AI.ARCIB.PARAM = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.ARCIB.PARAM = ''
    CALL OPF(FN.AI.ARCIB.PARAM,F.AI.ARCIB.PARAM)

    ARCIB.ID = 'SYSTEM'
    CALL CACHE.READ(FN.AI.ARCIB.PARAM,ARCIB.ID,R.ARCIB.PARAM,ARC.ERR)
*!
    MAX.CNT=20
    LIMIT.CNT=10
    STO.CNT=''
RETURN

*-------------------------------------------------------------------
WRITE.CONCAT.STO.FILES:
*------------------------------------------------------------------
*PACS00125978-S
    WORK.FILE.ID = ''

    GOSUB CHECK.TRANSFER.FLAG
    GOSUB CHECK.PAYMENT.FLAG

    SYS.ID=STMT.RECORD<AC.STE.SYSTEM.ID>
    STMT.ACC.NO=STMT.RECORD<AC.STE.ACCOUNT.NUMBER>

    CONTRACT.ID=STMT.RECORD<AC.STE.TRANS.REFERENCE>
    IF SYS.ID EQ 'FT' THEN
        FT.STO.ID=FIELD(R.NEW(FT.INWARD.PAY.TYPE),'-',1)
        FT.ACCT.NO = FIELD(R.NEW(FT.INWARD.PAY.TYPE),'-',3)

        FT.DEBIT.CUST=R.NEW(FT.DEBIT.CUSTOMER)
        IF (FT.STO.ID EQ 'STO' ) AND (STMT.ACC.NO EQ FT.ACCT.NO ) THEN

            BEGIN CASE
                CASE R.NEW(FT.TRANSACTION.TYPE) MATCHES TRANSFER.CODE
                    WORK.FILE.ID = FT.DEBIT.CUST:"-":"T"
                CASE R.NEW(FT.TRANSACTION.TYPE) MATCHES PAYMENT.CODE
                    WORK.FILE.ID = FT.DEBIT.CUST:"-":"P"
            END CASE
            CALL F.READ(FN.REDO.STO,WORK.FILE.ID,R.REDO.STO.REC,F.REDO.STO,ERR)
            CNT.STOS=DCOUNT(R.REDO.STO.REC,@FM)
            IF CNT.STOS EQ  MAX.CNT THEN
                LOOP
                WHILE LIMIT.CNT LE CNT.STOS
                    DEL R.REDO.STO.REC<CNT.STOS>
                    CNT.STOS-=1
                REPEAT
            END
            INS STMT.ENT.ID BEFORE R.REDO.STO.REC<1>
*!
            PR.TEST = R.NEW(FT.TRANSACTION.TYPE)
*            PRINT PR.TEST
*!
            IF R.REDO.STO.REC THEN
                CALL F.WRITE(FN.REDO.STO,WORK.FILE.ID,R.REDO.STO.REC)
            END

        END
    END
RETURN

********************
CHECK.TRANSFER.FLAG:
********************
    TRANSFER.CODE = ''
    TRANSFER.FLG = ''
    IF APPLICATION EQ 'FUNDS.TRANSFER' AND RUNNING.UNDER.BATCH THEN
        AI.PARAM.PROD =R.ARCIB.PARAM<AI.PARAM.PRODUCT>
        AI.PARAM.TYPE=R.ARCIB.PARAM<AI.PARAM.TRANSACTION.TYPE>

        LOCATE 'STANDING.ORDER' IN AI.PARAM.PROD<1,1> SETTING AI.PARAM.PROD.POS THEN
            LOCATE 'OWN-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
                TRANSFER.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>

            END
            LOCATE 'APAP-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
                TRANSFER.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
            END

            LOCATE 'THIRD-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
                TRANSFER.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
            END

        END

    END

RETURN

*******************
CHECK.PAYMENT.FLAG:
******************
    PAYMENT.CODE = ''
    PAYMENT.FLG = ''
    IF APPLICATION EQ 'FUNDS.TRANSFER' AND RUNNING.UNDER.BATCH THEN
        AI.PARAM.PROD =R.ARCIB.PARAM<AI.PARAM.PRODUCT>
        AI.PARAM.TYPE=R.ARCIB.PARAM<AI.PARAM.TRANSACTION.TYPE>

        LOCATE 'STANDING.ORDER' IN AI.PARAM.PROD<1,1> SETTING AI.PARAM.PROD.POS THEN
            LOCATE 'OWN-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
                PAYMENT.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
            END
            LOCATE 'APAP-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
                PAYMENT.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
            END
            LOCATE 'THIRD-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
                PAYMENT.CODE<1,-1> = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
            END

        END

    END


RETURN
*PACS00125978-E  ;*R22 Auto code Conversion
*------------------
GENERATE.NCF.UNMAP:
*------------------
    IF ((R.DATES(EB.DAT.CO.BATCH.STATUS) EQ 'B' AND APPL.TYPE EQ 'STMT') OR (APPL.TYPE EQ 'STMT' AND STMT.RECORD<AC.STE.TRANSACTION.CODE> EQ R.CHARGE.PARAM<CHG.PARAM.DR.TXN.CODE>)) THEN
        IF NCF.NT.REQ NE 'YES' THEN
            CALL REDO.AP.GEN.NCF.UNMAP(STMT.ENT.ID,STMT.RECORD)
        END
        NCF.NT.REQ = ''
    END
RETURN
END
