$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.METHOD.PAY
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is used to get the description from EB.LOOKUP of L.AZ.METHOD.PAY
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : O.DATA
* OUT : O.DATA
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 30-09-2013          Karthi      ODR-2010-03-0094      Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - = to EQ
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
    Y.EB.LOOK.ID = ''
    R.EB.LOOKUP = ''
    Y.EB.LOOK.ERROR = ''
    Y.DESC.LOOKUP = ''

RETURN

PROCESS:

    Y.EB.LOOK.ID = 'L.AZ.METHOD.PAY*':O.DATA
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOK.ID,R.EB.LOOKUP,F.EB.LOOKUP,Y.EB.LOOK.ERROR)
    IF R.EB.LOOKUP THEN
        Y.DESC.LOOKUP = R.EB.LOOKUP<EB.LU.DESCRIPTION>
        O.DATA = Y.DESC.LOOKUP<1,LNGG>
        IF O.DATA EQ '' THEN
            O.DATA = Y.DESC.LOOKUP<1,1>
        END
    END
RETURN
END
