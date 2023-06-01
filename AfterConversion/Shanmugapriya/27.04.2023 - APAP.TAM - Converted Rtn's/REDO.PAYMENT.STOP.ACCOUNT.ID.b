* @ValidationCode : MjotODI1MzAxMTI0OkNwMTI1MjoxNjgwODg4MzAxODExOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2023 22:55:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PAYMENT.STOP.ACCOUNT.ID

*********************************************************************************************************
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : Temenos Application Management
* Program   Name    : REDO.PAYMENT.STOP.ACCOUNT.ID
*--------------------------------------------------------------------------------------------------------
* Description       : This routine is used to increase the count based upon the user's input

* Linked With       :
* In  Parameter     : Y.FINAL.ARR
* Out Parameter     : Y.FINAL.ARR
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------             -----                 -----------                -----------
* 21-DEC-2010      JEYACHANDRAN S             HD1053407               Initial Creation
* 10.04.2023       Conversion Tool            R22                     Auto Conversion     - VM TO @VM, = Y.LAST.SEQ + TO +=
* 10.04.2023       Shanmugapriya M            R22                     Manual Conversion   - No changes
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT
    $INSERT I_F.REDO.PAY.STOP.SEQ
    GOSUB INIT
    GOSUB PROCESS
    GOSUB GOEND
    Y.LAST.SEQ = 0
RETURN
*---------
INIT:

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT.STOP.ACCOUNT  = ''
    FN.REDO.PAYMENT.STOP.ACCOUNT.HIS = 'F.REDO.PAYMENT.STOP.ACCOUNT$NAU'
    F.REDO.PAYMENT.STOP.ACCOUNT.HIS = ''
    Y.FINAL.LIST = '' ; Y.ID.1 = '' ; Y.SEQUENCE = 0

    FN.REDO.PAY.STOP.SEQ='F.REDO.PAY.STOP.SEQ'
    F.REDO.PAY.STOP.SEQ =''
    CALL OPF(FN.REDO.PAY.STOP.SEQ,F.REDO.PAY.STOP.SEQ)
RETURN

*----------
PROCESS:
*-----------
    IF NOT(OFS$HOT.FIELD) AND OFS$OPERATION EQ 'BUILD' ELSE
        RETURN
    END
    IF V$FUNCTION EQ 'I' THEN
        Y.CHECK.ID = FIELD(ID.NEW,'.',2)

        Y.CNT.ID  = DCOUNT(ID.NEW,'.')
        CALL F.READ(FN.REDO.PAYMENT.STOP.ACCOUNT,ID.NEW,R.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT,STOP.ER)
        CALL F.READ(FN.REDO.PAYMENT.STOP.ACCOUNT.HIS,ID.NEW,R.REDO.PAYMENT.STOP.ACCOUNT.HIS,F.REDO.PAYMENT.STOP.ACCOUNT.HIS,STOP.HIS.ERR)
        IF R.REDO.PAYMENT.STOP.ACCOUNT THEN
            RETURN
        END ELSE
            IF R.REDO.PAYMENT.STOP.ACCOUNT.HIS THEN
                RETURN
            END ELSE
                IF Y.CNT.ID GT 1 THEN
                    E = "Invalid Account Number"
                    RETURN
                END ELSE
                    GOSUB WRITE.PROCESS
                END
            END
        END
    END ELSE
        RETURN
    END

RETURN
*----------
WRITE.PROCESS:
*-----------
    Y.ID = FIELD(ID.NEW,".",1)
    Y.ID.1 = FIELD(ID.NEW,".",2)
    CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
    IF ACCOUNT.ER THEN
        E = 'TT-CHECK.ACCT'
        CALL ERR
        MESSAGE = 'REPEAT'
        RETURN
    END
    Y.ACC=ID.NEW
    CALL F.READU(FN.REDO.PAY.STOP.SEQ,Y.ACC,R.REDO.PAY.STOP.SEQ,F.REDO.PAY.STOP.SEQ,ERR,'')
    IF R.REDO.PAY.STOP.SEQ THEN
        Y.SEQUENCE = R.REDO.PAY.STOP.SEQ<PS.SE.PAY.ID.SEQ>
        Y.SEQ.COUNT = DCOUNT(Y.SEQUENCE,@VM)
        Y.LAST.SEQ = R.REDO.PAY.STOP.SEQ<PS.SE.PAY.ID.SEQ,Y.SEQ.COUNT>
        Y.CUR.ID = ID.NEW:'.':Y.LAST.SEQ
    END ELSE
        Y.LAST.SEQ += 1                    ;** R22 Auto conversion - = Y.LAST.SEQ + TO +=
        R.REDO.PAY.STOP.SEQ<PS.SE.PAY.ID.SEQ,-1> = Y.LAST.SEQ
        ID.NEW=ID.NEW:'.':Y.LAST.SEQ
*    WRITE R.REDO.PAY.STOP.SEQ TO F.REDO.PAY.STOP.SEQ,Y.ACC ;*Tus Start
        CALL F.WRITE(FN.REDO.PAY.STOP.SEQ,Y.ACC,R.REDO.PAY.STOP.SEQ) ; * Tus End
        IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
            CALL JOURNAL.UPDATE('')
        END

        CALL F.RELEASE(FN.REDO.PAY.STOP.SEQ,Y.ACC,F.REDO.PAY.STOP.SEQ)
        RETURN
    END
    CALL F.READ(FN.REDO.PAYMENT.STOP.ACCOUNT,Y.CUR.ID,R.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT,STOP.ER)
    CALL F.READ(FN.REDO.PAYMENT.STOP.ACCOUNT.HIS,Y.CUR.ID,R.REDO.PAYMENT.STOP.ACCOUNT.HIS,F.REDO.PAYMENT.STOP.ACCOUNT.HIS,STOP.HIS.ERR)
    IF R.REDO.PAYMENT.STOP.ACCOUNT OR R.REDO.PAYMENT.STOP.ACCOUNT.HIS THEN
        Y.LAST.SEQ += 1               ;** R22 Auto conversion - = Y.LAST.SEQ + TO +=
        R.REDO.PAY.STOP.SEQ<PS.SE.PAY.ID.SEQ,-1> = Y.LAST.SEQ
        ID.NEW=ID.NEW:'.':Y.LAST.SEQ
*    WRITE R.REDO.PAY.STOP.SEQ TO F.REDO.PAY.STOP.SEQ,Y.ACC ;*Tus Start
        CALL F.WRITE(FN.REDO.PAY.STOP.SEQ,Y.ACC,R.REDO.PAY.STOP.SEQ) ; * Tus End
        IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
            CALL JOURNAL.UPDATE('')
        END

        CALL F.RELEASE(FN.REDO.PAY.STOP.SEQ,Y.ACC,F.REDO.PAY.STOP.SEQ)
    END ELSE
        ID.NEW = ID.NEW:'.':Y.LAST.SEQ
    END
RETURN
*------------
GOEND:
END
