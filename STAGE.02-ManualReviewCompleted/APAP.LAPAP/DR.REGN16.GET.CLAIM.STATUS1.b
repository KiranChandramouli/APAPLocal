$PACKAGE APAP.LAPAP
SUBROUTINE DR.REGN16.GET.CLAIM.STATUS1
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 05-09-2014        Ashokkumar                PACS00366332- Updated the PENDING-DOCUMENTATION
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INSERT TAM.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*-----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_DR.REG.REGN16.EXTRACT.COMMON

    CLAIM.ID = COMI
    CLAIM.STATUS = ''
    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)
    R.REDO.ISSUE.CLAIMS = ''
    CALL F.READ(FN.REDO.ISSUE.CLAIMS,CLAIM.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,REDO.ISSUE.CLAIMS.ERR)
    BEGIN CASE
        CASE R.REDO.ISSUE.CLAIMS<ISS.CL.CLOSING.STATUS> EQ 'ACCEPTED'
            CLAIM.STATUS = 'F'
        CASE R.REDO.ISSUE.CLAIMS<ISS.CL.CLOSING.STATUS> EQ 'REJECTED' OR R.REDO.ISSUE.CLAIMS<ISS.CL.CLOSING.STATUS>EQ 'REJECTED-CUSTOMER'
            CLAIM.STATUS = 'D'
        CASE R.REDO.ISSUE.CLAIMS<ISS.CL.CLOSING.STATUS> EQ 'PENDING-DOCUMENTATION'
            CLAIM.STATUS = 'P'
        CASE R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS> EQ 'IN-PROCESS' OR R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS> EQ 'OPEN'
            CLAIM.STATUS = 'P'
    END CASE

    COMI = CLAIM.STATUS

RETURN
END
