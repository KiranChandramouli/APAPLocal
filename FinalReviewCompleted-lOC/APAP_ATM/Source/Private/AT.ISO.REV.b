* @ValidationCode : Mjo2NTk0NzM5NzpDcDEyNTI6MTY4NDc0ODUyMjM1NTpJVFNTOi0xOi0xOjMwMzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 May 2023 15:12:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 303
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE AT.ISO.REV(AT.UNIQUE.ID,RET.FUNC.ID)
*
* Subroutine Type : PROCEDURE
* Attached to     : INTRF.MAPPING
* Attached as     :
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 12 JAN 07 - Ganesh Prasad K
*            ISO 8583 ATM
*
* 10 DEC 10- Akthar Rasool S
*            ODR-2010-08-0469
*--------------------------------
*Modification Description:
*-------------------------
*Included I_AT.ISO.COMMON
*Include PARTIAL.REV.FLAG variable.
* ODR-2010-08-0469
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.VERSION
    $INSERT I_GTS.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.DATES
*

    $INSERT I_F.ATM.BRANCH
    $INSERT I_F.ATM.REVERSAL
*
    $INSERT I_AT.ISO.COMMON
    $USING APAP.REDOCHNLS


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
    GOSUB GET.BRANCH.TXN.HAPPENED
    GOSUB CHECK.ORIGINAL.TXN


RETURN          ;* from PROCESS
*-----------------------------------------------------------------------------------
CHECK.ORIGINAL.TXN:
*------------------*

    AT.REV.ID =FIELD(AT.UNIQUE.ID,'%',1):'.':FIELD(AT.UNIQUE.ID,'%',2)
    CALL CACHE.READ(FN.ATM.REVERSAL,AT.REV.ID,R.ATM.REVERSAL,ER.ATM.REVERSAL)

    IF NOT(R.ATM.REVERSAL) THEN
        Y.AT.REV.ID=AT.REV.ID
*  CALL REDO.ATM.CHK.REVERSAL.REC(AT.REV.ID,R.ATM.REVERSAL)
        CALL APAP.REDOCHNLS.redoAtmChkReversalRec(AT.REV.ID,R.ATM.REVERSAL) ;*R22 MANUAL CODE CONVERSION

*    LEN.AT.REV.ID = LEN(AT.REV.ID)
*    UNIQUE.ID = 220:AT.REV.ID[4,LEN.AT.REV.ID-3]        ;*Sometimes we don't get the exact MTI for reversal of advices
*    CALL CACHE.READ(FN.ATM.REVERSAL,UNIQUE.ID,R.ATM.REVERSAL,ER.ATM.REVERSAL)
    END
    IF R.ATM.REVERSAL THEN
        GOSUB CHECK.ORIGINAL.TXN.DATE
        GOSUB CHECK.ORIGINAL.TXN.AMT    ;* Handle partial reversal here

    END ELSE
        R.VERSION(EB.VER.GTS.CONTROL) = '4'       ;* Reversal where we can't find an original txn
        TODAY.TXN  =''
*CALL RAD.LOG.MSG('ATM','INFO',"Couldn't find Original txn for reversal ":AT.REV.ID)
        CALL APAP.ATM.radLogMsg('ATM','INFO',"Couldn't find Original txn for reversal ":AT.REV.ID) ;*R22 MANUAL CODE CONVERSION
        AT$AT.ISO.RESP.CODE = '90'
    END

    IF UNASSIGNED(TODAY.TXN) THEN
        TODAY.TXN =''
    END

    IF TODAY.TXN AND NOT(PARTIAL.REV.FLAG) THEN
        RET.FUNC.ID = 'R/':ORIGINAL.TXN.ID
    END ELSE
        IF PARTIAL.REV.FLAG THEN
            RET.FUNC.ID ='I/'
            PART.REV.MSG='R/':ORIGINAL.TXN.ID
        END
    END

    IF NOT(TODAY.TXN) THEN
        RET.FUNC.ID = 'R/':ORIGINAL.TXN.ID
    END

RETURN          ;*From CHECK.ORIGINAL.TXN

*-----------------------------------------------------------------------------------
*
CHECK.ORIGINAL.TXN.DATE:
*-----------------------*

    ORIGINAL.TXN.ID = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
    IF ORIGINAL.TXN.ID THEN
        JUL.DATE = R.DATES(EB.DAT.JULIAN.DATE)
        CHECK.JUL = JUL.DATE[3,5]
        TXN.JUL.DATE = ORIGINAL.TXN.ID[3,5]       ;* If ID includes DAO test and fix here
        TXN.JUL.DATE.1=ORIGINAL.TXN.ID[5,5]
        IF CHECK.JUL EQ TXN.JUL.DATE OR CHECK.JUL EQ TXN.JUL.DATE.1  THEN
            TODAY.TXN = 1     ;* Reversal possible if the amt matches
        END ELSE
            TODAY.TXN = ''    ;* Contra required
