* @ValidationCode : MjotNzUxOTg3NTMxOkNwMTI1MjoxNzA0MTc2NjM5NTk1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Jan 2024 11:53:59
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
SUBROUTINE REDO.B.LOAN.PRD.UPD(Y.CUSTOMER.ID)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This ia a batch routine will assign PRD.STATUS in REDO.CUST.PRD.LIST to closed when Arrangement status is MATURED
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
*
* 02-Jun-2011       Shankar Raju     PACS00063146       Initial Creation
* 26-08-2015        Maheswaran          Process date updated
* Date                   who                   Reference
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*02/01/2024         Suresh                R22 Manual Conversion   Change F.READ to F.READU
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_REDO.B.LOAN.PRD.UPD.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------------
INIT:
*----

    Y.PRD.LIST=''
    Y.GO.WRITE = ''
    POS.TYPE.CUST = ''

RETURN

*------------------------------------------------------------------------------------------
PROCESS:
*-------

*    CALL F.READ(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR)
    CALL F.READU(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR,"") ;*R22 Manual Conversion

    Y.TYP.CUST = R.CUST.PRD.LIST<PRD.TYPE.OF.CUST>
    CNT.TYP = DCOUNT(Y.TYP.CUST,@VM)
    CHANGE @VM TO @FM IN Y.TYP.CUST

    LP.CNT = 1

    LOOP
    WHILE LP.CNT LE CNT.TYP
        LOCATE 'LOAN' IN Y.TYP.CUST,LP.CNT SETTING POS.TYPE.CUST THEN
            IF R.CUST.PRD.LIST<PRD.PRD.STATUS,POS.TYPE.CUST> EQ 'ACTIVE' THEN
                GOSUB ACTIVE.PROCESS
            END
            LP.CNT = POS.TYPE.CUST+1
        END ELSE
            LP.CNT = CNT.TYP + 1
        END
    REPEAT

    IF Y.GO.WRITE THEN
        CALL F.WRITE(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST)
    END

RETURN

ACTIVE.PROCESS:
*--------------
    Y.PRD.ID = R.CUST.PRD.LIST<PRD.PRODUCT.ID,POS.TYPE.CUST>
    CALL F.READ(FN.ACCOUNT,Y.PRD.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
    Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR.AA.ARR)
*TUS AA Changes 20161021
*  IF R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS> EQ 'MATURED' THEN
    IF R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS> EQ 'PENDING.CLOSURE' THEN
*TUS END
        R.CUST.PRD.LIST<PRD.PRD.STATUS,POS.TYPE.CUST> ='CLOSED'
        R.CUST.PRD.LIST<PRD.DATE,POS.TYPE.CUST> = TODAY
        R.CUST.PRD.LIST<PRD.PROCESS.DATE> = TODAY     ;* process date updated for cob performance process
        Y.GO.WRITE = 1
    END

RETURN
*------------------------------------------------------------------------------------------
END
