* @ValidationCode : MjotMTg5MTk2NDYwOkNwMTI1MjoxNjg0ODQ1NjIyMTEyOklUU1M6LTE6LTE6ODM6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 83
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.RVK.CHQ
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would serve as a cross validation level validation routine
* The purpose of this routine is to check the field STOPPAYMENT.STATUS,
* depending upon the value of STOP.PAYMENT.STATUS system should populate
*  the EXPIRY.DATE and  STOP.CHEQ.VALIDITY
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 25-Nov-2009       SHANKAR RAJU                         Initial Creation
* 07-04-2011        Manju.G          PACS00023947        EB.ERROR for CONFIRM-NONCONFIRM
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*12-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM,START.COUNT + 1 TO +=1
*12-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT

*------------------------------MAIN-------------------------------------

    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------

*------------------------------INIT-------------------------------------
INIT:

    FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT.STOP.ACCOUNT = ''

    CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)

RETURN
*-----------------------------------------------------------------------

*-----------------------------------------------------------------------
PROCESS:

    CHQ.STATUS    =  R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS)
    STATUS.NOS    =  DCOUNT(CHQ.STATUS,@VM)

    START.COUNT = 1

    LOOP
    WHILE START.COUNT LE STATUS.NOS

        Y.VALUE = R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS)<1,START.COUNT>
        IF Y.VALUE EQ 'CONFIRMED' THEN

            VALUE.NEW = R.OLD(REDO.PS.ACCT.PAY.STOP.STATUS)<1,START.COUNT>

            IF VALUE.NEW EQ 'NONCONFIRMED' OR VALUE.NEW EQ 'NONE' THEN
                ETEXT = 'EB-STATUS.NON'
                AF= REDO.PS.ACCT.PAY.STOP.STATUS
                AV = START.COUNT
                CALL STORE.END.ERROR

            END
        END
*PACS00023947-S
        IF Y.VALUE EQ 'NONCONFIRMED' THEN
            VALUE.NEW = R.OLD(REDO.PS.ACCT.PAY.STOP.STATUS)<1,START.COUNT>
            IF VALUE.NEW EQ 'CONFIRMED' OR VALUE.NEW EQ 'NONE' THEN
                ETEXT = 'EB-STATUS'
                AF= REDO.PS.ACCT.PAY.STOP.STATUS
                AV = START.COUNT
                CALL STORE.END.ERROR
            END
        END
*PACS00023947-E
        START.COUNT += 1

    REPEAT

RETURN
*-----------------------------------------------------------------------
END