*  CALL RAD.LOG.MSG('ATM','INFO',"Txn date NE Reversal Date ":ORIGINAL.TXN.ID:"--":CHECK.JUL)
            CALL APAP.ATM.radLogMsg('ATM','INFO',"Txn date NE Reversal Date ":ORIGINAL.TXN.ID:"--":CHECK.JUL);*R22 MANUAL CODE CONVERSION
        END
    END

RETURN          ;*From CHECK.ORIGINAL.TXN.DATE

*-----------------------------------------------------------------------------------
CHECK.ORIGINAL.TXN.AMT:
*----------------------*
    REV.AMT = FIELD(AT.UNIQUE.ID,'%',3)[1,12]
    REV.AMT = REV.AMT[1,10]:'.':REV.AMT[11,2]
    REV.AMT = TRIM(REV.AMT,'0','L')   * 1
    TXN.AMT = R.ATM.REVERSAL<AT.REV.TXN.AMOUNT> * 1

    IF REV.AMT NE '0' AND REV.AMT NE TXN.AMT AND TXN.AMT NE '0' THEN
        PARTIAL.REV.FLAG = 1
* CALL RAD.LOG.MSG("ATM","INFO","Partial reversal ":TXN.AMT:" ":REV.AMT)
        CALL APAP.ATM.radLogMsg("ATM","INFO","Partial reversal ":TXN.AMT:" ":REV.AMT) ;*r22 manual code conversion
    END


RETURN          ;*From CHECK.ORIGINAL TXN.AMT
*-----------------------------------------------------------------------------------
GET.BRANCH.TXN.HAPPENED:
*----------------------*
    AT.REV.ID =FIELD(AT.UNIQUE.ID,'%',2)
    CALL CACHE.READ(FN.ATM.REVERSAL,AT.REV.ID,R.ATM.REVERSAL,ER.ATM.REVERSAL)

    ATM.BRANCH.ID = FIELD(AT.UNIQUE.ID,'%',1)
*Modified for PACS00054730---------------------------------------------------
    CALL CACHE.READ(FN.ATM.BRANCH,ATM.BRANCH.ID,R.ATM.BRANCH,ER.ATM.BRANCH)
*End of Modification--------------------------------------------------------
    IF ER.ATM.BRANCH THEN
        CALL CACHE.READ(FN.ATM.BRANCH,'HBDF01',R.ATM.BRANCH,ER.ATM.BRANCH)
    END

    Y.ACCT.COMP.CDE = R.ATM.BRANCH<ATM.BR.COMPANY.CODE>

    CALL CACHE.READ(FN.COMPANY,Y.ACCT.COMP.CDE,REC.COMPANY,ER.COMPANY)
    MNEMONIC = REC.COMPANY<EB.COM.FINANCIAL.MNE>

    FN.FUNDS.TRANSFER = 'F':MNEMONIC:'.FUNDS.TRANSFER'
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  =''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

RETURN          ;*From GET.BRANCH.TXN.HAPPENED

*
*-----------------------------------------------------------------------------------*



*-----------------------------------------------------------------------------------*
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:

    PROCESS.GOAHEAD = 1
    PARTIAL.REV.FLAG =''

    ER.ATM.BRANCH = ''

RETURN          ;* From INITIALISE

*-----------------------------------------------------------------------------------
OPEN.FILES:

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)
*
    FN.COMPANY = 'F.COMPANY'
    F.COMPANY =''
    CALL OPF(FN.COMPANY,F.COMPANY)
*
    FN.ATM.BRANCH = 'F.ATM.BRANCH'
    F.ATM.BRANCH = ''
    CALL OPF(FN.ATM.BRANCH,F.ATM.BRANCH)
*
    FN.CURRENCY = 'F.CURRENCY'





RETURN          ;* From OPEN.FILES

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*
* Check for any Pre requisite conditions - like the existence of a record/parameter etc
* if not, set PROCESS.GOAHEAD to 0
*
* When adding more CASEs, remember to assign the number of CASE statements to MAX.LOOPS
*
*
    LOOP.CNT = 1 ; MAX.LOOPS = 2
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1


            CASE LOOP.CNT EQ 2

            CASE LOOP.CNT EQ 3

        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN          ;* From CHECK.PRELIM.CONDITIONS
*-----------------------------------------------------------------------------------
END
