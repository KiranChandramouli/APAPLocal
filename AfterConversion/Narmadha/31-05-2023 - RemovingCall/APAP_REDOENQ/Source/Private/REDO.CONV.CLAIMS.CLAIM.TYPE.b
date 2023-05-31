$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CLAIMS.CLAIM.TYPE
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.U.CRM.CLAIM.TYPE
    GOSUB INITIALSE
    GOSUB CHECK.NOTES

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP  = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.REDO.U.CRM.CLAIM.TYPE='F.REDO.U.CRM.CLAIM.TYPE'
    F.REDO.U.CRM.CLAIM.TYPE=''
    CALL OPF(FN.REDO.U.CRM.CLAIM.TYPE,F.REDO.U.CRM.CLAIM.TYPE)

RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
    Y.REC.DATA = O.DATA
    CALL F.READ(FN.REDO.U.CRM.CLAIM.TYPE,Y.REC.DATA,R.REDO.U.CRM.CLAIM.TYPE,F.REDO.U.CRM.CLAIM.TYPE,LOOKUP.ERR)
    IF LNGG EQ 1 THEN
        O.DATA = R.REDO.U.CRM.CLAIM.TYPE<CLAIM.TYPE.DESCRIPTION,1>
        RETURN
    END
    IF LNGG EQ 2 THEN
        IF R.REDO.U.CRM.CLAIM.TYPE<EB.LU.DESCRIPTION,2> THEN
            O.DATA = R.REDO.U.CRM.CLAIM.TYPE<CLAIM.TYPE.DESCRIPTION,2>
        END ELSE
            O.DATA = R.REDO.U.CRM.CLAIM.TYPE<CLAIM.TYPE.DESCRIPTION,1>
        END
    END

RETURN
*-------------------------------------------------------------------------
END
