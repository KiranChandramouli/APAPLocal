SUBROUTINE REDO.V.AUT.CON.CLAIM
*---------------------------------------------------------------------------------
*This is an ANC routine for the version REDO.ISSUE.CLAIMS,OPEN
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : PRadeep S
* Program Name  : REDO.V.AUT.CON.CLAIM
* ODR NUMBER    :
* HD Reference  : PACS00071941
* LINKED WITH   : REDO.ISSUE.CLAIMS
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
* MODIFICATION DETAILS:
* Who               Who              Reference           Description
* 12-05-2011        Pradeep S        PACS00071941        Initial Creation
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.ISSUE.CLAIMS

    GOSUB PROCESS
RETURN

PROCESS:
    Y.CURRENT.REC=System.getVariable("CURRENT.REC")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CURRENT.REC = ""
    END

    CHANGE '*##' TO @FM IN Y.CURRENT.REC
    MATPARSE R.NEW FROM Y.CURRENT.REC

    R.NEW(ISS.CL.OPENING.DATE) = TODAY
    Y.TIME = OCONV(TIME(), 'MTS')
    R.NEW(ISS.CL.RECEPTION.TIME) = Y.TIME

RETURN
END
