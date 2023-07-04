* @ValidationCode : MjotOTY0MTQ2MjU3OkNwMTI1MjoxNjgwNzYxNjQ0NDg2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 11:44:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.AUTH.AC.AV.BAL.UPDATE

*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.V.AUTH.AC.AV.BAL.UPDATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is an AUTH routine, this routine is used to update the local reference
*                    field L.AC.AV.BAL which will be difference between the amount of WORKING.BALANCE and
*                    LOCKED.AMOUNT
*Linked With       : Version Control - AC.LOCKED.EVENTS
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : ACCOUNT                             As              I-O             Mode
*                    AC.LOCKED.EVENT                     As              I-O             Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                  Description
*   ------             -----                 -------------               -------------
* 22 Nov 2010       Shiva Prasad Y       ODR-2010-11-0196 CR012         Initial Creation
* 19 JAN 2011       Balagurunathan       ODR-2010-08-0469 B.166.B       Bug corrected in updating Available amount
* 02 MAR 2011       Shankar Raju         PACS00033057                   Updation of L.AC.AV.BAL field issue fix
* 02 jun 2011        Prabhu  N           PACS00071064                  routine modified to support update in ALE
* Date                  who                   Reference              
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.LOCKED.EVENTS
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

    IF R.NEW(AC.LCK.FROM.DATE) GT TODAY THEN
        RETURN
    END

    ACCOUNT.ID = R.NEW(AC.LCK.ACCOUNT.NUMBER)

    GOSUB READ.ACCOUNT
    GOSUB FIND.MULTI.LOCAL.REF

*-----PACS00033057....Start---
* At authorisation of AC.LOCKED.EVENTS record, the locked amount with from date < today will be calculated
* as WORKING.BALANCE - TOTAL.LOCKED.AMOUNT

    IF (V$FUNCTION EQ 'R') OR (R.NEW(AC.LCK.RECORD.STATUS) EQ 'RNAU') THEN

        Y.AMT = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> + R.NEW(AC.LCK.LOCKED.AMOUNT)

    END ELSE

        IF R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> EQ '' THEN

*      Y.AMT = R.ACCOUNT<AC.WORKING.BALANCE> - R.NEW(AC.LCK.LOCKED.AMOUNT)
            Y.AMT = R.ECB<ECB.WORKING.BALANCE> - R.NEW(AC.LCK.LOCKED.AMOUNT)

        END ELSE
*PACS00071064-----Start---------------------------------------------------------------------------------------
            Y.PREV.LOCK.AMT=R.OLD(AC.LCK.LOCKED.AMOUNT)
            Y.AMT = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> - R.NEW(AC.LCK.LOCKED.AMOUNT) + Y.PREV.LOCK.AMT
*End----------------------------------------------------------------------------------------------------------

        END
    END

    IF Y.AMT EQ R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> THEN
        RETURN
    END

    R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS> = Y.AMT

    GOSUB WRITE.ACCOUNT

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
* Tus start
    R.ECB = ''; ECB.ERR = ''
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
