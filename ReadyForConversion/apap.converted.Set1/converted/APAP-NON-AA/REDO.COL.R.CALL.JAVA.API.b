SUBROUTINE REDO.COL.R.CALL.JAVA.API(Y.EB.API.ID, Y.REQUEST, Y.RESPONSE)
*-----------------------------------------------------------------------------
* Call API on JAVA
* @author youremail@temenos.com
* @stereotype subroutine
* @package infra.eb
*
* Parameters:
*                  Y.EB.API.ID (in)  Id from EB.API that represents the api to be call
*                  Y.REQUEST   (in)  parameters to deliver to the java api
*                  Y.REPONSE   (out) blank then everything ok, otherwise an error occurs
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.CALLJ.ERROR = ''
    ETEXT = ""
    CALL EB.CALL.JAVA.API(Y.EB.API.ID, Y.REQUEST, Y.RESPONSE, Y.CALLJ.ERROR)
    IF ETEXT NE "" THEN
        Y.RESPONSE = ETEXT
    END
    GOSUB HANDLE.FAILURE

RETURN
*-----------------------------------------------------------------------------
HANDLE.FAILURE:
*-----------------------------------------------------------------------------
* Return the CALLJ error (if any)

    IF (Y.CALLJ.ERROR NE '') THEN
        Y.RESPONSE = 'Error in invoking Java interface - CALLJ error code :' : Y.CALLJ.ERROR
    END ELSE
        IF (Y.RESPONSE NE "") THEN
            Y.STATUS = CHANGE(Y.RESPONSE, '|', @FM)
            IF Y.STATUS<1> EQ '0' THEN
                Y.RESPONSE = ""       ;* EVERY THING OK
            END
        END
    END

RETURN


RETURN

END
