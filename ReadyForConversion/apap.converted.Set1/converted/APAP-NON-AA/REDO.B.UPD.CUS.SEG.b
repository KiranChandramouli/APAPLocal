SUBROUTINE REDO.B.UPD.CUS.SEG(CUS.DET)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine updates CUSTOMER application with the data received from the external file
* ------------------------------------------------------------------------------------------
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
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar   ODR-2009-12-0281      Initial Creation
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    $INSERT I_REDO.B.UPD.CUS.SEG.COMMON

    GOSUB INIT
    GOSUB GET.VAL
    GOSUB UPDATE.CUS

RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    CUS.ID = ''
    APAP.CUS.SEG = ''
    APAP.OVR.SEG = ''
    R.CUSTOMER = ''
    OFSRECORD = ''
    OFS.MSG.ID = ''
    OFS.ERR = ''

RETURN

*-------
GET.VAL:
*-------
*--------------------------------------------------------------------------------------------------
* This section stores incoming customer details to be updated in variables and read CUSTOMER record
*--------------------------------------------------------------------------------------------------

    CUS.ID = FIELD(CUS.DET,',',1)
    APAP.CUS.SEG = FIELD(CUS.DET,',',3)
    APAP.OVR.SEG = FIELD(CUS.DET,',',4)
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)

RETURN

*----------
UPDATE.CUS:
*----------
*--------------------------------------------------------------------------------------------------------------
* This section stores the data to be updated in R.CUSTOMER and build the OFS record and updates CUSTOMER record
*--------------------------------------------------------------------------------------------------------------

    R.CUSTOMER<EB.CUS.LOCAL.REF,CUS.SEG.POS> = APAP.CUS.SEG
    IF APAP.OVR.SEG NE '' THEN
        R.CUSTOMER<EB.CUS.LOCAL.REF,OVR.SEG.POS> = APAP.OVR.SEG
    END

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,CUS.ID,R.CUSTOMER,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
END
