* @ValidationCode : MjotMzU5MTgzMjk5OkNwMTI1MjoxNjgzMDEwNzYwNDUwOklUU1M6LTE6LTE6MTk3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 12:29:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 197
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.CHK.NO.OVERDUE
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is attached as validation routine for the field Arrangement in FUNDS.TRANSFER,AA.LS.LC.ACRP
* This routine displays error message when overdue exist for the arrangement
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : REDO.V.DEF.FT.LOAN.STATUS.COND
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 07-JUN-2010   N.Satheesh Kumar   ODR-2009-10-0331      Initial Creation
*Modification history
*Date                Who               Reference                  Description
*13-04-2023      conversion tool     R22 Auto code conversion     No changes
*13-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON


    IF OFS$OPERATION EQ 'VALIDATE' THEN
        RETURN
    END
*Return in Commit stage
    IF cTxn_CommitRequests EQ '1' THEN
        RETURN
    END






    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END

    APAP.REDOVER.redoVDefFtLoanStatusCond() ;* R22 Manual conversion
    IF ETEXT NE '' THEN
        RETURN
    END
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    ARR.ID = ECOMI
    R.AA.ACCOUNT.DETAILS = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AC.DET.ERR)
    IF R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS> NE 'CUR' THEN
        ETEXT = 'EB-OVERDUE'
        CALL STORE.END.ERROR
    END ELSE
        APAP.REDOVER.redoVValDefaultAmt();* R22 Manual Conversion
    END
RETURN
END
