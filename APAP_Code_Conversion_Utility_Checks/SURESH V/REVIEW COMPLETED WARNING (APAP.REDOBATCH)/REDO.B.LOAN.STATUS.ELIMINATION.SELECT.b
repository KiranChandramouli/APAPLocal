* @ValidationCode : MjotMTUwNTM3NjA4MzpDcDEyNTI6MTcwNDE4OTgyNDMwNjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jan 2024 15:33:44
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
SUBROUTINE REDO.B.LOAN.STATUS.ELIMINATION.SELECT
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
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 AUTO CONVERSION   IDVAR Variable Changed
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_LOAN.STATUS.ELIMINATION.COMMON
    $USING EB.Service ;* R22 AUTO CONVERSION

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
*CALL BATCH.BUILD.LIST('',PROCESSED.ARR.ID)
    EB.Service.BatchBuildList('',PROCESSED.ARR.ID);* R22 AUTO CONVERSION
RETURN

END
