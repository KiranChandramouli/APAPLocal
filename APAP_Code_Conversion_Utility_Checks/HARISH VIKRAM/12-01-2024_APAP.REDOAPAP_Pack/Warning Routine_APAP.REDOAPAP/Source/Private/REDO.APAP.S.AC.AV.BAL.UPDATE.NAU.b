* @ValidationCode : MjoxNjc4Mjk0MTgxOlVURi04OjE3MDUwNTQ1MDA3NDI6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2024 15:45:00
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP


SUBROUTINE REDO.APAP.S.AC.AV.BAL.UPDATE.NAU(FN.ENTRY.FILE,ENTRY.TYPE,FORWARD,ENTRY.REC,YACCT.OVERRIDES)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.S.AC.AV.BAL.UPDATE.NAU
*--------------------------------------------------------------------------------------------------------
*Description       : This is an ACCOUNT.PARAMETER routine, this routine is used to update the local reference
*                    field L.AC.AV.BAL which will be difference between the amount of WORKING.BALANCE and
*                    LOCKED.AMOUNT
*Linked With       : ACCOUNT.PARAMETER
*In  Parameter     : FN.ENTRY.FILE, ENTRY.TYPE, FORWARD, ENTRY.REC
*Out Parameter     : YACCT.OVERRIDES
*Files  Used       : ACCOUNT                             As              I-O             Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                  Description
*   ------             -----                 -------------               -------------
* 22 Nov 2010       Shiva Prasad Y          ODR-2010-07-0080 SC001      Initial Creation
* 10 FEB 2011       Shankar                   HD1100610                     HD fix
* 13 Apr 2011       H Ganesh                PACS00054323 - CR012        Changed made for locked amount calculation
* 05 JUN 2011       Prabhu N              PACS00071064                  Changed made for locked amount calculation
* 01/11/2023	  VIGNESHWARI    ADDED COMMENT FOR INTERFACE CHANGES      Interface Change by Santiago
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                			 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   		VM to @VM
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION 		NO CHANGE
*27-11-2023	  VIGNESHWARI                 ADDED COMMENT FOR INTERFACE CHANGES     SQA-11380  - By Santiago
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
* Tus start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus end
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
*IF APPLICATION EQ 'ACCOUNT' THEN

*    IF ENTRY.REC<3> GT 0 THEN 	;*Interface Change by Santiago-COMMENTED-START
*        RETURN
*    END	;*Interface Change by Santiago-END
    Y.FLAG = ''

    GOSUB CHECK.ACCOUNT

    IF Y.FLAG THEN
        RETURN
    END

    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB CALC.AV.BAL
*END

RETURN
*--------------------------------------------------------------------------------------------------------
**************
CHECK.ACCOUNT:
**************

*CHECK FOR APPLICATION ADDED AS A SOLUTION FOR HD1100610

    ACCOUNT.ID = ENTRY.REC<1>

    IF NOT(ACCOUNT.ID) THEN
        Y.FLAG = 1
        RETURN
    END
    IF NOT(NUM(ACCOUNT.ID)) THEN
        Y.FLAG = 1
        RETURN
    END
    IF LEN(ACCOUNT.ID) GT 19 THEN       ;* This is to check whether account no is less than 19 character. Array not formed properly for SEC.TRADE during INAU status
        Y.FLAG = 1
        RETURN
    END

    GOSUB READ.ACCOUNT

    IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
        Y.FLAG = 1
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************
CALC.AV.BAL:
************
    Y.AC.AV.BAL = 0
* Y.AMT = R.ACCOUNT<AC.WORKING.BALANCE> ;* Tus start
    Y.AMT = R.ECB<ECB.WORKING.BALANCE>  ;* Tus end
    GOSUB GET.LOCKED.AMOUNT

    Y.N.AMT=ENTRY.REC<3>		;*Interface Change by Santiago-NEWLINE IS ADDED
    IF Y.N.AMT LT 0 THEN			;*FIX SQA-11380  - By Santiago-NEW LINES ADDED-START
        Y.TOTAL=Y.AMT
    END ELSE			;*FIX SQA-11380  - By Santiago-END
        Y.TOTAL=Y.AMT+Y.N.AMT       ;*Interface Change by Santiago-NEW LINE IS ADDED
    END	;*FIX SQA-11380  - By Santiago-New lines added
    Y.AC.AV.BAL = Y.TOTAL - Y.LOCK.AMT		;*Interface Change by Santiago - "Y.AMT" changed to "Y.TOTAL"

    IF R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> EQ Y.AC.AV.BAL THEN
        RETURN
    END

    R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> = Y.AC.AV.BAL

    GOSUB WRITE.ACCOUNT

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.LOCKED.AMOUNT:
******************
    Y.LOCK.AMT = 0
    IF NOT(R.ACCOUNT<AC.FROM.DATE>) THEN
        Y.LOCK.AMT = 0
        RETURN
    END

    Y.DATE.COUNT = DCOUNT(R.ACCOUNT<AC.FROM.DATE>,@VM)
    Y.DATE.START = 1

    LOOP
    WHILE Y.DATE.START LE Y.DATE.COUNT
        IF  R.ACCOUNT<AC.FROM.DATE,Y.DATE.START> LE TODAY THEN
            Y.LOCK.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT,Y.DATE.START>
        END

*       IF TODAY GE R.ACCOUNT<AC.FROM.DATE,Y.DATE.START> AND TODAY LT R.ACCOUNT<AC.FROM.DATE,Y.DATE.START+1> THEN
*           Y.LOCK.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT,Y.DATE.START>
*           BREAK
*    END
        Y.DATE.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************

    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
*CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
    CALL F.READU(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER,'');* R22 Utility Changes
* Tus start
    R.ECB = '' ; ECB.ERR =''
    CALL EB.READ.HVT('EB.CONTRACT.BALANCES',ACCOUNT.ID,R.ECB,ECB.ERR)

* Tus end

RETURN
*--------------------------------------------------------------------------------------------------------
**************
WRITE.ACCOUNT:
**************
    CALL F.WRITE(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'ACCOUNT'
    FLD.ARRAY  = 'L.AC.AV.BAL'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.AC.AV.BAL.POS =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
