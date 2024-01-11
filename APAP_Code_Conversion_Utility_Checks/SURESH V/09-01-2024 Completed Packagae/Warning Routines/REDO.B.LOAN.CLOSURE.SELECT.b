* @ValidationCode : MjoxNTg1MTE2MTQwOkNwMTI1MjoxNzA0MTc2NTMxNjE3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Jan 2024 11:52:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LOAN.CLOSURE.SELECT
*------------------------------------------------------------------------
* Description: This is a Select routine which will run in COB
* and close the accounts of matured AA contracts
*------------------------------------------------------------------------
* Input Arg: N/A
* Ouput Arg: N/A
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE          DESCRIPTION
* 05-JAN-2012     H GANESH              PACS00174524 - B.43 Initial Draft
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - ++ TO += 1
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*02/01/2024         Suresh                R22 Manual Conversion   CALL routine modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.LOAN.CLOSURE.COMMON
    $USING EB.Service ;*R22 Manual Conversion

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------


    Y.LIST.OF.IDS = ''
    Y.LAST.WRKNG.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    SEL.CMD = 'SELECT ':FN.REDO.CONCAT.AA.CLOSURE.DAYS:' WITH @ID GT ':Y.LAST.WRKNG.DATE:' AND @ID LE ':TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.LOOP = 1
    LOOP
    WHILE Y.LOOP LE SEL.NOR
        Y.ID = SEL.LIST<Y.LOOP>
        CALL F.READ(FN.REDO.CONCAT.AA.CLOSURE.DAYS,Y.ID,R.REDO.CONCAT.AA.CLOSURE.DAYS,F.REDO.CONCAT.AA.CLOSURE.DAYS,CNCT.ERR)
        Y.LIST.OF.IDS<-1> = R.REDO.CONCAT.AA.CLOSURE.DAYS
        Y.LOOP += 1
    REPEAT

*    CALL BATCH.BUILD.LIST('',Y.LIST.OF.IDS)
    EB.Service.BatchBuildList('',Y.LIST.OF.IDS) ;*R22 Manual Conversion

RETURN
END
