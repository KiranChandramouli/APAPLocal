* @ValidationCode : MjoxMzg5NjkyNTU3OkNwMTI1MjoxNjg0MjIyODA3MjM1OklUU1M6LTE6LTE6LTEwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.DEL.COND.RESTRUCTURE.SELECT
*----------------------------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the SELECT routine of the batch job REDO.B.LOAN.STATUS.ELIMINATION
*   which updates the local reference fields LOAN.STATUS and LOAN.CONDITIN based on the conditions
* This routine selects AA.ARR.OVERDUE application ids in which either the Loan Status or
*   Loan Condition field has value and passes the arrangement id alone to the record routine
* This routine removes the duplicate arrangement id if more than one OVERDUE record is present for the same arrangement
*
* ----------------------------------------------------------------------------------------------------------------------
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
*   Date               who           Reference                     Description
* 03-JUN-2010   N.Satheesh Kumar  TAM-ODR-2009-10-0331           Initial Creation
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_LOAN.STATUS.ELIMINATION.COMMON
   $USING EB.Service

    GOSUB SELECT.OD.IDS
RETURN

*-------------
SELECT.OD.IDS:
*-------------
*-------------------------------------------------------------------------------------------------------
* This section selects AA.ARR.OVERDUE records which has value either in Loan Status or Loan conditon field
*-------------------------------------------------------------------------------------------------------

    Y.CNTR = 0
    LOOP
    WHILE Y.CNTR LT 1 DO
        SEL.OFS = 'SELECT ':FN.OFS
        CALL EB.READLIST(SEL.OFS,SEL.LIS,'',NO.OFS,OF.ERR)
        IF NO.OFS EQ 0  THEN
            Y.CNTR = 2
        END
    REPEAT

    OD.SEL.CMD = 'SELECT ':FN.AA.ARRANGEMENT: ' WITH ARR.STATUS EQ CURRENT OR WITH ARR.STATUS EQ EXPIRED '
    CALL EB.READLIST(OD.SEL.CMD,OD.SEL.LST,'',NO.REC,SEL.ERR)
    PROCESSED.ARR.ID = OD.SEL.LST
*    CALL BATCH.BUILD.LIST('',PROCESSED.ARR.ID)
EB.Service.BatchBuildList('',PROCESSED.ARR.ID);* R22 UTILITY AUTO CONVERSION
RETURN

END
