* @ValidationCode : MjotMzI2ODQ1ODkzOlVURi04OjE2OTI2MDQwMzU2NDU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Aug 2023 13:17:15
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
$PACKAGE APAP.TESTAPAP
*-----------------------------------------------------------------------------
* <Rating>-6</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CRF.NWGL.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*  DATE               NAME                       REFERENCE                           DESCRIPTION
* 31 JAN 2023    Edwin Charles D               ACCOUNTING-CR                             TSR479892
* 21 AUG 2023    Narmadha V                    Manual R22 Conversion                  VM to @VM ,FM to @FM
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.RE.CRF.NWGL
    $INSERT I_F.REDO.T.ACCTSTAT.BY.DATE
    $INSERT I_F.DATES
    $INSERT I_REDO.CRF.NWGL.COMMON
    $INSERT I_REDO.PREVAL.STATUS.COMMON

    Y.COMP = ID.COMPANY
    R.DATE = ''
    CALL F.READ(FN.DATES,Y.COMP,R.DATE,F.DATES,DAT.ERR)
    CUR.DATE = R.DATE<EB.DAT.LAST.WORKING.DAY>

    CALL F.READ(FN.REDO.T.ACCTSTAT.BY.DATE,CUR.DATE,SEL.LIST,F.REDO.T.ACCTSTAT.BY.DATE,DAT.ERR)
    CHANGE @VM TO @FM IN SEL.LIST

    CALL BATCH.BUILD.LIST('',SEL.LIST)

*    IF Y.COMP EQ 'DO0010001' THEN
*        OFS.STRING = "ENQUIRY.REPORT,/V/PROCESS//0/,//////,CRB.REPORT.REGL"
*        OFS.SOURCE.ID<1> = 'OFSUPDATE'
*        OFS.RESP   = ""
*        TXN.COMMIT = ""
*        CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID,OFS.STRING,OFS.RESP,TXN.COMMIT)
*    END

RETURN

END
